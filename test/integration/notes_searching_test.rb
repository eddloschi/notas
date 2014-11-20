require 'test_helper'

class NotesSearchingTest < ActionDispatch::IntegrationTest
  setup do
    log_in
  end

  test 'buscando por título exato' do
    visit '/'
    fill_in 'query', with: notes(:one).title
    click_on 'search'
    assert page.has_content? notes(:one).body
    assert page.has_no_content? notes(:three).title
    assert page.has_content? I18n.t('messages.n_notes_found', count: 1)
  end

  test 'buscando por texto exato' do
    visit '/'
    fill_in 'query', with: notes(:one).body
    click_on 'search'
    assert page.has_content? notes(:one).title
    assert page.has_no_content? notes(:three).title
    assert page.has_content? I18n.t('messages.n_notes_found', count: 1)
  end

  test 'buscando por título parcial' do
    visit '/'
    fill_in 'query', with: notes(:one).title[0..2]
    click_on 'search'
    assert page.has_content? notes(:one).title
    assert page.has_content? notes(:three).title
    assert page.has_content? I18n.t('messages.n_notes_found', count: 2)
  end

  test 'buscando por texto parcial' do
    visit '/'
    fill_in 'query', with: notes(:one).body[0..2]
    click_on 'search'
    assert page.has_content? notes(:one).title
    assert page.has_content? notes(:three).title
    assert page.has_content? I18n.t('messages.n_notes_found', count: 2)
  end

  test 'resultados no título e no texto de notas diferentes' do
    visit '/'
    fill_in 'query', with: 'Busca'
    click_on 'search'
    assert page.has_content? notes(:one).title
    assert page.has_content? notes(:three).title
    assert page.has_content? I18n.t('messages.n_notes_found', count: 2)
  end

  test 'nenhum resultado' do
    visit '/'
    fill_in 'query', with: 'abcd'
    click_on 'search'
    assert page.has_content? I18n.t('messages.no_notes_found')
    assert page.has_no_content? notes(:one).title
    assert page.has_no_content? notes(:three).title
  end
end
