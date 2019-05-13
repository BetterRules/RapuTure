# frozen_string_literal: true

module ParametersHelper
  def filename_to_title(url)
    url.gsub('.yaml', '').split('_').map(&:capitalize).join(' ')
  end
end
