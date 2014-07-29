require 'rails_helper'

describe CategoriesController do
    login_user
    load_key

    it "get list of categories" do
      get :index
      expect(response).to render_template("index")
    end
end
