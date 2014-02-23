class PostsController < ApplicationController
	before_action :signed_in_user, only: [:new, :create, :destroy]
  before_action :correct_user, only: :destroy

  def index
    @posts = Post.paginate(page: params[:page])
  end
  
  def new
    @post = current_user.posts.build if signed_in?
  end
	
  def create
	 	@post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to @post
    else
      render 'new'
    end
	end 

  def show
    
  end

  def destroy
    @post.destroy
    redirect_to root_url
  end

  private
    def post_params
      params.require(:post).permit(:title, :content)
    end

    def correct_user
      @post = Post.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end