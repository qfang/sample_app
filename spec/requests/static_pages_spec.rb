require 'spec_helper'

describe "StaticPages" do

  subject {page}

  describe "Home page" do
    before {visit root_path}

    it {should have_selector('h1', :text => 'Sample App')}
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector 'title', text: '| Home' }
  
    describe "for sign in user" do
      let(:user) {FactoryGirl.create(:user)  }

      before do
        FactoryGirl.create(:micropost, user: user, content: "test 1")
        FactoryGirl.create(:micropost, user: user, content: "test 2 ")
        sign_in user
        visit root_path
      end

      it "it should render feeds" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end  

      describe "following/followers counts" do
        let(:other_user) { FactoryGirl.create(:user)  }
        before do
         other_user.follow!(user)
         visit root_path
        end

        it {should have_link("0 following", href: following_user_path(user))}
        it {should have_link("1 followers", href: followers_user_path(user))}
      end
    end
  end

  describe "Help Page" do
    before { visit help_path }

    it { should have_selector('h1',    text: 'Help') }
    it { should have_selector('title', text: full_title('Help')) }
  end

  describe "About page" do

    it "should have the h1 'About Us'" do
      visit about_path
      page.should have_selector('h1', :text =>'About Us')
    end

    it "should have the title 'About" do
      visit about_path
      page.should have_selector('title',
                        :text => "Ruby on Rails Tutorial Sample App | About Us")
    end
  end

  describe "Contact page" do

    it "should have the h1 'Contact'" do
      visit contact_path
      page.should have_selector('h1', text: 'Contact')
    end

    it "should have the title 'Contact'" do
      visit contact_path
      page.should have_selector('title',
                    text: "Ruby on Rails Tutorial Sample App | Contact")
    end
  end

end
