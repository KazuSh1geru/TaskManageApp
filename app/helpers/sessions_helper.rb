module SessionsHelper
    def current_user
        if @current_user
            return @current_user
        else
            @current_user = User.find_by(id: session[:user_id])
            return @current_user
        end
    end
    def signed_in?
        if current_user
            return true
        else
            return false
        end
    end

end
