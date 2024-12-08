class Instructor < ApplicationRecord
  has_many :cohorts

  def username
    email.gsub(/@.*/, '')
  end
end
