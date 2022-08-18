GOOD_TASK_TIME = 30
BAD_TASK_TIME = 60

RESOURCE_COMFORT = 120
RESOURCE_LIMIT = 240

module ApplicationHelper
    # カレンダーを使用して、プロジェクト全体のリソース調整度を評価
    def calc_creative_complete_time(creative)
        time_amount = 0
        creative.tasks.each do |task|
            complete_time = task.complete
            time_amount += complete_time
        end
        return time_amount
    end

    def get_dead_time(creative)
        current_date = creative.created_at.to_date
        dead_time = (creative.deadline - current_date).to_i
        return dead_time
    end

    def calc_mean_complete_time(creative)
        dead_time = get_dead_time(creative)
        time_amount = calc_creative_complete_time(creative)
        if dead_time == 0
            return 0
        end
        return time_amount / dead_time
    end
    def calc_std_complete_time(creative)
        dead_time = get_dead_time(creative)
        time_amount = calc_creative_complete_time(creative)
        if dead_time == 0
            return 0
        end
        return time_amount / dead_time 
    end

    def get_task_calendar(creatives)
        calendar_hash = {}
        creatives.each do |creative|
            mean_task = calc_mean_complete_time(creative)
            deadline = creative.deadline
            dead_time = get_dead_time(creative)
            dead_time.times do |i|
                deadline -= i
                unless calendar_hash.has_key? deadline.to_s
                    calendar_hash[deadline.to_s] = mean_task
                else
                    calendar_hash[deadline.to_s] += mean_task
                end
            end
        end
        return calendar_hash
    end

    # タスク分解の粒度をカウントする
    def clasify_creatives_tasks(creatives)
        clasify_hash = {
            good: 0,
            normal: 0,
            bad: 0
        }
        creatives.each do |creative|
            creative.tasks.each do |task|
                complete_time = task.complete
                if complete_time <= GOOD_TASK_TIME
                    clasify_hash[:good] += 1
                elsif complete_time >= BAD_TASK_TIME
                    clasify_hash[:bad] += 1
                else
                    clasify_hash[:normal] += 1
                end
            end
        end
        return clasify_hash
    end

    def clasify_resources(creatives)
        clasify_hash = {
            good: 0,
            normal: 0,
            bad: 0
        }
        calender = get_task_calendar(creatives).values
        all_day = calender.length
        calender.each do |day_task|
            if day_task <= RESOURCE_COMFORT
                clasify_hash[:good] += 1
            elsif day_task >= RESOURCE_LIMIT
                clasify_hash[:bad] += 1
            else
                clasify_hash[:normal] += 1
            end
        
        end
        return clasify_hash
    end

    def calc_task_proba(creatives)
        clasify_hash = clasify_creatives_tasks(creatives)
        sum_cnt = clasify_hash.values.sum
        clasify_hash.each do |key, value|
            clasify_hash[key] = value * 1.0 / sum_cnt
        end
        return clasify_hash
    end

    def calc_resource_proba(creatives)
        clasify_hash = clasify_creatives_tasks(creatives)
        sum_cnt = clasify_hash.values.sum
        clasify_hash.each do |key, value|
            clasify_hash[key] = value * 1.0 / sum_cnt
        end
        return clasify_hash
    end
    def eval_success(creatives)
        task_proba_hash = calc_task_proba(creatives)
        resource_proba_hash = calc_resource_proba(creatives)
        return (task_proba_hash[:good] + resource_proba_hash[:good])
    end
    def eval_risk(creatives)
        task_proba_hash = calc_task_proba(creatives)
        resource_proba_hash = calc_resource_proba(creatives)
        return (task_proba_hash[:bad] + resource_proba_hash[:bad])
    end
    def project_length(creatives)
        length = 0
        current_date = creatives[0].created_at.to_date
        creatives.each do |creative|
            length = [length, get_dead_time(creative)].max
        end
        return length
    end
end