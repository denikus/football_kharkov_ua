include ActionView::Helpers::UrlHelper
include ActionView::Helpers::SanitizeHelper
include ActionController::UrlWriter
class SchedulePost < ActiveRecord::Base
  has_one :post, :as => :resource, :dependent => :destroy

  def before_save
    self.generated_body = generate_schedule_widget(self.body) 
  end

  def generate_schedule_widget(body)
    #search for widget string
    schedule_widgets = body.scan(/\[\[schedule::(.*?)\]\]/)
    generated_body = body.dup
    unless schedule_widgets.empty?
      schedule_widgets.each do |widget_params_str|
        grouped_schedules = {}
        widget_options = parse_widget_params(widget_params_str[0])
        tournament = Tournament.find_by_url(widget_options[:tournament_url])

        season = tournament.seasons.find_by_url(widget_options[:season_url])
        schedules = Schedule.find(:all, :conditions => ["season_id = ? AND match_on >= ? AND match_on <= ?", season.id, widget_options[:start_date], widget_options[:final_date]], :order => "match_on, match_at ASC" )
        schedules.each do |item|
          if grouped_schedules[item[:match_on].to_s].nil?
            grouped_schedules[item[:match_on].to_s] = []
          end  
          grouped_schedules[item[:match_on].to_s] << item
        end
        generated_block = ActionView::Base.new(Rails::Configuration.new.view_path).render(:partial => "/schedule_post/schedule_block", :locals =>{:schedule_blocks => grouped_schedules})
        generated_body.gsub!(/\[\[schedule::#{widget_params_str[0]}\]\]/, generated_block)
      end
    end
    return generated_body
  end

  private

  def parse_widget_params(params_str)
    params_arr = params_str.split('----')
    start_params = params_arr[0].split('--')

    start_date = Date.new(start_params[2].to_i, start_params[3].to_i, start_params[4].to_i)

    if params_arr.length>1
      last_date_arr = params_arr[1].split('--')
      final_date = Date.new(last_date_arr[0].to_i, last_date_arr[1].to_i, last_date_arr[2].to_i)
    else
      final_date = start_date
    end
    
    return {:tournament_url => start_params[0], :season_url => start_params[1],
            :start_date =>  start_date, :final_date => final_date}
  end
end
