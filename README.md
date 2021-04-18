# Setup

Install ruby: https://www.ruby-lang.org/en/documentation/installation/

To run code, enter `ruby main.rb` in your CLI.

You can update the start_date, end_date and threshold variables on line 3 of `main.rb` to test other cases.

# Summary

This app will return a list of users who qualify for VIP status within a specified time range and threshold.

For example, if you enter '2021-01-01' as your start_time, '2021-02-24' as your end_time and 30 as your threshold, the output will include all users that have spent $30 within BOTH January 2021 and February 2021.

I chose to allow for a variable number of consecutive months as input by implementing a date range within the `count_consecutive_months_required` method which is run when
generating the final output in the `filter_below_threshold` method.
