task :populate do
  CSV.foreach("/populate.csv".path, headers: true) do |row|
    Brand.create! row.to_hash
  end
end