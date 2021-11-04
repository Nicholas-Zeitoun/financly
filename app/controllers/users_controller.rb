class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
    @user = User.find(params[:id])
    @users = User.all
    # authorize @user
  end

  # PATCH/PUT /seasons/1
  def update
    #if @user.update(user_params)
      if params[:user][:darkmode] == "true"
        @user.darkmode = true;
        @user.save!
        redirect_to @user, notice: 'Dark mode was successfully enabled.'
      else
        @user.darkmode = false;
        @user.save!
        redirect_to @user, notice: 'Dark mode was successfully disabled.'
      end
    #else
    #  render :root
    #end
    # authorize @season
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    if @user.destroy
        redirect_to root_url, notice: "User deleted."
    end
    # authorize @user
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    raise
    params.require(:user).permit(:darkmode)
  end
end
