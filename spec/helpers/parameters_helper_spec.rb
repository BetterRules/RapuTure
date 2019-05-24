# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParametersHelper do
  it { expect(filename_to_title('my_name_is_bob')).to eq 'My Name Is Bob' }
  it { expect(name_of_act('my/name/is/bob')).to eq 'Is' }
  it { expect(github_file_url('./tmp/development-openfisca-aotearoa/openfisca_aotearoa/parameters/acc/weekly_compensation_abatement.yaml')).to eq 'https://github.com/ServiceInnovationLab/openfisca-aotearoa/blob/master/openfisca_aotearoa/parameters/acc/weekly_compensation_abatement.yaml' }
  it { expect(github_url('./tmp/development-openfisca-aotearoa/openfisca_aotearoa/parameters/acc/weekly_compensation_abatement.yaml')).to eq 'https://github.com/ServiceInnovationLab/openfisca-aotearoa/blob/master/openfisca_aotearoa/parameters/acc/weekly_compensation_abatement.yaml' }
end
