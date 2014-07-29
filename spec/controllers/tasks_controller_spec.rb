require 'rails_helper'

describe TasksController do
  render_views

  describe "GET index" do
    it "says 'per page'" do
      get :index
      expect(response.body).to match /redirect/m
    end
  end
end
