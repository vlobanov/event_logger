require "spec_helper"

feature "Events browsing" do
  before(:each) do
  end

  scenario "User opens index when no events exist" do
    visit event_logger_path
  end

  scenario "User sees simple events" do
    create(:event, description: "first desc")
    create(:event, description: "second desc")
    visit event_logger_path
    page.should have_content("first desc")
    page.should have_content("second desc")
  end
end