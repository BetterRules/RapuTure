# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubCloneService do
  it { expect(described_class.git_branch).to eq 'master' }
  it { expect(described_class.git_clone_folder).to eq './tmp/test-openfisca-aotearoa' }
end
