# frozen_string_literal: true

class GithubScrapeService
  SCENARIOS_DIR = './app/scenarios'
  RAW_FILE_DIR = 'https://raw.githubusercontent.com/ServiceInnovationLab/openfisca-aotearoa/master/'
  TOP_LEVEL_INCLUDE = 'tree/master/openfisca_aotearoa/tests/'
  SECOND_LEVEL_INCLUDE = 'blob/master/openfisca_aotearoa/tests/'
  SECOND_LEVEL_STRIP_URL = 'https://github.com/ServiceInnovationLab/openfisca-aotearoa/tree/master/openfisca_aotearoa/tests/'
  RAW_FILE_STRIP_URL = 'https://github.com/ServiceInnovationLab/openfisca-aotearoa/blob/master/'

  def self.scrape_all
    next if File.directory?(SCENARIOS_DIR)

    inspect_dir

    page = MetaInspector.new(ENV['GITHUB_URL'] + ENV['GITHUB_TESTS_PATH'])
    build_scenarios(page)
  end

  def self.build_scenarios(page)
    page.links.all.each do |link|
      next unless link.include?(TOP_LEVEL_INCLUDE)

      files = MetaInspector.new(link, allow_non_html_content: false)
      traverse_urls(files, link)
    end
  end

  def self.traverse_urls(files, link)
    files.links.all.each do |file|
      next unless file.include?(SECOND_LEVEL_INCLUDE)

      directory = top_level_url(link)
      raw_file = file.gsub!(RAW_FILE_STRIP_URL, RAW_FILE_DIR)
      raw_file_contents = MetaInspector.new(raw_file, allow_non_html_content: true)
      mkfile = "#{directory}/#{file.split('/').last}"
      mkdir_mkfile(directory, mkfile, raw_file_contents)
    end
  end

  def self.top_level_url(link)
    link.gsub!(SECOND_LEVEL_STRIP_URL, '')
    "#{SCENARIOS_DIR}/#{link}"
  end

  def self.mkdir_mkfile(dir, file, content)
    FileUtils.mkdir_p dir
    FileUtils.touch file
    File.open(file, 'w+') { |f| f.write(content) }
  end

  def self.inspect_dir
    return unless !File.directory?(SCENARIOS_DIR) && !Dir.empty?(SCENARIOS_DIR)

    clean_dir
  end

  def self.clean_dir
    FileUtils.rm_rf(Dir.glob("#{SCENARIOS_DIR}/*"))
  end
end
