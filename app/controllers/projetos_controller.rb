class ProjetosController < ApplicationController
  protect_from_forgery with: :exception
  before_action :set_projeto, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]
  before_action :load_entidades
  before_action only: [:edit, :update, :destroy] { check_owner Projeto.friendly.find(params[:id]).entidade.user_id }

  # GET /projetos
  # GET /projetos.json
  def index
    if params[:entidade_id]
      @projetos = Entidade.friendly.find(params[:entidade_id]).projetos
    else
      @projetos = Projeto.all
    end
  end

  # GET /projetos/1
  # GET /projetos/1.json
  def show
  end

  # GET /projetos/new
  def new
    @projeto = Projeto.new
  end

  # GET /projetos/1/edit
  def edit
  end

  # POST /projetos
  # POST /projetos.json
  def create
    @projeto = Projeto.new(projeto_params)

    respond_to do |format|
      if @projeto.save
        format.html { redirect_to @projeto, notice: 'Projeto foi adicionado(a) com sucesso.' }
        format.json { render :show, status: :created, location: @projeto }
      else
        format.html { render :new }
        format.json { render json: @projeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projetos/1
  # PATCH/PUT /projetos/1.json
  def update
    respond_to do |format|
      if @projeto.update(projeto_params)
        format.html { redirect_to @projeto, notice: 'Projeto foi alterado(a) com sucesso.' }
        format.json { render :show, status: :ok, location: @projeto }
      else
        format.html { render :edit }
        format.json { render json: @projeto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projetos/1
  # DELETE /projetos/1.json
  def destroy
    @projeto.destroy
    respond_to do |format|
      format.html { redirect_to projetos_url, notice: 'Projeto foi removido(a) com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_projeto
      @projeto = Projeto.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def projeto_params
      params.require(:projeto).permit(:nome, :descricao, :entidade_id, :imagem)
    end

    def load_entidades
      @entidades = {}
      if user_signed_in?
        @entidades = current_user.admin ? Entidade.all : Entidade.where(user_id: current_user.id)
      end
    end
end
