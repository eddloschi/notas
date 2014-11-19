require 'test_helper'

class NotesListingTest < ActionDispatch::IntegrationTest
  setup do
    log_in
  end

  test 'listagem de notas' do
    note1 = notes(:one)
    note2 = notes(:two)
    visit '/'
    assert page.has_content? note1.title
    assert page.has_content? note1.body
    assert_not page.has_content? note2.title
    assert_not page.has_content? note2.body
  end

  test 'cor das notas' do
    note1 = notes(:one)
    visit '/'
    assert page.all('.note .well').first['style'].include? "background-color: #{note1.color}"
  end
end
