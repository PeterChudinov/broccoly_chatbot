class Brand < ActiveRecord::Base
  has_many :matches

  def self.import("/populate.csv")
    CSV.foreach(file.path, headers: true) do |row|
      Brand.create! row.to_hash
    end
end
