class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)
      redirect_to jobs_path, notice: "Welcome aboard! Your account has been created."
    else
      flash[:error] = "Invalid user information: #{@user.errors.full_messages.to_sentence}"
      render :new
    end
  end

  def show
    render_404 and return unless params[:id] == current_user.id
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
