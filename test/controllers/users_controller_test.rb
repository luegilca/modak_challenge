require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get get_all_users_path
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post create_users_path, params: { 
        user: { 
          name: "Namechanged", 
          lastname: "Samelastname", 
          email: "same@test.com" 
        } 
      }
    end

    assert_response :created
  end

  test "should not create a user due to missing fields" do
    assert_no_changes("User.count") do
      post create_users_path, params: { 
        user: { 
          lastname: "Samelastname", 
          email: "same@test.com" 
        } 
      }
    end

    assert_response :bad_request
  end

  test "should show user" do
    get get_users_path(@user)
    assert_response :success
  end

  test "should update user" do
    patch update_users_path(@user), params: { 
      user: { 
        name: "Namechanged", 
        lastname: "Samelastname", 
        email: "same@test.com" 
      } 
    }
    assert_response :success
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete delete_users_path(@user)
    end

    assert_response :no_content
  end

  test "should not found deleted user" do
    delete delete_users_path(@user)
    get get_users_path(@user)
    assert_response :not_found
  end
end
