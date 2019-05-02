# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubScrapeService do
  before(:each) do
    @main_dir = ENV['SCENARIOS_DIR']
    @github_url = ENV['GITHUB_URL']
    @github_tests_path = ENV['GITHUB_TESTS_PATH']
    @scenarios = %w[
      citizenship
      demographics
      immigration
      income_tax
      parental_leave
      rates_rebates
      relationships
      social_security
      student_allowance
    ]
  end

  it 'scrapes the tests from openfisca-aotearoa' do
    described_class.scrape_all
    expect(File).to be_directory(@main_dir)

    @scenarios.each do |scenario|
      expect(File.directory?("#{@main_dir}/#{scenario}")).to be true
    end
  end

  it 'returns all links on page' do
    page = MetaInspector.new(@github_url + @github_tests_path)
    described_class.get_page_links(page)
    expect(described_class.get_page_links(page)).not_to be_empty
  end

  xit 'gets the data from openfisca-aoteroa by given directory' do

  end

  it 'returns the directory name for a scenario' do
    link = 'citizenship'
    described_class.get_directory_name(link)
    expect(described_class.get_directory_name(link)).to eq('./tmp/scenarios/citizenship')
  end

  it 'creates the directory and writes tests to file' do
    dir = 'citizenship'
    file = 'citizenship_adding_days'
    content = ''
    # described_class.mkdir_mkfile(dir, file, content)
    expect(File).to be_directory(dir)
    expect(File.file?("#{@main_dir}/#{dir}/#{file}.yaml")).to be true
    expect(File.readlines("#{@main_dir}/#{dir}/#{file}.yaml")).not_to eq(content)
  end

  xit 'expects the scenarios directory to exist then cleans directory' do

  end

  it 'cleans the scenarios directory' do
    described_class.clean_dir
    expect(FileUtils.rm_rf(Dir.glob("#{ENV['SCENARIOS_DIR']}/*"))).to match_array([])
  end
end
