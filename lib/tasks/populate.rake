task :populate do
  CSV.foreach("https://raw.githubusercontent.com/PeterChudinov/broccoly_chatbot/master/populate.csv", headers: true) do |row|
    Brand.create! row.to_hash
  end
end