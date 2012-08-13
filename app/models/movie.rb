class Movie < ActiveRecord::Base
  def self.scope_by_ratings(ratings)
    scope :byrating, where(:rating => ratings)
  end
  def self.all_ratings
    @all_ratings=[]
    Movie.all.each do |m|
      @all_ratings.push m.rating
    end
    # pluck not working as per documentation! :( 
    # Movie.pluck(:rating)
    @all_ratings.uniq
    # Since the ratings list is hard-coded in new.haml.. we ca
    # do the same here? argument is whether we need to show
    # values for which movies dont exist
    @all_ratings=['G','PG','PG-13','R','NC-17']
  end
end
