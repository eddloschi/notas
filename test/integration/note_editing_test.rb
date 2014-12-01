require 'test_helper'

class NoteEditingTest < ActionDispatch::IntegrationTest
  setup do
    use_js
    log_in
  end

  test 'edição de nota' do
    visit '/'
    click_on "actions-#{notes(:one).id}"
    click_on "edit-#{notes(:one).id}"
    fill_in 'note_title', with: 'Nova Nota'
    fill_in 'note_body', with: 'Novo Texto'
    click_on 'SkyBlue'
    click_on I18n.t('actions.save_note')
    assert page.has_content?('Nova Nota'), 'Título não encontrado'
    assert page.has_content?('Novo Texto'), 'Texto não encontrado'
    assert page.all('.note .well').first['style']
      .include?('background-color: SkyBlue'), 'Cor errada'
  end

  test 'erro na edição de nota' do
    visit '/'
    click_on "actions-#{notes(:one).id}"
    click_on "edit-#{notes(:one).id}"
    fill_in 'note_body', with: ''
    click_on I18n.t('actions.save_note')
    assert page.has_selector? 'div#errors'
  end

  test 'editar nota de outro usuário' do
    visit edit_note_path(notes(:two))
    assert_equal notes_path, page.current_path
    assert page.has_content? I18n.t('unauthorized.manage.all')
  end
end
