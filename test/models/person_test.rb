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

  test "accepted without an end date are active on dates after their start date" do
    assert people(:gideon).active_on?(Date.new(2050, 1, 1))
    assert people(:gideon).active_on?(Date.new(2022, 1, 1))
  end

  test "accepted are not active on dates before their start date" do
    assert_not people(:gideon).active_on?(Date.new(2010, 1, 1))
  end

  test "not accepted are not active for any date" do
    assert_not people(:pyrrha).active_on?(Date.new(2010, 1, 1))
    assert_not people(:pyrrha).active_on?(Date.new(2022, 1, 1))
    assert_not people(:pyrrha).active_on?(Date.new(2052, 1, 1))
  end

  test "accepted with an end date are active before that date" do
    assert people(:camilla).active_on?(Date.new(2052, 1, 1))
  end

  test "accepted with an end date are inactive after that date" do
    assert_not people(:camilla).active_on?(Date.new(2100, 1, 1))
  end

  test "active with three assemblies count towards quorum" do
    assert people(:harrow).counts_toward_quorum?
  end

  test "active with three missed assemblies count towards quorum after an electronic vote" do
    assert people(:gideon).counts_toward_quorum?
    assert people(:gideon).counts_toward_quorum_on?(Date.new(2022, 07, 15))
  end

  test "active with three missed assemblies don’t count towards quorum before an electronic vote" do
    assert_not people(:gideon).counts_toward_quorum_on?(Date.new(2022, 06, 15))
  end

  test "palamedes in quorum" do
    assert people(:palamedes).counts_toward_quorum_on?(Date.new(2022, 01, 01))
    assert people(:palamedes).counts_toward_quorum_on?(Date.new(2022, 04, 01))
    assert_not people(:palamedes).counts_toward_quorum_on?(Date.new(2022, 05, 01))
  end

  test "active who didn’t have a chance to miss three assemblies count towards quorum" do
    assert people(:camilla).counts_toward_quorum?
  end

  test "inactive don’t count towards quorum" do
    assert_not people(:pyrrha).counts_toward_quorum?
    assert_not people(:palamedes).counts_toward_quorum?
  end

  test "quorum is counted correctly" do
    assert_equal Person.count_toward_quorum, 3
  end

  test "quorum is counted correctly in the past" do
    assert_equal Person.count_toward_quorum_on(Date.new(2021, 5, 1)), 3
    assert_equal Person.count_toward_quorum_on(Date.new(2022, 1, 1)), 3
    assert_equal Person.count_toward_quorum_on(Date.new(2022, 5, 1)), 1
    assert_equal Person.count_toward_quorum_on(Date.new(2022, 6, 1)), 1
    assert_equal Person.count_toward_quorum_on(Date.new(2022, 8, 1)), 3
  end

  test "members count is correct" do
    assert_equal Person.members_count, 3
  end
end
