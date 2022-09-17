require "test_helper"

class PersonTest < ActiveSupport::TestCase
  test "accepted without an end date are active" do
    assert people(:gideon).active?
    assert people(:harrow).active?
  end

  test "not accepted are not active" do
    assert_not people(:pyrrha).active?
  end

  test "accepted with an end date in the future are active" do
    assert people(:camilla).active?
  end

  test "accepted with an end date in the past are not active" do
    assert_not people(:palamedes).active?
  end
end
