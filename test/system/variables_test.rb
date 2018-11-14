# frozen_string_literal: true

require 'application_system_test_case'

class VariablesTest < ApplicationSystemTestCase
  setup do
    @variable = variables(:one)
  end

  test 'visiting the index' do
    visit variables_url
    assert_selector 'h1', text: 'Variables'
  end

  test 'creating a Variable' do
    visit variables_url
    click_on 'New Variable'

    click_on 'Create Variable'

    assert_text 'Variable was successfully created'
    click_on 'Back'
  end

  test 'updating a Variable' do
    visit variables_url
    click_on 'Edit', match: :first

    click_on 'Update Variable'

    assert_text 'Variable was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Variable' do
    visit variables_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Variable was successfully destroyed'
  end
end
