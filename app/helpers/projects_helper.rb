SIGMA_CONST = 2

BEST_TASK_STD = 30
BEST_RESOURCE_STD = 30

module ProjectsHelper
    # タスクの集計
    def count_creative_tasks(creative)
        return creative.tasks.length
    end
    
    def std(arr_x)
        avg = arr_x.sum / arr_x.length
        arr1 = arr_x.map{|x| (x - avg) ** 2}
        return Math.sqrt(arr1.sum / arr_x.length).round(2)
    end

    def min2hour(x)
        x.fdiv(60)
    end
    # 2σ範囲でばらつくと仮定
    def over_task_pred(std, len)
        return std * len * SIGMA_CONST
    end

    def eval_resource_risk_value(creatives)
        all_resource = 60.0 * 4 * project_length(creatives)
        sum_over_task = 0
        sum_task = 0
        
        creatives.each do |creative|
            tasks_arr = creative.tasks.map{|task| task.complete}
            sum_over_task += over_task_pred(std(tasks_arr), tasks_arr.length)
            sum_task += tasks_arr.sum            
        end
        return ((sum_over_task + sum_task) - (all_resource)).fdiv(creatives.length)
    end

    def eval_task_risk_value(creatives)
        sum_over_task = 0
        tasks_length = 0
        creatives.each do |creative|
            tasks_arr = creative.tasks.map{|task| task.complete}
            sum_over_task += over_task_pred(std(tasks_arr), tasks_arr.length)
            tasks_length += tasks_arr.length
        end
        return sum_over_task.fdiv(tasks_length)
    end
    def standard_proba(p)
        (1 + p).fdiv(2)
    end
    def standard_task_val(val)
        50*(1 + BEST_TASK_STD.fdiv(val))
    end
    def standard_resource_val(val)
        50*(1 + BEST_RESOURCE_STD.fdiv(val))
    end
    def eval_risk_expect(creatives)
        task_proba_hash = calc_task_proba(creatives)
        resource_proba_hash = calc_resource_proba(creatives)
        task_expect = standard_task_val(eval_task_risk_value(creatives)) * standard_proba(task_proba_hash[:good] - task_proba_hash[:bad])
        resource_expect = standard_resource_val(eval_resource_risk_value(creatives)) * standard_proba(resource_proba_hash[:good] - resource_proba_hash[:bad])
        return task_expect, resource_expect
    end
end
