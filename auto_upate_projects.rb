require './scraper.rb'



while true
  sleep(15)
  SamaHopeClient.update_project_money()
  print "One update done"
end
