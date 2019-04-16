# frozen_string_literal: true

class GithubScrapeService

  def self.connect(dir="")
    repos = Github::Client::Repos.new
    repos.contents.get user: 'ServiceInnovationLab', repo: 'openfisca-aotearoa', path: "openfisca_aotearoa/tests/#{dir}"
  end

  def self.scrape_all
    dirs = connect()

    dirs.each do |t|
      puts "======================================================================"

      if t.name.include?('.yaml')
        puts "File: #{t.name}"
      else
        puts "Directory: #{t.name}"
        children = connect(t.name)
        children.each do |c|
          puts c.name
        end
      end
    end
  end

end
