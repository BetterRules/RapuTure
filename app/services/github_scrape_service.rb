# frozen_string_literal: true

class GithubScrapeService

  def self.scrape_all
    repos = Github::Client::Repos.new
    contents = repos.contents user: 'ServiceInnovationLab', repo: 'openfisca-aotearoa'

    directories = contents.get user: 'ServiceInnovationLab', repo: 'openfisca-aotearoa', path: 'openfisca_aotearoa/tests'

    directories.each do |t|
      puts "======================================================================"
      puts t.url
    end
  end

end
