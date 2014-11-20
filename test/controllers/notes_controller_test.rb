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
    assert 'Gold', assigns(:note).color
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

  test 'edit' do
    get :edit, id: notes(:one).id
    assert_response :success
    assert_not_nil assigns(:note)
  end

  test 'edit deve retornar a nota correta para ser editada' do
    get :edit, id: notes(:one).id
    assert_equal notes(:one), assigns(:note)
  end

  test 'edit deve disparar uma exceção se a nota não for encontrada' do
    assert_raises(ActiveRecord::RecordNotFound) { get :edit, id: 1 }
  end

  test 'update' do
    patch :update, id: notes(:one).id, note: {title: 'Update Note', body: 'Update Text', color: 'Pink'}
    assert_redirected_to controller: 'notes', action: 'index'
  end

  test 'update deve atualizar a nota' do
    patch :update, id: notes(:one).id, note: {title: 'Update Note', body: 'Update Text', color: 'Pink'}
    notes(:one).reload
    assert_equal 'Update Note', notes(:one).title
    assert_equal 'Update Text', notes(:one).body
    assert_equal 'Pink', notes(:one).color
  end

  test 'update deve renderizar o formulario de edição novamente em caso de erro' do
    patch :update, id: notes(:one).id, note: {title: 'Update Note', body: '', color: 'Pink'}
    assert_template :edit
  end

  test 'update deve retornar 422 em caso de erro' do
    patch :update, id: notes(:one).id, note: {title: 'Update Note', body: '', color: 'Pink'}
    assert_response 422
  end

  test 'update deve disparar uma exceção se a nota não for encontrada' do
    assert_raises(ActiveRecord::RecordNotFound) { patch :update, id: 1 }
  end
end
