require 'test_helper'

class StatisticsControllerTest < ActionController::TestCase
  context "on GET to index" do
    setup do
      @number_of_gems           = 1337
      @number_of_users          = 101
      @number_of_downloads      = 42
      @most_downloaded          = [Factory(:rubygem)]

      stub(User).count { @number_of_users }
      stub(Rubygem).total_count { @number_of_gems }
      stub(Rubygem).sum { @number_of_downloads }
      stub(Rubygem).downloaded { @most_downloaded }

      get :index
    end

    should_respond_with :success
    should_render_template :index
    should_assign_to(:number_of_gems) { @number_of_gems }
    should_assign_to(:number_of_users) { @number_of_users }
    should_assign_to(:number_of_downloads) { @number_of_downloads }
    should_assign_to(:most_downloaded) { @most_downloaded }

    should "display number of gems" do
      assert_contain "1,337"
    end

    should "display number of users" do
      assert_contain "101"
    end

    should "display number of downloads" do
      assert_contain "42"
    end

    should "load up the number of gems, users, and downloads" do
      assert_received(User)     { |subject| subject.count }
      assert_received(Rubygem)  { |subject| subject.total_count }
      assert_received(Rubygem)  { |subject| subject.sum.with(:downloads) }
      assert_received(Rubygem)  { |subject| subject.downloaded.with(10) }
    end
  end

  context "on GET to recent_gems_created" do
    setup do
      stub(Rubygem).sparkline_data_from_past { [10, 0] }
      get :recent_gems_created
    end

    should "return comma-separated values" do
      assert_equal "10,0", @response.body
    end
  end

  context "on GET to recent_users_created" do
    setup do
      stub(User).sparkline_data_from_past { [10, 0] }
      get :recent_users_created
    end

    should "return comma-separated values" do
      assert_equal "10,0", @response.body
    end
  end

  context "on GET to recent_downloads_created" do
    setup do
      stub(Download).sparkline_data_from_past { [10, 0] }
      get :recent_downloads_created
    end

    should "return comma-separated values" do
      assert_equal "10,0", @response.body
    end
  end
end
