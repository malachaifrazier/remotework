class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout 'non_transactional_email'
end
