class Profile < ActiveRecord::Base
  belongs_to :user
  has_one :profile_avatar

  GENDER_OPTIONS = [[:unknown, 'Еще не определился'], [:male, 'Мужик'], [:female, 'Дама']]
  USER_TYPE_OPTIONS = [[:fan, 'Болельщик'], [:footballer, 'Футболист']]
  ROLE_OPTIONS = [[:unknown, 'Еще не определился'], [:ball_boy, 'Подаю мячи'], [:goalkeeper, 'Вратарь'], [:fullback, 'Защитник'], [:halfback, 'Полузащитник'], [:forward, 'Форвард'], [:coach, 'Тренер']]
  
end
