require 'test_helper'

class NoteCreationTest < ActionDispatch::IntegrationTest
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

  test 'criação de nota' do
    visit '/'
    click_on I18n.t('actions.create_note')
    fill_in 'note_title', with: 'Nova Nota'
    fill_in 'note_body', with: 'Novo Texto'
    click_on 'SkyBlue'
    click_on I18n.t('actions.save_note')
    assert page.has_content?('Nova Nota'), 'Título não encontrado'
    assert page.has_content?('Novo Texto'), 'Texto não encontrado'
    assert page.all('div.note').first['style'].include?("background-color: SkyBlue"), 'Cor errada'
  end

  test 'erro na criação de nota' do
    visit '/'
    click_on I18n.t('actions.create_note')
    click_on I18n.t('actions.save_note')
    assert page.has_selector? 'div#errors'
  end
end
