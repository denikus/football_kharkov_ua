require 'spec_helper'

describe Api::V1::SeasonsController do
  pending
  #let(:season1) {FactoryGirl.build(:season)}
  #let(:season2) {FactoryGirl.build(:season)}

  it "should be able get list of seasons without params" do
    pending
    get :index, {tournament_id: "seasons", :format => :json}

    response.content_type.should == 'application/json'
    response.status.should == 200

    parsed_body = JSON.parse(response.body)

    #should have seasons
    parsed_body["seasons"].size.should == 2
  end

end
