# frozen_string_literal: true

class FakeDiscourse
  attr_accessor :groups

  def initialize
    @groups = Hash.new { |hash, key| hash[key] = Set.new }
  end

  def list_group_members(group_name)
    @groups[group_name].to_a
  end

  def add_to_group(group_name, *people)
    usernames = Array(people).flatten.map(&:discourse_username)
    @groups[group_name].merge(usernames)
  end

  def remove_from_group(group_name, *people)
    usernames = Array(people).flatten.map(&:discourse_username)
    @groups[group_name].subtract(usernames)
  end
end
