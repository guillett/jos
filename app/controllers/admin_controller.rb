class AdminController < ApplicationController

  before_action :authenticate_user!

  def index

  end

  def send_emails
    last_container = Jorfcont.where.not(publication_date: '2999-01-01 00:00:00.0').order(publication_date: :desc).first
    mail_people([last_container])
    redirect_to action: "index"
  end

  private
  def mail_people jcontainers
    # user: [{jtext: jtext, keywords: [keyw1, keyw2]}]
    users_h = {}

    jcontainers.each do |jcontainer|
      jcontainer.jtexts.each do |jtext|
        jtext_keyword_labels = jtext.keywords.map(&:label)
        users = User.joins(:keywords).where(keywords: {label: jtext_keyword_labels})
        users.each do |user|

          jtext_and_keywords = {jtext: jtext, keywords: user.keywords.map(&:label) & jtext_keyword_labels}

          if users_h[user].nil?
            users_h[user] = [jtext_and_keywords]
          else
            users_h[user] << jtext_and_keywords
          end
        end
      end

    end

    users_h.each do |user, jtext_and_keywords|
      mail(user: user, jtext_and_keywords: jtext_and_keywords)
    end

  end

  def mail options
    puts "mailing #{options[:user].email}"
    UserMailer.notify_jtext(options[:user], options[:jtext_and_keywords]).deliver_now()
  end

end
