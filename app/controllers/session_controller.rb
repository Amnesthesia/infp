class SessionController < Devise::SessionsController

  def create
      respond_to do |format|
          format.html{ super }
          format.json do
              self.resource = warden.authenticate!(auth_options)
              sign_in(resource, resource)

              data = {
                  user_token: self.resource.authentication_token
              }

              render json: data, status: 201
          end
      end
  end
end
