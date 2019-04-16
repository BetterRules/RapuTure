# frozen_string_literal: true

namespace :scrape do
  desc 'Scrape Scenarios'
  # usage: rake growstuff:admin_user name=skud
  task scrapeall: [:openfisca] do
    # This runs after all the above tasks have run
    puts 'Scraped scenarios from openfisca-aotearoa!'
  end
  task openfisca: :environment do
    GithubScrapeService.scrape_all do |v|
      puts v
    end
  end
end
