require 'test_helper'

class NotesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:eu)
  end

  test 'index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:notes)
  end

  test 'index deve mostrar somente as notas do usuário atual' do
    get :index
    assert_not assigns(:notes).include? notes(:two)
  end

  test 'index deve retornar a nota mais recente primeiro' do
    note = Note.last
    note.touch
    note.save
    get :index
    assert assigns(:notes).first.updated_at > assigns(:notes).last.updated_at
  end

  test 'new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:note)
  end

  test 'new deve instanciar uma nova nota' do
    get :new
    assert_not assigns(:note).persisted?
  end

  test 'nova nota deve ser gold por padrão' do
    get :new
    assert assigns(:note).color == 'Gold'
  end

  test 'create' do
    post :create, note: {title: 'Note', body: 'Text', color: 'Gold'}
    assert_redirected_to controller: 'notes', action: 'index'
  end

  test 'create deve salvar a nota' do
    assert_difference('Note.where(user: users(:eu)).count') do
      post :create, note: {title: 'Note', body: 'Text', color: 'Gold'}
    end
  end

  test 'create deve renderizar o formulario de criação novamente em caso de erro' do
    post :create, note: {title: 'Note', color: 'Gold'}
    assert_template :new
  end

  test 'create deve retornar 422 em caso de erro' do
    post :create, note: {title: 'Note', color: 'Gold'}
    assert_response 422
  end
end
