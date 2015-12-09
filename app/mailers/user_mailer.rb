class UserMailer < ApplicationMailer

  def notify_jtext(user, jtext_and_keywords)
    @user = user
    @jtext_and_keywords = jtext_and_keywords
    mail(to: @user.email, subject: 'JO: De nouveaux textes peuvent vous intéresser')
  end

end
