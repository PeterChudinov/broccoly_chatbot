task :populate => [:environment] do
  file = "#{Rails.root}/populate.csv"

  CSV.foreach(file, headers: true) do |row|
    Brand.create! row.to_hash
  end
end