require "set"

module AppearIn
  module Storage
    FILE_PATH = "./rooms"
    extend self

    def setup
      File.touch(FILE_PATH) unless File.exists?(FILE_PATH)
    end

    def matching_rooms(input : Nil)
      all
    end

    def matching_rooms(input : String)
      regex = /#{input}/i
      all.select(&.match(regex))
    end

    def add(room : String)
      update do |rooms|
        rooms << room
      end
    end

    def remove(room : String)
      update do |rooms|
        rooms.delete(room)
      end
    end

    private def all
      File.each_line(FILE_PATH).to_set
    end

    private def update
      rooms = all

      yield rooms

      File.open(FILE_PATH, "w") do |file|
        rooms.each do |room|
          file.puts(room)
        end
      end
    end
  end
end
