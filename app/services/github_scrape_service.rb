# frozen_string_literal: true

class GithubScrapeService

  def self.scrape_all
    github = Github.new
    github.repos.list user: 'ServiceInnovationLab'

    puts github
  end

end
