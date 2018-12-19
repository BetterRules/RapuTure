# frozen_string_literal: true

module ApplicationHelper
  def render_markdown(content)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
    markdown.render(content).html_safe
  end
end
