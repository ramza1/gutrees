class MailsWorker
  include Sidekiq::Worker

  def perform(branch_id, broadcast_id)
    branch = Branch.find(branch_id)
    broadcast = Broadcast.find(broadcast_id)
    branch.users.find_each do |user|
      News.news_info(user, broadcast).deliver
    end
  end
end