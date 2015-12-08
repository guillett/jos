require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "PUT #update" do

    context 'with a logged user' do
      before do
        @user = User.create!(email:"toto@toto.com", password:"12345678")
        sign_in :user, @user
      end

      context 'with a already known keyword' do
        before do
          Keyword.create!(label:'sisi')
          put :update, id: @user.id, "user" => {"keywords_attributes"=>{"1449591853754"=>{"label"=>"sisi", "_destroy"=>"false"}}}
        end

        it "add the keyword to the user" do
          expect(@user.keywords.length).to eq(1)
          expect(@user.keywords.first.label).to eq('sisi')
        end
      end

      context 'with a unknown keyword' do
        before do
          put :update, id: @user.id, "user" => {"keywords_attributes"=>{"1449591853754"=>{"label"=>"sisi", "_destroy"=>"false"}}}
        end

        it "the keyword is not added" do
          expect(@user.keywords.length).to eq(0)
        end
      end

    end

  end
end