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
            redirect_to root_path
        end
    end
end
