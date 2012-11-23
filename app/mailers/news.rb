class News < ActionMailer::Base

  def news_info(user, broadcast)
    @broadcast = broadcast
    mail to: user.email, subject: "#{broadcast.title}", from: "#{broadcast.branch.name}-GUTREES"
  end
end
