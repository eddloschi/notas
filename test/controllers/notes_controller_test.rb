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

  test 'create deve retornar um erro se a nota não for salva' do
    post :create, note: {title: 'Note', color: 'Gold'}
    assert_response :unprocessable_entity
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

  test 'update deve retornar um erro se a nota não for salva' do
    patch :update, id: notes(:one).id, note: {title: 'Update Note', body: '', color: 'Pink'}
    assert_response :unprocessable_entity
  end

  test 'update deve disparar uma exceção se a nota não for encontrada' do
    assert_raises(ActiveRecord::RecordNotFound) { patch :update, id: 1 }
  end

  test 'destroy' do
    delete :destroy, id: notes(:one).id
    assert_redirected_to controller: 'notes', action: 'index'
  end

  test 'destroy deve excluir a nota' do
    assert_difference('Note.count', -1) { delete :destroy, id: notes(:one).id }
  end

  test 'destroy deve disparar uma exceção se a nota não for encontrada' do
    assert_raises(ActiveRecord::RecordNotFound) { delete :destroy, id: 1 }
  end

  test 'destroy deve colocar as mensagens de erro no flash alert' do
    note = MiniTest::Mock.new
    errors = MiniTest::Mock.new
    note.expect :id, notes(:one).id
    note.expect :destroy, false
    note.expect :errors, errors
    errors.expect :full_messages, ['error']
    Note.stub :find, note do
      delete :destroy, id: notes(:one).id
      assert_equal I18n.t('errors.delete_note'), flash[:alert]
      assert_response :unprocessable_entity
    end
  end

  test 'search' do
    get :search, query: notes(:one).title
    assert_response :success
    assert_not_nil assigns(:notes)
  end

  test 'search deve buscar somente as notas do usuario atual' do
    get :search, query: 'N'
    assert_equal 2, assigns(:notes).count
  end

  test 'search deve buscar pelo titulo completo' do
    get :search, query: notes(:one).title
    assert_equal notes(:one), assigns(:notes).first
  end

  test 'search deve buscar pelo texto completo' do
    get :search, query: notes(:one).body
    assert_equal notes(:one), assigns(:notes).first
  end

  test 'search deve buscar pelo titulo parcial' do
    get :search, query: notes(:one).title[0..2]
    assert assigns(:notes).include? notes(:one)
    assert assigns(:notes).include? notes(:three)
  end

  test 'search deve buscar pelo texto parcial' do
    get :search, query: notes(:one).body[0..2]
    assert assigns(:notes).include? notes(:one)
    assert assigns(:notes).include? notes(:three)
  end

  test 'search deve retornar resultados de título e texto em notas diferentes' do
    get :search, query: 'Busca'
    assert assigns(:notes).include? notes(:one)
    assert assigns(:notes).include? notes(:three)
  end

  test 'search deve colocar a quantidade de resultados no flash notice' do
    get :search, query: notes(:one).title
    assert_equal I18n.t('messages.n_notes_found', count: 1), flash[:notice]
  end

  test 'search deve colocar a mensagem de nenhum resultados no flash alert' do
    get :search, query: 'abcd'
    assert_equal I18n.t('messages.no_notes_found'), flash[:alert]
  end
end
