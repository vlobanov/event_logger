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

  scenario "User sees event exceptions" do
    create(:event_with_exception)

    visit event_logger_path

    page.should have_content("StandardError")
    page.should have_content("a bang")
  end

  scenario "User sees event messages" do
    e = create(:event_full)
    visit event_logger_path
    e.messages.each { |msg| page.should have_content(msg) }
  end
end