require 'spec_helper'

describe "Authentication" do
	subject{ page }

  describe "signin page" do

  	before {visit signin_path}

  	it {should have_selector('h1', text: 'Sign in')}
  	it {should have_selector('title', text: 'Sign in')}

  	describe "with invalid information" do
  		before {click_button "Sign in"}

  		it { should have_selector('title', text: 'Sign in') }
		  it { should have_selector('div.alert.alert-error', text: 'Invalid') } 	
  	end

  	describe "with valid information" do
  		let (:user) {FactoryGirl.create(:user)}

  		before do
  			fill_in "Email", with: user.email.upcase
  			fill_in "Password", with: user.password
  			click_button "Sign in"
  		end
	      it { should have_selector('title', text: user.name) }
        it { should have_link('Users', href: users_path)}
	      it { should have_link('Profile', href: user_path(user)) }
        it { should have_link('Settings', href: edit_user_path(user)) }       
	      it { should have_link('Sign out', href: signout_path) }
	      it { should_not have_link('Sign in', href: signin_path) }
  	
      describe "followed by a sign out" do
        before {click_link "Sign out"}
        it { should have_link('Sign in')}
      end
    end
  end

  describe "authorization" do
    describe "for non-signed users" do
      let(:user) { FactoryGirl.create(:user)  }

      describe "in the Users controller" do
        before {visit edit_user_path(user)}
        it {should have_selector('title', text: 'Sign in')}  

        describe "visit the user index" do
          before {visit users_path}
          it { should have_selector('title', text: 'Sign in')}
        end   
      end

      describe "submitting to the update action" do
        before {put user_path(user)}
        specify {response.should redirect_to(signin_path)}
      end
    end 

    describe "as wrong user" do 
      let(:user) { FactoryGirl.create(:user)  }

      let(:wronguser) {FactoryGirl.create(:user, email: "wronguser@example.com")  }

      before { sign_in user}

      describe "visit user#edit page" do
        before {visit edit_user_path(wronguser)}
        it { should_not have_selector('title', text: full_title('Edit User'))}
      end

      describe "submitting a put request to the Users#update action" do
        before {put user_path(wronguser)}
        specify {response.should redirect_to(root_path)}
      end  
    end

    describe "for non-signed-in users" do
      let(:user) {FactoryGirl.create(:user) }

      describe "when attemptting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password

          click_button 'Sign in'
        end
        describe "after sign in " do
          it "should render selected protected page" do
            page.should have_selector('title', text:'Edit user')
          end  
        end
      end
    end 

    describe "for non-admin user" do
      let(:user) { FactoryGirl.create(:user)  }
      let(:non_admin) { FactoryGirl.create(:user)  }

      before { sign_in non_admin}
      describe "submitting a delete request to the Users#destroy " do
        before {delete user_path(user)}
        specify {response.should redirect_to(root_path)}
      end 
    end
  end
end
