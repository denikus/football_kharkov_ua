class UserFootballerMerge < ActionMailer::Base
  default :from => "football.kharkov.ua@gmail.com"

  def successful_merge(request)
    @footballer = request.footballer
      mail(:to => request.user.email,
         :subject => "Заявка одобрена!")
  end
end
