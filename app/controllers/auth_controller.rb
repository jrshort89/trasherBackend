class AuthController < ApplicationController
    skip_before_action :authenticate_user, only: [:create]

    def create
        @user = User.find_by(username: user_login_params[:username])
        # byebug
        if @user && @user.authenticate(user_login_params[:password])
            token=encode_jwt({user_id: @user.id, username: @username})
            cookies.signed[:jwt] = {value:  token, httponly: true}
            render json: {user: @user.username, uid: @user.id}, status: :accepted
        else
            render json: {message: "Invalid username or password"}, :status => :unauthorized
         end
    end         

    def destroy
        cookies.delete(:jwt)
        render json: {message: "cookie destroyed!"}, status: :unauthorized
    end

    private

    def user_login_params
        params.require(:user).permit(:username, :password)
    end

end
