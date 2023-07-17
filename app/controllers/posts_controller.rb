class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /posts or /posts.json
  def index
      @posts = Post.order(created_at: :desc)    
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.find(params[:id])
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
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
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
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
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
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def like
    @post = Post.find(params[:id])
    @post.increment!(:likes) # Incrementa el contador de likes en 1
  
    # Crea una nueva reacción de tipo "like" para el usuario actual y el post
    @reaction = Reaction.create(post: @post, user: current_user, kind: "like", reaction_type: "like")
  
    redirect_to @post
  end
  
  def dislike
    @post = Post.find(params[:id])
    @post.increment!(:dislikes) # Incrementa el contador de dislikes en 1
  
    # Crea una nueva reacción de tipo "dislike" para el usuario actual y el post
    @reaction = Reaction.create(post: @post, user: current_user, kind: "dislike", reaction_type: "dislike")
  
    redirect_to @post
  end

  def unlike
    @post = Post.find(params[:id])
    @post.decrement!(:likes) # Decrementa el contador de likes en 1
  
    # Encuentra y elimina la reacción "like" del usuario actual y el post
    @reaction = Reaction.find_by(post: @post, user: current_user, kind: "like", reaction_type: "like")
    @reaction.destroy if @reaction.present?
  
    redirect_to @post
  end
  
  def undislike
    @post = Post.find(params[:id])
    @post.decrement!(:dislikes) # Decrementa el contador de dislikes en 1
  
    # Encuentra y elimina la reacción "dislike" del usuario actual y el post
    @reaction = Reaction.find_by(post: @post, user: current_user, kind: "dislike", reaction_type: "dislike")
    @reaction.destroy if @reaction.present?
  
    redirect_to @post
  end
  
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :description, :place, :when_went, :user_id)
    end
end
