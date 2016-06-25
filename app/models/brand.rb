class Brand < ActiveRecord::Base
  has_many :matches

  def self.import("/populate.csv")

  end
end
