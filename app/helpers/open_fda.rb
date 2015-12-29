module OpenFDA
  def self.query (params)
    base = "https://api.fda.gov/drug/event.json?"
    url = base + params
    res = JSON.parse(Net::HTTP.get(URI url))
  end
end
