RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  # config.include Devise::SpecHelpers, type: :controller
end
