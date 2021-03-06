class PostsController < ApplicationController
    before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /posts or /posts.json
    def demo

    end

    def import
      Post.import(params[:file])
      redirect_to root_url
    end

  def index
    @post = Post.new
    if current_user.roles.first.name == "admin"
    @posts = Post.all
    respond_to do |format|
        format.html
        format.csv { send_data @posts.to_csv }
        format.xlsx
    end

    # @q = Post.ransack(params[:q])
    # @posts = @q.result(distinct: true)
    # respond_to do |format|
    #   format.html
    #   format.csv { send_data @q.result.to_csv }
    # end
    else
      @posts = Post.where(status: :public).or(Post.where(users: current_user))
    end
  end

  # GET /posts/1 or /posts/1.json
  def show
    @comments = @post.comments.order(created_at: :desc)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post) }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post) }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :status)
    end
end
