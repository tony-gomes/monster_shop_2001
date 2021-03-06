require "rails_helper"

RSpec.describe "When I visit /register" do
  before(:each) do
    visit "/register"
  end
  it "I can fill out an input form" do
    within(".form") do
      fill_in "user[name]", with: "Ryan Camp"
      fill_in "user[address]", with: "1163 S Dudley St"
      fill_in "user[city]", with: "Lakewood"
      fill_in "user[state]", with: "CO"
      fill_in "user[zip]", with: "80232"
      fill_in "user[email]", with: "campryan@comcast.net"
      fill_in "user[password]", with: "password"
      fill_in "user[password_confirmation]", with: "password"
      click_button("Submit")
    end

    expect(current_path).to eql("/profile")
    expect(page).to have_content("Welcome #{User.last.name} Registration Successful")
  end

  it "I see a sad path message if form not filled out completely." do
    within(".form") do
      fill_in "user[name]", with: "Ryan Camp"
      fill_in "user[address]", with: "1163 S Dudley St"
      fill_in "user[city]", with: ""
      fill_in "user[state]", with: ""
      fill_in "user[zip]", with: ""
      fill_in "user[email]", with: "campryan@comcast.net"
      fill_in "user[password]", with: "password"
      fill_in "user[password_confirmation]", with: "password"
      click_button("Submit")
    end

    expect(page).to have_content("City can't be blank, State can't be blank, and Zip can't be blank")
    expect(current_path).to eql("/register")
    expect(User.all.empty?).to eql(true)
  end

  it "I see sad path message if e-mail is not unique and other info still populated." do
    within(".form") do
      fill_in "user[name]", with: "Ryan Camp"
      fill_in "user[address]", with: "1163 S Dudley St"
      fill_in "user[city]", with: "Lakewood"
      fill_in "user[state]", with: "CO"
      fill_in "user[zip]", with: "80232"
      fill_in "user[email]", with: "campryan@comcast.net"
      fill_in "user[password]", with: "password"
      fill_in "user[password_confirmation]", with: "password"
      click_button("Submit")
    end

    visit '/register'

    within(".form") do
      fill_in "user[name]", with: "Ryan Camp"
      fill_in "user[address]", with: "1163 S Dudley St"
      fill_in "user[city]", with: "Lakewood"
      fill_in "user[state]", with: "CO"
      fill_in "user[zip]", with: "80232"
      fill_in "user[email]", with: "campryan@comcast.net"
      fill_in "user[password]", with: "password"
      fill_in "user[password_confirmation]", with: "password"
      click_button("Submit")
    end

    expect(current_path).to eql("/register")
    expect(page).to have_content("Email has already been taken")
    expect(find_field("user[name]").value).to eql("Ryan Camp")
    expect(find_field("user[address]").value).to eql("1163 S Dudley St")
    expect(find_field("user[city]").value).to eql("Lakewood")
    expect(find_field("user[state]").value).to eql("CO")
    expect(find_field("user[zip]").value).to eql("80232")
    expect(find_field("user[email]").value).to eql(nil)
    expect(find_field("user[password]").value).to eql(nil)
    expect(find_field("user[password_confirmation]").value).to eql(nil)


  end
end
