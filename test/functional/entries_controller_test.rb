require File.dirname(__FILE__) + '/../test_helper'

# make sure the secret for request forgery protection is set (views will
# explicitly use the form_authenticity_token method which will fail otherwise)
EntriesController.request_forgery_protection_options[:secret] = 'test_secret'

class EntriesControllerTest < ActionController::TestCase

  def test_should_get_index
    get :index
    assert_response :success
    get :index, :format => 'ext_json'
    assert_response :success
  end

  def test_should_create_entry
    assert_difference('Entry.count') do
      xhr :post, :create, :format => 'ext_json', :entry => { }
    end
    assert_response :success
  end

  def test_should_update_entry
    xhr :put, :update, :format => 'ext_json', :id => entries(:one).id, :entry => { }
    assert_response :success
  end

  def test_should_destroy_entry
    assert_difference('Entry.count', -1) do
      xhr :delete, :destroy, :id => entries(:one).id
    end
    assert_response :success
  end
end
