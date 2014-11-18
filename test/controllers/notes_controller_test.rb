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
end
