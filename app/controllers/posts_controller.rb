class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :kontrol, :like, :unlike]
 # before_action :authenticate_user!, only: [:new, :edit, :destroy]  
  before_action :kontrol, only: [:edit, :destroy]
  before_action :authenticate_user!, except: [:index]
  
  def kontrol
     unless @post.user==current_user
      redirect_to posts_path, notice:"Yetkiniz Yok"
    end
  end
  
  # GET /posts
  # GET /posts.json
  def index 
    if params[:user]
      @posts = Post.where(user: params[:user]).order("created_at DESC")
    else
       @posts = Post.all.order("created_at DESC")
    end
    @post=Post.new
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @likeds=Like.where(post: @post).all
    @comments=@post.comments.all
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
 def like
    @l=Like.new
    @l.post=@post
    @l.user=current_user
    @l.save
    respond_to do |format|
      format.js {render layout: false}
      format.json
    end
  end

  def unlike
    @l=Like.where(post:@post,user:current_user).first
    @l.destroy
    respond_to do |format|
      format.js {render layout: false}
      format.json
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:baslik, :icerik, :image)
    end
end
