class Movie < ActiveRecord::Base
  def self.all_ratings
    return ["G", "PG", "PG-13", "R"]
  end

  def self.with_ratings(ratings_list)
    ratings_list.present? ? where(rating: ratings_list) : all
  end

end
