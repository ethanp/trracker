require 'rails_helper'

describe TasksController do
  render_views

  describe "GET index" do
    it "redirects" do
      get :index
      expect(response.body).to match /redirect/m
    end
  end
end
