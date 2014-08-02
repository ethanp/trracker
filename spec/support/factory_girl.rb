# FactoryGirl.lint builds each factory and subsequently calls #valid? on it
# (if #valid? is defined); if any calls to #valid? return false,
# FactoryGirl::InvalidFactoryError is raised with a list of the offending factories.
# rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) do
    FactoryGirl.lint
  end
end
