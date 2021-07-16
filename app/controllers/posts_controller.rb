class PostsController < ApplicationController

  def index
    if params[:author_id]
      @posts = Author.find(params[:author_id]).posts
    else
      @posts = Post.all
    end
  end

  def show
    if params[:author_id]
      @post = Author.find(params[:author_id]).posts.find(params[:id])
    else
      @post = Post.find(params[:id])
    end
  end


  def new
    # ensure that we're creating a new post for a valid author
    if params[:author_id] && !Author.exists?(params[:author_id])
      redirect_to authors_path, alert: "Author not found."
      # /authors
    else
    # We want to make sure that, if we capture an author_id through a nested route, 
    # we keep track of it and assign the post to that author.
    # /authors/:author_id/posts/new
    @post = Post.new(author_id: params[:author_id])
    end
  end

  def create
    @post = Post.new(post_params)
    @post.save
    redirect_to post_path(@post)
  end

  def update
    @post = Post.find_by_id(params[:id])
    @post.update(post_params)
    redirect_to post_path(@post)
  end

  # make sure that: 
  # 1) the author_id is valid
  # 2) the post matches the author.
  def edit
    if params[:author_id]
      author = Author.find_by_id(params[:author_id])
      if author.nil?
        redirect_to authors_path, alert: "Author not found."
        # /authors
      else
        @post = author.posts.find_by_id(params[:id])
        redirect_to author_posts_path(author), alert: "Post not found." if @post.nil?
        # /authors/:author_id/posts
      end
    else
      @post = Post.find_by_id(params[:id])
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :author_id)
  end
end
