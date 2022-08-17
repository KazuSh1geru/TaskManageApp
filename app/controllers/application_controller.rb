class ApplicationController < ActionController::Base
    include SessionsHelper
    def require_signed_in
        unless signed_in?
            flash[:danger] = "サインインしてください"
            redirect_to signin_url
        end
    end

    def already_signed_in
        if signed_in?
            flash[:danger] = "すでにサインインしています"
            redirect_to projects_path
        end
    end

    # def calc_creative_complete_time(creative)
    #     time_amount = 0
    #     creative.tasks.each do |task|
    #         complete_time = task.complete
    #         time_amount += complete_time
    #     end
    #     return time_amount
    # end    
    # helper_method :calc_creative_complete_time
end
