# frozen_string_literal: true

module ParametersHelper
  def filename_to_title(url)
    url.gsub('.yaml', '').split('/').last.titleize
  end

  def name_of_act(str)
    str.split('/').pop(2).first.titleize
  end

  def github_file_url(file)
    unless file.filename.nil?
      file = file.filename.gsub('./tmp/development-openfisca-aotearoa/', '')
      "https://github.com/ServiceInnovationLab/openfisca-aotearoa/blob/master/#{file}"
    end
  end
end
