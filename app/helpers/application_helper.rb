module ApplicationHelper
    # creative, projectで使用する
    def calc_creative_complete_time(creative)
        time_amount = 0
        creative.tasks.each do |task|
            complete_time = task.complete
            time_amount += complete_time
        end
        return time_amount
    end    
end
