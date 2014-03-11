require "spec_helper"

feature "Event controller protection" do
  after(:each) do
    $halt_filter_and_redirect_to_root = false
  end

  scenario "unwelcome user opens event logger path, and gets redirected to app's root" do
    $halt_filter_and_redirect_to_root = true
    visit event_logger_path
    current_path.should == '/'
  end
end