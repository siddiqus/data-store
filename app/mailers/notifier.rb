class Notifier < ActionMailer::Base
  default :from => "noreply@dataentry.org"

  def reset_password(user)
    @user = user
    mail(:to => user.email, :subject => 'Account Password Reset')
  end

  def verify(user)
    @user = user
    mail(:to => user.email, :subject => 'Account Verification')
  end
end
