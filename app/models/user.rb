class User < ActiveRecord::Base
  belongs_to :user
  devise :database_authenticatable, :trackable, :validatable, :omniauthable, :confirmable,
         :omniauth_providers => [:reddit, :facebook, :twitter, :tumblr]

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update
  has_one :profile_picture, -> {where profile_picture: true}, class_name: 'Image', as: 'resource'

  def self.find_for_oauth(auth, signed_in_resource=nil)
    puts auth.to_json
    img = Image.where(path: auth.info.image||auth.info.avatar, profile_picture: true).first_or_create
    user = signed_in_resource ? signed_in_resource : User.where(uid: auth.uid, provider: auth.provider).first
    email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
    email = auth.info.email if email_is_verified
    user = User.where(email: email).first if email

    # Create the user if it does not exist
    if user.nil?

      user = User.new(
          name: auth.extra.raw_info.name,
          password: Devise.friendly_token[0,20],
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          provider: auth.provider,
          uid: auth.uid,
          is_admin: false
      )
      user.skip_confirmation!
      user.save!
    else
        puts "User was not nil, user is "
        puts user
    end

    if user.profile_picture.nil?
      user.profile_picture = img
    elsif user.profile_picture != img
      user.profile_picture.delete
      user.profile_picture = img
    end

      # Return the user object
      user

    end

    # Check if email has been verified by oauth
    def email_verified?
      self.email && self.email !~ TEMP_EMAIL_REGEX
    end

end
