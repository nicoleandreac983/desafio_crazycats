class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable
  before_create :assign_random_photo
  has_many :posts

  private

  def assign_random_photo
    self.photo = Faker::Avatar.unique.image
  end
end
