# frozen_string_literal: true

class GithubScrapeService
  SCENARIOS_DIR = './app/scenarios'
  RAW_FILE_DIR = 'https://raw.githubusercontent.com/ServiceInnovationLab/openfisca-aotearoa/master/'
  TOP_LEVEL_INCLUDE = 'tree/master/openfisca_aotearoa/tests/'
  SECOND_LEVEL_INCLUDE = 'blob/master/openfisca_aotearoa/tests/'
  SECOND_LEVEL_STRIP_URL = 'https://github.com/ServiceInnovationLab/openfisca-aotearoa/tree/master/openfisca_aotearoa/tests/'
  RAW_FILE_STRIP_URL = 'https://github.com/ServiceInnovationLab/openfisca-aotearoa/blob/master/'

  def self.scrape_all
    clean_dir

    # Scrape first level directory
    page = MetaInspector.new(ENV['GITHUB_URL'] + ENV['GITHUB_TESTS_PATH'])

    # get all links
    page.links.all.each do |link|
      next unless link.include?(TOP_LEVEL_INCLUDE)

      files = MetaInspector.new(link, allow_non_html_content: false)
      files.links.all.each do |file|
        next unless file.include?(SECOND_LEVEL_INCLUDE)

        link.gsub!(SECOND_LEVEL_STRIP_URL, '')
        directory = "#{SCENARIOS_DIR}/#{link}"

        # get file contents
        raw_file = file.gsub!(RAW_FILE_STRIP_URL, RAW_FILE_DIR)
        raw_file_contents = MetaInspector.new(raw_file, allow_non_html_content: true)

        mkfile = "#{directory}/#{file.split('/').last}"

        mkdir_mkfile(directory, mkfile, raw_file_contents)
      end
    end
  end

  def self.mkdir_mkfile(dir, file, content)
    FileUtils.mkdir_p dir
    FileUtils.touch file
    File.open(file, 'w+') { |file| file.write(content) }
  end

  def self.clean_dir
    if File.directory?(SCENARIOS_DIR)
      unless Dir.empty?(SCENARIOS_DIR)
        FileUtils.rm_rf(Dir.glob("#{SCENARIOS_DIR}/*"))
        puts 'Scenario files exist! Cleaning scenarios directory.'
      end
    end
  end
end
