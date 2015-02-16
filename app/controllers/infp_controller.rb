class InfpController < ApplicationController
  def index
      if user_signed_in?
          if current_user.user.nil?
              redirect_to user_path(current_user)
          else
              redirect_to user_path(current_user.user)
          end
      end
  end
end
