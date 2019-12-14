class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:twitter]

  has_many :discussions, dependent: :destroy
  has_many :channels, through: :discussions
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create(provider: auth.provider, uid: auth.uid) do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    user.name = auth.info.name # assuming the user model has a name
    user.username = auth.info.nickname # assuming the user model has a username
    #user.image = auth.info.image # assuming the user model has an image
    # If you are using confirmable and the provider(s) you use validate emails,
    # uncomment the line below to skip the confirmation emails.
    # user.skip_confirmation!
    end
  end
  def email_required?
    false
 end
end
