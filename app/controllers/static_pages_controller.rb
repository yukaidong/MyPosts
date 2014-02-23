class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		@posts = Post.paginate(page: params[:page])
  	else
  		@posts = Post.paginate(page: params[:page])
  	end
  end

  def help
  end
end
