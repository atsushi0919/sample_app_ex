class ApplicationMailer < ActionMailer::Base
  default from: "foo@example.com"
  layout "mailer"
end
