class ContactDecorator < Draper::Decorator
  delegate_all

  def full_name
    [last_name.titleize, first_name.titleize].join(', ')
  end
end
