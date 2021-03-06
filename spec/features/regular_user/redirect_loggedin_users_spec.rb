require 'rails_helper'

RSpec.describe 'As a registered user, merchant, or admin' do

  describe 'When I visit the login path as a regular user' do
    context 'I am redirected to my profile page' do
      it 'And I see a flash message that tells me I am already logged in' do
        user = User.create(name: "regular_test_user",
                           address: "1163 S Dudley St",
                           city: "Lakewood",
                           state: "CO",
                           zip: "80232",
                           email: "campryan@comcast.net",
                           password: "password",
                           password_confirmation: "password",
                           role: 0)

        visit '/login'

        within(".login_form") do
          fill_in :email, with: "campryan@comcast.net"
          fill_in :password, with: "password"
          click_button("Submit")
        end

        expect(current_path).to eql("/profile")
        # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit '/login'

        expect(current_path).to eql("/profile")
        expect(page).to have_content("You are already logged in")
      end
    end
  end

  describe 'When I visit the login path as a merchant user' do
    context 'I am redirected to my merchant dashboard' do
      it 'And I see a flash message that tells me I am already logged in' do
        @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)

        @shop_employee = User.create(name: "Bob",
                                     address: "123 Glorious Way",
                                     city: "Stuck",
                                     state: "SomeState",
                                     zip: '80122',
                                     email: "bob@example.com",
                                     password: "password",
                                     password_confirmation: "password",
                                     role: 0)

        @bike_shop.hire(@shop_employee)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@shop_employee)

        visit '/login'

        expect(current_path).to eql("/merchant")
        expect(page).to have_content("You are already logged in")
      end
    end
  end

  describe 'When I visit the login path as a admin user' do
    context 'I am redirected to my admin dashboard page' do
      it 'And I see a flash message that tells me I am already logged in' do
        admin = User.create(name: "admin_test_user",
                            address: "1111 Admin St",
                            city: "Lakewood",
                            state: "CA",
                            zip: "80232",
                            email: "camp@example.com",
                            password: "password123",
                            password_confirmation: "password123",
                            role: 2)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

        visit '/login'

        expect(current_path).to eql("/admin")
        expect(page).to have_content("You are already logged in")
      end
    end
  end
end
