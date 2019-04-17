# frozen_string_literal: true

class GithubScrapeService

  ALLOWED_STRINGS = Set[' '
  ]
  def self.scrape_all
    page = MetaInspector.new(ENV['GITHUB_URL']+ENV['GITHUB_TESTS_PATH'])

    all_links = Array.new
    all_dirs = Array.new
    files(page).each do |link|
      all_links.push(link)
    end

    dirs(page).each do |link|
      all_dirs.push(link)
    end

    all_dirs.each do |dir|
      page = MetaInspector.new(dir)
      files(page).each do |link|
        all_links.push(link)
      end
      dirs(page).each do |link|
        all_dirs.push(link)
      end
    end

    puts "Creating files ..."

    all_links.uniq.each do |link|
      file_name = link.split('/').last
      link.gsub!('https://github.com', 'https://raw.githubusercontent.com')
      link.gsub!('blob/', '')
      page = MetaInspector.new(link, allow_non_html_content: true)
      write_to_dir(file_name, page)
    end

  end


  def self.files(page)
    results = Array.new
    page.links.all.each do |link|
      if link.include?('.yaml') && link.include?('tests/') && link.include?('blob/master') && !link.include?('&source=login')
        results.push(link)
        puts "Added File: #{link}"
      end
    end
    results
  end

  def self.dirs(page)
    results = Array.new
    page.links.all.each do |link|
      if !link.include?('https://github.com/login') && !link.include?('.yaml') && !link.include?('income_tax') && link.include?('tests/') && !link.include?('#start-of-content') && link.include?('tree/master/') && !link.include?('&source=login')
        results.push(link)
        puts "Added Directory: #{link}"
      end
    end
    results
  end

  def self.write_to_dir(file_name, page)
    File.open("app/scenarios/#{file_name}", "w+") { |f| f.write(page) }
  end

end
