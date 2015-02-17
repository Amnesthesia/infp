class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :finish, :index]

  # GET /users
  # GET /users.json
  def index
    if user_signed_in? and current_user.is_admin?
        @users = User.all
    else
        redirect_to user_path(current_user)
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
      # Only allow showing users own page
      # and users match's page
      if user_signed_in?
          if current_user.id != params[:id].to_i and current_user.user.nil?
              redirect_to user_path(current_user)
          elsif !current_user.user.nil? and current_user.user.id != params[:id].to_i
              puts "Redirecting nao"
              redirect_to user_path(current_user.user)
          end
      else
          redirect_to root_path
      end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
      redirect_to root_path unless user_signed_in?
      @user = current_user
  end

  # POST /users
  # POST /users.json
  def create
    puts auth_hash.to_json
    @user = User.find_or_create_from_auth_hash(auth_hash)
    self.current_user = @user

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_finish_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def match
      redirect_to root_path unless user_signed_in? and current_user.is_admin?
      u = User.all

      u.each do |user|
          match = User.where(user_id: nil).order('RANDOM()').first
          user.user = match
          user.save
          match.user = user
          match.save
      end

      redirect_to users_path
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
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
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def finish
    @user = current_user
    if request.patch? && params[:user]
        if current_user.update(user_params)
            current_user.skip_reconfirmation! unless !current_user.nil? and current_user.provider == 'twitter' or current_user.provider == 'reddit'
            sign_in(current_user, bypass: true)
            redirect_to users_path, notice: 'You\'re all set!'
        else
            @show_errors = true
        end
    end
  end

  protected

  def auth_hash
      request.env['omniauth.auth']
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :address, :zipcode, :country, :city, :gender)
    end


end
