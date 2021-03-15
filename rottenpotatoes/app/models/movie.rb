class Movie < ActiveRecord::Base
    def self.all_ratings()
        return ['G', 'PG', 'PG-13', 'R']
    end

    def self.findSimilarMovies(id)
        
            movie = Movie.find(id)
      
            if not movie.director.empty?
                dir = movie.director
            else
                dir = ""
            end
       
            

            if(dir != "")
                
                return self.where(director: dir)
            else 
                return nil
            end
       
    end
    
    def self.getFilm(id)
       return Movie.find(id) 
    end
end