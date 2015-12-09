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
          put :update, id: @user.id, "keywords" =>["sisi"]
        end

        it "add the keyword to the user" do
          expect(@user.keywords.length).to eq(1)
          expect(@user.keywords.first.label).to eq('sisi')
        end
      end

      context 'when i remove a keyword' do
        before do
          k = Keyword.create!(label:'sisi')
          @user.keywords << k
          put :update, id: @user.id, "keywords" =>[]
        end

        it "removes the keywords" do
          expect(subject.current_user.keywords.length).to eq(0)
        end
      end

      context 'with 2 already known keywords' do
        before do
          Keyword.create!(label:'sisi')
          Keyword.create!(label:'princesse')
          put :update, id: @user.id, "keywords" =>["sisi", "princesse"]
        end

        it "add the keyword to the user" do
          expect(subject.current_user.keywords.length).to eq(2)
          expect(subject.current_user.keywords.first.label).to eq('sisi')
        end
      end

      context 'with a unknown keyword' do
        before do
          put :update, id: @user.id, "keywords" =>["sisi"]
        end

        it "the keyword is not added" do
          expect(@user.keywords.length).to eq(0)
        end
      end

    end

  end
end