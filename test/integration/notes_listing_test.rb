require 'test_helper'

class NotesListingTest < ActionDispatch::IntegrationTest
  setup do
    user = users(:eu)
    visit '/users/sign_in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
  end

  teardown do
    Capybara.reset_sessions!
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
    assert page.all('div.note').first['style'].include? "background-color: #{note1.color}"
  end
end
