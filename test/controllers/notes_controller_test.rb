require 'test_helper'

class NotesControllerTest < ActionController::TestCase
  def setup
    @note = notes(:orange)
  end
  
  test "should redirect create when not logged in" do
    assert_no_difference "Note.count" do
      post :create, note: { content: "Lorem ipsum" }
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference "Note.count" do
      delete :destroy, id: @note
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy for wrong note" do
    log_in_as(users(:michael))
    note = notes(:ants)
    assert_no_difference 'Note.count' do
      delete :destroy, id: note
    end
    assert_redirected_to root_url
  end
end
