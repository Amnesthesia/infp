class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def self.provides_callback_for(provider)

      # Eval this code because we have to adapt to what provider we're using, and
      # arrays and methods are different depending on the name of the provider
      # So, what we do is make a dynamic method here, that creates 4 different ones
      # with one for each provider specified below
      class_eval %Q{
          def #{provider}
              puts env["omniauth.auth"].to_json
              @user = User.find_for_oauth(env["omniauth.auth"], current_user)

              if @user.persisted?
                  sign_in_and_redirect @user, event: :authentication
              else
                  session["devise.#{provider}_data"] = env["omniauth.auth"]
                  redirect_to "users#index"
              end
          end
      }
  end

  # And here, we generate 'em!
  [:twitter, :facebook, :tumblr, :reddit].each do |provider|
      provides_callback_for provider
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      user_finish_path(resource)
    end
  end
end
