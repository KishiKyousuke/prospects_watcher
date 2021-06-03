# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :favorite_pitchers, dependent: :destroy
  has_many :favorite_batters, dependent: :destroy
  has_many :pitchers, through: :favorite_pitchers
  has_many :batters, through: :favorite_batters
end
