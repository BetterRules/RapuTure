# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubScrapeService do
  before(:each) do
    @main_dir = ENV['SCENARIOS_DIR']
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

  it 'checks if folder have been generated' do
    described_class.scrape_all
    expect(File).to be_directory(@main_dir)

    @scenarios.each do |scenario|
      expect(File.directory?("#{@main_dir}/#{scenario}")).to be true
    end
  end

  it 'cleans the scenarios directory' do
    described_class.clean_dir
    expect(FileUtils.rm_rf(Dir.glob("#{ENV['SCENARIOS_DIR']}/*"))).to match_array([])
  end

  it 'returns the directory name for a scenario' do
    link = 'citizenship'
    described_class.top_level_url(link)
    expect(described_class.top_level_url(link)).to eq('./tmp/scenarios/citizenship')
  end

  it 'returns all links on page' do
    page = MetaInspector.new(ENV['GITHUB_URL'] + ENV['GITHUB_TESTS_PATH'])
    described_class.get_page_links(page)
    expect(described_class.get_page_links(page)).not_to be_empty
  end
end
