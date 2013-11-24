require 'spec_helper'

describe Api::V1::NewsController, :type => :api do

  it "get news list without any params" do
    # create user and news for him
    user = FactoryGirl.build(:confirmed_user)
    post = FactoryGirl.build(:post)
    post.resource = FactoryGirl.build(:article)
    post.save

    user.posts << post

    get :index, {tournament_id: "itleague", :format => :json}

    response.content_type.should == 'application/json'
    response.status.should == 200

    parsed_body = JSON.parse(response.body)

    #should have news and news count
    parsed_body.should have_at_least(2).item

    # should return one news
    parsed_body["news"].size.should == 1

  end

  it "get news list with noninteger params should return 403 error status" do
    # create user and news for him
    user = FactoryGirl.build(:confirmed_user)
    post = FactoryGirl.build(:post)
    post.resource = FactoryGirl.build(:article)
    post.save

    user.posts << post

    get :index, {tournament_id: "itleague", page: "a", format: :json}

    response.content_type.should == 'application/json'
    response.status.should == 403

    get :index, {tournament_id: "itleague", per_page: "a", format: :json}

    response.content_type.should == 'application/json'
    response.status.should == 403
  end

  it "get the news by real id" do
    # create user and news for him
    user = FactoryGirl.build(:confirmed_user)
    post = FactoryGirl.build(:post)
    post.resource = FactoryGirl.build(:article)
    post.save

    user.posts << post

    get :index, {tournament_id: "itleague", id: post.id, format: :json}

    response.content_type.should == 'application/json'
    response.status.should == 200
  end

  it "get the news by incorrect id" do
    # create user and news for him
    user = FactoryGirl.build(:confirmed_user)
    post = FactoryGirl.build(:post)
    post.resource = FactoryGirl.build(:article)
    post.save

    user.posts << post

    get :show, {tournament_id: "itleague", id: "xxx", format: :json}

    response.content_type.should == 'application/json'
    response.status.should == 404
  end

end
