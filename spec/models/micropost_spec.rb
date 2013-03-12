require 'spec_helper'

describe Micropost do

	let(:user) {FactoryGirl.create(:user)  }

	before {@mcriopost = user.microposts.build(content: "blah blah")}
	
	subject {@mcriopost}

	it {should respond_to(:content)}
	it {should respond_to(:user_id)}
	it {should respond_to(:user)}
	its(:user) { should == user }

	it {should be_valid}
 
	describe "the user_id is present" do
		before {@mcriopost.user_id = nil}

		it {should_not be_valid}
	end

	describe "assessible attributes" do
		it "should not allow access to the user_id" do
			expect do
				Micropost.new(user_id: user.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "when user_id is not present" do
		before { @mcriopost.user_id = nil}
		it {should_not be_valid}
	end

	describe "with blank content" do
		before {@mcriopost.content = " "}
		it {should_not be_valid}
	end

	describe "with content that is too long" do
		before {@mcriopost.content = "a" * 141}
		it {should_not be_valid}
	end	

end
