class PedidosController < ApplicationController
  protect_from_forgery with: :exception
  before_action :set_pedido, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]
  before_action :load_projetos, except: [:index]
  before_action :load_tipos_ajuda
  before_action only: [:edit, :update, :destroy] { check_owner Pedido.friendly.find(params[:id]).projeto.entidade.user_id }

  # GET /pedidos
  # GET /pedidos.json
  def index
    @pedidos = Pedido.all
    @projetos = Projeto.all
  end

  # GET /pedidos/1
  # GET /pedidos/1.json
  def show
  end

  # GET /pedidos/new
  def new
    @pedido = Pedido.new
  end

  # GET /pedidos/1/edit
  def edit
  end

  # POST /pedidos
  # POST /pedidos.json
  def create
    @pedido = Pedido.new(pedido_params)

    respond_to do |format|
      if @pedido.save
        format.html { redirect_to @pedido, notice: 'Pedido foi adicionado(a) com sucesso.' }
        format.json { render :show, status: :created, location: @pedido }
      else
        format.html { render :new }
        format.json { render json: @pedido.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pedidos/1
  # PATCH/PUT /pedidos/1.json
  def update
    respond_to do |format|
      if @pedido.update(pedido_params)
        format.html { redirect_to @pedido, notice: 'Pedido foi alterado(a) com sucesso.' }
        format.json { render :show, status: :ok, location: @pedido }
      else
        format.html { render :edit }
        format.json { render json: @pedido.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pedidos/1
  # DELETE /pedidos/1.json
  def destroy
    @pedido.destroy
    respond_to do |format|
      format.html { redirect_to pedidos_url, notice: 'Pedido foi removido(a) com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pedido
      @pedido = Pedido.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pedido_params
      params.require(:pedido).permit(:projeto_id, :tipo, :descricao)
    end

    def load_projetos
      @projetos = {}
      if user_signed_in?
        @projetos = current_user.admin ? Projeto.all : Projeto.joins(:entidade).where("entidades.user_id = #{current_user.id}")
      end
    end

    def load_tipos_ajuda
      @tipos_ajuda = { "Financeira" => "Ajuda Financeira", "Alimentos" => "Alimentos não perecíveis"  }
    end
end
