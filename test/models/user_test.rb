require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should clock in" do
    michael = User.create(name: "michael")
    clock_in = michael.clock_in("2021-01-01", "2021-01-02")
    assert michael.clock_ins.size.equal? 1
    assert michael.clock_ins.first.id.equal? clock_in.id
  end

  test "get clock ins by created time and only last week" do
    michael = User.create(name: "michael")
    clock_in_1 = michael.clock_in("2021-01-01", "2021-01-02")
    clock_in_2 = michael.clock_in("2021-01-01", "2021-01-02")

    assert michael.clock_ins.size.equal? 2
    assert michael.clock_ins.first.id.equal? clock_in_2.id
    assert michael.clock_ins[1].id.equal? clock_in_1.id
  end

  test "should follow" do
    michael = User.create(name: "michael")
    archer  = User.create(name: "archer")
    michael.follow(archer.id)
    assert michael.followers.size == 0
    assert michael.followings.size == 1
    assert archer.followers.size == 1
    assert michael.followings.first.id.equal? archer.id
  end 

  test "fail to follow" do
    michael = User.create(name: "michael")
    fl = michael.follow(0)
    assert fl.errors.size > 0
    assert fl.errors.full_messages[0] == "Following must exist"
  end 

  test "should unfollow" do
    michael = User.create(name: "michael")
    archer  = User.create(name: "archer")
    michael.follow(archer.id)
    assert michael.unfollow(archer.id)
    assert michael.followers.size == 0
    assert michael.followings.size == 0
    assert archer.followers.size == 0
  end

  test "do not fail on unfollow, and return false" do
    michael = User.create(name: "michael")
    archer  = User.create(name: "archer")
    assert_not michael.unfollow(archer.id)
  end 

  test "feed should have the right clock ins" do
    michael = User.create(name: "michael")
    archer  = User.create(name: "archer")
    lana    = User.create(name: "lana")

    michael.follow(lana.id)
  
    ci_1 = michael.clock_in("2019-01-01", "2019-01-02")
    ci_2 = archer.clock_in("2020-01-01", "2020-01-02")
    ci_3 = lana.clock_in("2021-01-01", "2021-01-03")
    ci_4 = lana.clock_in("2021-01-01", "2021-01-05")
    ci_past = lana.clock_in("2021-01-01", "2021-01-02")
    ci_past.created_at = DateTime.now - 7.days - 1.second
    ci_past.save
    
    assert michael.feed.include?(ci_1)
    assert michael.feed.include?(ci_3)
    assert michael.feed.include?(ci_4)
    assert_not michael.feed.include?(ci_2)
    assert_not michael.feed.include?(ci_past)

    # check order from duration
    assert michael.feed[0].id.equal?(ci_4.id)
    assert michael.feed[1].id.equal?(ci_3.id)
  end
end
