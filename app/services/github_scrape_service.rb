# frozen_string_literal: true

class GithubScrapeService

  FILE_INCLUDE = ['.yaml', 'tests/', 'blob/master']
  FILE_EXCLUDE = ['&source=login']
  DIR_INCLUDE = []
  DIR_EXCLUDE = []

  FILES = {name: 'Files', include: ['.yaml', 'tests/', 'blob/master'], exclude: ['&source=login']}
  def self.scrape_all
    page = MetaInspector.new(ENV['GITHUB_URL']+ENV['GITHUB_TESTS_PATH'])

    all_links = Array.new
    all_dirs = Array.new

    #TODO: Too much repitition, ideas on to how refactor this are welcome!
    files(page, FILES).each do |link|
      all_links.push(link)
    end

    dirs(page).each do |link|
      all_dirs.push(link)
    end

    all_dirs.each do |dir|
      page = MetaInspector.new(dir)
      files(page, FILES).each do |link|
        all_links.push(link)
      end
      dirs(page).each do |link|
        all_dirs.push(link)
      end
    end

    puts "Creating files ..."

    write_files(all_links)
  end

  def self.write_files(all_links)

    all_links.uniq.each do |link|
      file_name = link.split('/').last
      folder = link.split('/')[-2]
      tidy_url(link)
      page = MetaInspector.new(link, allow_non_html_content: true)
      write_to_dir(file_name, page, folder)
    end

  end

  def self.tidy_url(link)
    link.gsub!('https://github.com', 'https://raw.githubusercontent.com')
    link.gsub!('blob/', '')
    link
  end

  def self.files(page, filters)
    results = Array.new
    page.links.all.each do |link|
      if included_in?(link, filters[:include]) && !included_in?(link, filters[:exclude])
        results.push(link)
        puts "Added File: #{link}"
      end
    end
    results
  end

  def self.included_in?(link, array)
    array.all? { |i| link.include?(i) }
  end

  def self.dirs(page)
    results = Array.new
    page.links.all.each do |link|
      #TODO: work out why self.included_in? does not work here?....

      #TODO: need to check if directory has a yaml file or not. if not go to next directory (for income_tax/)
      if !link.include?('https://github.com/login') && !link.include?('.yaml') && !link.include?('income_tax') && link.include?('tests/') && !link.include?('#start-of-content') && link.include?('tree/master/') && !link.include?('&source=login')
        results.push(link)
      end
    end
    results
  end

  def self.write_to_dir(file_name, page, folder)
    dir = "app/scenarios/#{folder}"
    file = "app/scenarios/#{folder}/#{file_name}"

    unless Dir.exists?(dir) then
      Dir.mkdir(dir)
    end

    unless File.exists?(file) then
      File.open(file, "w+") { |f| f.write(page) }
    end
  end
end
