
Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create movie
  end
end
Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end
Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(page.body.index(e1) < page.body.index(e2))
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(', ').each do |rating|
    step %{I #{uncheck.nil? ? '' : 'un'}check "ratings_#{rating}"}
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  Movie.all.each do |movie|
    step %{I should see "#{movie.title}"}
  end
end
  
Then /the director of "(.*)" should be "(.*)"/ do |d, ans|
  testVal = false;
  Movie.where(title: d).each do |val|
     if val.director == ans 
       testVal = true
     end
  end
  
  
  if testVal.respond_to? :should
      testVal.should == true
   else
      assert testVal
  end
end

Then /I should(nt)? see every movie with the ratings: (.*)/ do | nt, ratings_list|
  # Make sure that all the movies in the app are visible in the table
  testVal = nt ? false : true
  listArr = ratings_list.split(',')

  Movie.all.each do |val|
    
    check = false;
    listArr.each do |validRating|
     
      if val.rating == validRating.strip
        check =  true
      end
      
    end
    
    if check
     
      if nt
        if page.body.match?(val.title)
        else
          testVal = false
        end
      else
        if page.body.match?(val.title)
          testVal =true
        end
      end
    end
  end
  
  if testVal.respond_to? :should
      if nt
        testVal.should == false
      else
        testVal.should == true
      end
   else
      assert testVal
  end
  
 
end
