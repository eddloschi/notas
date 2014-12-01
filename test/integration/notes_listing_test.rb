require 'test_helper'

class NotesListingTest < ActionDispatch::IntegrationTest
  setup do
    log_in
  end

  test 'listagem de notas' do
    visit '/'
    assert page.has_content? notes(:one).title
    assert page.has_content? notes(:one).body
    assert page.has_no_content? notes(:two).title
    assert page.has_no_content? notes(:two).body
  end

  test 'cor das notas' do
    visit '/'
    assert page.all('.note .well').first['style']
      .include? "background-color: #{notes(:one).color}"
  end
end
