class PostsController < ApplicationController

    before_action :authenticate_user
    # maybe maybre
    # before_action :authenticate_request
    # attr_reader :current_user

    def index
        # byebug
        @posts = Post.all.sort{|a, b| b.created_at <=> a.created_at}
        # .slice(params[:num].to_i, params[:num].to_i + 10)
        render json: @posts.to_json(include: [:likes, :user, {:comments => {include: :user}}])
    end

    def show
        @post = Post.find(params[:id])
        render json: @post
        render json: @posts
    end

    def create
        userId = JWT.decode(cookies.signed[:jwt], Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')[0]["user_id"]
        # run heroku config:set RAILS_MASTER_KEY=`cat config/master.key`
        @post = Post.new(post_params)
        @post.user_id = userId
        if !@post.save
            return render json: {status: "error", message: "Beep boop bad post"}
        end
        render json: @post
    end

    def update
        
    end

    def delete
        post = Post.find_by(params[:id])
        post.delete
        return render json: { status: "post deleted" }
    end
    
    private

    def post_params
        params.require(:post).permit(:text, :image, :location)
    end
#   def authenticate_request
#     @current_user = AuthorizeApiRequest.call(request.headers).result
#     render json: { error: 'Not Authorized' }, status: 401 unless @current_user
#   end


end
