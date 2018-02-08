require "json"
require "file_utils"
require "./appear_in/*"

module AppearIn
  extend self

  def run_cli
    ARGV[0] ||= "list"
    case ARGV[0]
    when "list" then
      if ARGV.size == 2
        list_rooms(ARGV[1])
      else
        list_rooms
      end
    when "add" then
      raise "add takes 1 argument" unless ARGV[1]
      add_room(ARGV[1])
    when "rm" then
      raise "rm takes 1 argument" unless ARGV[1]
      remove_room(ARGV[1])
    else
      raise "No command #{ARGV[0]}"
    end
  end

  private def list_rooms(input : String? = nil)
    rooms = Storage.matching_rooms(input)
    items = rooms.map { |room|
      {
        uid: room,
        title: room,
        arg: room,
        autocomplete: room,
        mods: {
          alt: {
            valid: true,
          },
        },
      }
    }

    if input && !rooms.includes?(input)
      items.push({
        uid: input,
        title: input,
        arg: input,
        autocomplete: input,
        mods: {
          alt: {
            valid: false,
          },
        },
      })
    end

    { items: items }.to_json(STDOUT)
  end

  private def add_room(room : String)
    Storage.add(room)
  end

  private def remove_room(room : String)
    Storage.remove(room)
  end
end

FileUtils.mkdir_p(ENV["alfred_workflow_data"])
FileUtils.cd(ENV["alfred_workflow_data"])
AppearIn::Storage.setup
AppearIn.run_cli
