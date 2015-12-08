class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_keywords
  has_many :keywords, through: :user_keywords, :class_name => 'Keyword'

  accepts_nested_attributes_for :keywords, reject_if: :all_blank, :allow_destroy => true



end
