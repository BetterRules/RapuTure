class SimluationsService < OpenfiscaService
  def self.calculate(query)
    headers = { 'Content-Type' => 'application/json' }
    url = "#{ENV['OPENFISCA_URL']}/calculate"
    response = HTTParty.post(url, body: query.to_json, headers: headers)
    JSON.parse(response.body)
  end
end