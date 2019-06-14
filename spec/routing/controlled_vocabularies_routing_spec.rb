require "rails_helper"

RSpec.describe ControlledVocabulariesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/controlled_vocabularies").to route_to("controlled_vocabularies#index")
    end

    it "routes to #new" do
      expect(:get => "/controlled_vocabularies/new").to route_to("controlled_vocabularies#new")
    end

    it "routes to #show" do
      expect(:get => "/controlled_vocabularies/1").to route_to("controlled_vocabularies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/controlled_vocabularies/1/edit").to route_to("controlled_vocabularies#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/controlled_vocabularies").to route_to("controlled_vocabularies#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/controlled_vocabularies/1").to route_to("controlled_vocabularies#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/controlled_vocabularies/1").to route_to("controlled_vocabularies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/controlled_vocabularies/1").to route_to("controlled_vocabularies#destroy", :id => "1")
    end
  end
end
