require 'test_helper'

class NoteEditingTest < ActionDispatch::IntegrationTest
  test 'editação de nota' do
    use_js
    log_in
    visit '/'
    click_on "actions-#{notes(:one).id}"
    click_on "edit-#{notes(:one).id}"
    fill_in 'note_title', with: 'Nova Nota'
    fill_in 'note_body', with: 'Novo Texto'
    click_on 'SkyBlue'
    click_on I18n.t('actions.save_note')
    assert page.has_content?('Nova Nota'), 'Título não encontrado'
    assert page.has_content?('Novo Texto'), 'Texto não encontrado'
    assert page.all('.note .well').first['style'].include?("background-color: SkyBlue"), "Cor errada"
  end

  test 'erro na criação de nota' do
    use_js
    log_in
    visit '/'
    click_on "actions-#{notes(:one).id}"
    click_on "edit-#{notes(:one).id}"
    fill_in 'note_body', with: ''
    click_on I18n.t('actions.save_note')
    assert page.has_selector? 'div#errors'
  end
end
