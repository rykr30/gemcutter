class StatisticsController < ApplicationController
  def index
    @number_of_gems           = Rubygem.total_count
    @number_of_users          = User.count
    @number_of_downloads      = Rubygem.sum(:downloads)
    @most_downloaded          = Rubygem.downloaded(10)
    @recent_gems_created      = Rubygem.sparkline_data_from_past(30.days)
    @recent_users_created     = User.sparkline_data_from_past(30.days)
    @recent_downloads_created = Download.sparkline_data_from_past(30.days)
  end

  def recent_gems_created
    render :text => Rubygem.sparkline_data_from_past(30.days) * ","
  end

  def recent_users_created
    render :text => User.sparkline_data_from_past(30.days) * ","
  end

  def recent_downloads_created
    render :text => Download.sparkline_data_from_past(30.days) * ","
  end
end
