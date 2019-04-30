# frozen_string_literal: true

class GithubScrapeService
  def self.scrape_all
    if File.directory?(ENV['SCENARIOS_DIR'])
      inspect_dir
    else
      FileUtils.mkdir_p ENV['SCENARIOS_DIR']
    end

    page = MetaInspector.new(ENV['GITHUB_URL'] + ENV['GITHUB_TESTS_PATH'])
    build_scenarios(page)
  end

  def self.build_scenarios(page)
    page.links.all.each do |link|
      next unless link.include?(ENV['TOP_LEVEL_INCLUDE'])

      files = MetaInspector.new(link, allow_non_html_content: false)
      traverse_urls(files, link)
    end
  end

  def self.traverse_urls(files, link)
    files.links.all.each do |file|
      next unless file.include?(ENV['SECOND_LEVEL_INCLUDE'])

      directory = top_level_url(link)
      raw_file = file.gsub!(ENV['RAW_FILE_STRIP_URL'], ENV['GITHUB_RAW_FILE_PATH'])
      raw_file_contents = MetaInspector.new(raw_file, allow_non_html_content: true)
      mkfile = "#{directory}/#{file.split('/').last}"
      mkdir_mkfile(directory, mkfile, raw_file_contents)
    end
  end

  def self.top_level_url(link)
    link.gsub!(ENV['SECOND_LEVEL_STRIP_URL'], '')
    "#{ENV['SCENARIOS_DIR']}/#{link}"
  end

  def self.mkdir_mkfile(dir, file, content)
    FileUtils.mkdir_p dir
    FileUtils.touch file
    File.open(file, 'w+') { |f| f.write(content) }
  end

  def self.inspect_dir
    return unless !File.directory?(ENV['SCENARIOS_DIR']) && !Dir.empty?(ENV['SCENARIOS_DIR'])

    clean_dir
  end

  def self.clean_dir
    FileUtils.rm_rf(Dir.glob("#{ENV['SCENARIOS_DIR']}/*"))
  end
end
