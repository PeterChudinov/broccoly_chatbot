class User < ActiveRecord::Base
	has_many :matches


	def matching_brands
		types = %i{gender, type, style, price, music, mood, personality}
		where = {}
		types.each do |type|
			where[type] = self.attributes[type.to_s]
		end
		ids = BrandOption.where(where).group(:brand_id).order('COUNT(*) DESC').pluck(:brand_id)
		Brand.where(id: ids)
	end
end
