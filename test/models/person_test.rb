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

  test "active with three assemblies count towards quorum" do
    assert people(:harrow).counts_toward_quorum?
  end

  test "active with three missed assemblies don’t count towards quorum" do
    assert_not people(:gideon).counts_toward_quorum?
  end

  test "active who didn’t have a chance to miss three assemblies count towards quorum" do
    assert people(:camilla).counts_toward_quorum?
  end

  test "inactive don’t count towards quorum" do
    assert_not people(:pyrrha).counts_toward_quorum?
    assert_not people(:palamedes).counts_toward_quorum?
  end

  test "quorum is counted correctly" do
    assert Person.count_toward_quorum, 1
  end

  test "members count is correct" do
    assert Person.members_count, 3
  end
end
