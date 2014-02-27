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
      current_user.tag(@post, :with => params[:post][:tag_list], :on => :tags)
      flash[:success] = "Post created!"
      redirect_to @post
    else
      render 'new'
    end
	end 

  def show
    @post = Post.find(params[:id])
    @tags = @post.tag_list
    @user = User.find(@post.user_id)
  end

  def destroy
    @post.destroy
    redirect_to root_url
  end

  private
    def post_params
      params.require(:post).permit(:title, :content, :tag_list)
    end

    def correct_user
      @post = Post.find_by(id: params[:id])
      redirect_to root_url unless current_user?(@post.user)||current_user.admin?
    end
end