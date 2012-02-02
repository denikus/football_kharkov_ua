# -*- encoding : utf-8 -*-
class FootballPlayerAppointment < ActiveRecord::Base
  belongs_to :competitor
  belongs_to :footballer

  def response_to_s
    string_responses = {:accepted => "Придет", :declined => "Не придет", :tentative => "Не уверен", :not_responded => "Не ответил"}
    string_responses[response]
  end
end
