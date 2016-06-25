task :populate => [:environment] do
  file = "#{Rails.root}/populate_options.csv"

  CSV.foreach(file, headers: true) do |row|
    BrandOptions.create! row.to_hash
  end
end