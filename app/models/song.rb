class Song < ActiveRecord::Base
  validates :title, presence: true
  validate :same_year_released_validator
  validate :release_validator

  private

  def same_year_released_validator
    songs_by_artist = Song.where(artist_name: self.artist_name)
    unless songs_by_artist.nil?
      songs_by_artist.each do |song|
        if song.release_year == self.release_year && song.title == self.title
          errors.add(:release_year, "Cannot have the same song title in the same year")
        end
      end
    end
  end

  def release_validator
    if self.released && self.release_year.nil?
      errors.add(:release_year, "Cannot be blank if song is released")
    end
    unless self.release_year.nil?
      if self.release_year > Time.now.year
        errors.add(:release_year, "Cannot be in the future")
      end
    end
  end


end
