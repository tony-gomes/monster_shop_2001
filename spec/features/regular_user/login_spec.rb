require 'rails_helper'

RSpec.describe 'As a visitor' do
  describe 'When I visit the login path' do
    it 'I see a field to enter my email address & password' do

      visit '/login'

      within(".login_form") do
        expect(page).to have_css("#email")
        expect(page).to have_css("#password")
      end
    end

    describe 'When I submit valid information' do
      context 'if I am a regular user' do
        it 'I am redirected to my profile page & I see a flash message that I am logged in' do
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
          expect(page).to have_content("You are logged in")
        end
      end

      context 'If I am a merchant user' do
        it 'I am redirected to my merchant dashboard page & I see a flash message that I am logged in' do
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

          visit '/login'

          within(".login_form") do
            fill_in :email, with: "bob@example.com"
            fill_in :password, with: "password"
            click_button("Submit")
          end

          expect(current_path).to eql("/merchant")
          expect(page).to have_content("You are logged in")
        end
      end

      context 'If I am a admin user' do
        it 'I am redirected to my admin dashboard page & nd I see a flash message that I am logged in' do
          admin = User.create(name: "admin_test_user",
                              address: "1111 Admin St",
                              city: "Lakewood",
                              state: "CA",
                              zip: "80232",
                              email: "camp@example.com",
                              password: "password123",
                              password_confirmation: "password123",
                              role: 2)

          visit '/login'

          within(".login_form") do
            fill_in :email, with: "camp@example.com"
            fill_in :password, with: "password123"
            click_button("Submit")
          end

          expect(current_path).to eql("/admin")
          expect(page).to have_content("You are logged in")
        end
      end
    end

    describe 'When I submit invalid information' do
      it 'Then I am redirected to the login page
          And I see a flash message that tells me that my credentials were incorrect
          I am NOT told whether it was my email or password that was incorrect' do

        visit '/login'

        within(".login_form") do
          fill_in :email, with: "wrongemail@example.com"
          fill_in :password, with: "wrongpassword"
          click_button("Submit")
        end

        expect(current_path).to eq("/login")
        expect(page).to have_content("Email and/or Password is incorrect")
      end
    end
  end
end
