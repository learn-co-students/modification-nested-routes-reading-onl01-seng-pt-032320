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
    if params[:author_id] && !Author.exists?(params[:author_id]) #if an author_id is given and an author with that id does not exist
      redirect_to authors_path, alert: "Author not found." #sends us to the view of all the authors and throws up an error message
    else
      @post = Post.new(author_id: params[:author_id]) #if an author with the given id exists it begins making a new post belonging to the author at that id
    end
  end

  def create
    @post = Post.new(post_params)
    @post.save
    redirect_to post_path(@post)
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to post_path(@post)
  end

  def edit
    if params[:author_id] #when editing, it looks to see if the params entered include an author_id
      author = Author.find_by(id: params[:author_id]) #if it does, it sets the author with that author_id as the author being played with
      if author.nil? #if there isn't an author with that author_id
        redirect_to authors_path, alert: "Author Not Found" #sends us back to the index view with all the authors and tells us that the author wasn't found
      else
        @post = author.posts.find_by(id: params) #if it is able to find an author then it sets the current post being played with to the post for that author that has the id that was entered
         redirect_to author_posts_path(author), alert: "Post not found." if @post.nil? #if there isn't a post with that id associated with the author then it sends us to the view with all the posts for the author and throws up an error message
       end
     else
    @post = Post.find(params[:id]) #if there isn't a author_id given then it sets the post being played with equal to the overall post with that id
    end
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to post_path(@post)
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :author_id)
  end
end
