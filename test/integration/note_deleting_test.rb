require 'test_helper'

class NoteDeletingTest < ActionDispatch::IntegrationTest
  test 'exclusão de nota' do
    use_js
    log_in
    visit '/'
    click_on "actions-#{notes(:one).id}"
    page.accept_confirm do
      click_on "delete-#{notes(:one).id}"
    end
    assert page.has_no_content? notes(:one).title
  end
end
