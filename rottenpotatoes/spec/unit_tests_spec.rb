
require 'rails_helper'


if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end

describe MoviesController, type: :controller do

  let(:movieA) {double(:movie, :title => "Some film")} #Film with no director
  let(:movieB) {double(:movie, :title => "Some film 2: Electric Boogaloo", :director =>"Smith")} #Film with no director
  let(:movieC) {double(:movie, :title => "Another film", :director =>"John")} #Film with no director
  
  let(:results) {double(:movie, :title => "Some film")} #Example
  let(:noResults) {""} #Film with no director
  let(:manyResults) {[:movieA, :movieB]} #Film with no director
  
  it "If a movie has a director, it should display similar movies with that director" do
      Movie.stub(:findSimilarMovies).and_return(:results)
      Movie.stub(:getFilm).and_return(movieA)
      get :similar, {:id => 1234}
      expect(assigns(:movies)).to eq(:results)
      expect(assigns(:movie)).to eq(movieA)
  end
  
  it "When the movie has no director, it should display an error message and redirect to index" do
    
    Movie.stub(:findSimilarMovies).and_return(nil)
     Movie.stub(:getFilm).and_return(movieA)
    
    get :similar, {:id => 1234}
    expect(flash[:notice]).to be_present
    expect(response).to redirect_to(movies_path) 
  end
  
  it "When a movie rating is R, we should see it appear when the rating is \"R\"" do
    get :index, {:ratings => {"R" => "1"}}
    expect(assigns(:movies)).not_to eq("")
  end
  
  it "When the sort variable is active, we should see the movies sorted by said category" do
    get :index, {:ratings => {"R" => "1"},:sortVar => "R"}
   
    expect(assigns(:movies)).not_to eq("")
  end
  
   it "When the ratings and session are null, we should see all movies" do
    get :index, {:ratings => nil ,:session => nil}
    expect(assigns(:movies)).not_to eq("")
  end
  
  it "Adding a movie triggers a flash message" do
     get :create, "movie"=>{"title"=>"A", "director"=>"B", "rating"=>"G", "release_date(1i)"=>"2021", "release_date(2i)"=>"3", "release_date(3i)"=>"15"}
     expect(flash[:notice]).to be_present
  end
    


 
end