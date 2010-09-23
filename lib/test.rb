require 'date'
test_str       = "[[schedule::univercup--autumn-winter-2010--2010--09--24----2010--09--26]]"
#test_str       = "[[schedule::univercup--autumn-winter-2010--2010--09--24]]"
test_str       = "sdfs;dflks kdfs dfks dkfsd f[[schedule::univercup--autumn-winter-2010--2010--09--24]] sdfuotowjfksdfl sjfl js
[[schedule::univercup--autumn-winter-2010--2010--09--26]]
"
#test_str.sca(/\[\[\]\]/)
#p test_str.scan(/\[\[schedule::(.*?)\]\]/)
#get params string
Schedule.find(:all, :conditions => ["season_id = ? AND match_on >= ? AND match_on <= ?", 2, "Fri, 24 Sep 2010".to_date, "Fri, 24 Sep 2010".to_date] )

=begin

if /\[\[schedule::(.*)\]\]/=~test_str
  params_str = $1

  #last date
  params_arr = params_str.split('----')

  start_params = params_arr[0].split('--')
  p "tournament: #{start_params[0]}"
  p "season: #{start_params[1]}"

  start_date = Date.new(start_params[2].to_i, start_params[3].to_i, start_params[4].to_i)

  if params_arr.length>1
    last_date_arr = params_arr[1].split('--')
    final_date = Date.new(last_date_arr[0].to_i, last_date_arr[1].to_i, last_date_arr[2].to_i)
  else
    final_date = start_date
  end
end

=end
