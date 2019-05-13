# frozen_string_literal: true

module ParametersHelper
  def filename_to_title(url)
    url.gsub('.yaml', '').split('_').map(&:capitalize).join(' ')
  end

  def url_from_reference(ref)
    ref.match(/https?:\/\/[\S]+/)
  end
end
