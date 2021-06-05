class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    authorize User

    @users = current_user.organisation.users

    unless params[:email].blank?
      @users = @users.where("UPPER(email) like ?", "%#{params[:email].upcase}%")       
    end

    @users = @users.page(params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
    authorize User
  end

  # GET /users/new
  def new
    authorize User

    @user = User.new
  end

  # GET /users/1/edit
  def edit
    authorize User
  end

  # POST /users
  # POST /users.json
  def create
    authorize User

    @user = User.new(user_params)
    @user.organisation = current_user.organisation
    @user.confirmed_at = DateTime.now

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_admin_index_url, notice: 'Utilisateur créé avec succès.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize User

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: 'Utilisateur modifié avec succès.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    authorize User

    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_admin_index_url, notice: 'Utilisateur supprimé avec succès.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :role)
    end

end
