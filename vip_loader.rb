require 'date'
require './user_data'

class VipLoader
  def initialize(start_date, end_date, threshold)
    @start_date = start_date
    @end_date   = end_date
    @threshold  = threshold
  end

  def get_vip_users
    begin
      purchases    = load_date_range
      user_amounts = {}
      vip_users    = {}

      calculate_monthly_user_totals(purchases, user_amounts)

      # Remove amounts below the inputted threshold
      user_amounts.delete_if { |k, v| v < @threshold }

      filter_below_threshold(user_amounts, vip_users)

      # Return array of user ids with VIP status
      return vip_users.keys
      
    rescue StandardError => e
      puts e.message
    end
  end

  private

  # Calculate total amount spent per user within each month and store in user_amounts var
  def calculate_monthly_user_totals(purchases={}, user_amounts)
    purchases.each do |p|
      month = p[:date].split('-')[1]
      year  = p[:date].split('-')[0]

      if !user_amounts.keys.include?("#{p[:user]}-#{month}-#{year}")
        user_amounts["#{p[:user]}-#{month}-#{year}"] = p[:amount]
      else
        user_amounts["#{p[:user]}-#{month}-#{year}"] += p[:amount]
      end
    end
  end

  # Calculate the number of required consecutive months to qualify for VIP status
  def count_consecutive_months_required
    ((@end_date.year * 12 + @end_date.month) - (@start_date.year * 12 + @start_date.month)) + 1
  end

  # Parse list of users that have the required number of consecutive monthly payment amounts above the threshold
  def filter_below_threshold(user_amounts, vip_users)
    required_consecutive_months = count_consecutive_months_required

    user_amounts.each do |k, v|
      user  = k.split('-')[0]

      if !vip_users.keys.include?(user)
        vip_users[user] = 1
      else
        vip_users[user] += 1
      end
    end

    vip_users.delete_if { |k, v| v < required_consecutive_months }
  end

  # First load data from user purchases that occur between the inputted start and end dates
  # Then sort data by user id and secondary sort by date
  def load_date_range
    USER_DATA.select { |user| DateTime.parse(user[:date]).between?(@start_date, @end_date) }
             .sort_by { |user| [user[:user], user[:date]] }
  end

end
