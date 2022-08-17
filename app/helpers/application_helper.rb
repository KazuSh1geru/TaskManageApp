require 'date'

GOOD_TASK_TIME = 30
BAD_TASK_TIME = 60

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
        current_date = Date.today
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

    def eval_resource

    end

    def eval_risk

    end
end
