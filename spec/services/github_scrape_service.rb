# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubScrapeService do
  before(:each) do
    @main_dir = ENV['SCENARIOS_DIR']
    @scenarios = [
      'citizenship',
      'demographics',
      'immigration',
      'income_tax',
      'parental_leave',
      'rates_rebates',
      'relationships',
      'social_security',
      'student_allowance'
    ]
  end

  it 'checks if folder have been generated' do
    described_class.scrape_all
    expect(File).to be_directory(@main_dir)

    @scenarios.each do |scenario|
      expect(File.directory?("#{@main_dir}/#{scenario}")).to be true
    end
  end
end
