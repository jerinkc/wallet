# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    user_generator = UserGenerator.new(sign_up_params)
    user_generator.generate
    @user = user_generator.user

    if @user.persisted?
      sign_up(resource_name, @user)
      respond_with @user, location: after_sign_up_path_for(@user)
    else
      clean_up_passwords(@user)
      set_minimum_password_length
      respond_with @user
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :full_name)
  end
end
