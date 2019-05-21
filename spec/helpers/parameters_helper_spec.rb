# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParametersHelper do
  it { expect(filename_to_title('my_name_is_bob')).to eq 'My Name Is Bob' }
  it { expect(name_of_act('my/name/is/bob')).to eq 'Is' }
end
