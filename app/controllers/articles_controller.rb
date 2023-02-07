class ArticlesController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :set_article, only: %i[ show update destroy ] 
 
  # GET /articles
  def index
    @articles = @current_user.articles if @current_user.id == params[:user_id].to_i
    render json: @articles
  end

  # GET /articles/1
  def show
      if @current_user.id == params[:user_id].to_i 
        render json: @article , status: :ok
      else
        render json: {success: false, message: "record not found" }
      end
  end

  # POST /articles
  def create
    @article = Article.new(article_params)

    if @article.save
      render json: @article, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = @current_user.articles.find(params[:id])
    end
    # Only allow a list of trusted parameters through.
    def article_params
      params.fetch(:article, {})
    end
end
