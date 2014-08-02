require 'rails_helper'

describe CategoriesController do
  login_user
  # load_key

  it "should have a current_user" do
    # note the fact that I removed the "validate_session" parameter if this was a scaffold-generated controller
    expect(subject.current_user).to_not be_nil
  end

  it "should get index" do
    # Note, rails 3.x scaffolding may add lines like get :index, {}, valid_session
    # the valid_session overrides the devise login. Remove the valid_session from your specs
    get 'index'
    expect(response).to be_success
  end

  it "should get a list of categories" do
    get :index
    expect(response).to render_template("index")
  end

end
