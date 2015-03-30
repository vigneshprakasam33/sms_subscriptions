class UserMailer < ActionMailer::Base
  default :from => "\"Real Mobile\" <sms@realmobile.se>"

  if Rails.env.production?
    default bcc:  'vigneshp.ceg@gmail.com'
  else
    #default bcc:  'rparashar@anpi.com'
  end

  def send_feedback(f)
    @feedback = f
    if Rails.env.production?
      mail(to: "david@realmobile.se", subject: 'New Support query')
    else
      mail(to: "vigneshp.ceg@gmail.com", subject: 'New Support query')
    end
  end

  def error_notification(f , phone)
    @error = f
    @phone = phone
    if Rails.env.production?
      mail(to: "david@realmobile.se", subject: 'SMS delivery error')
    else
      mail(to: "vigneshp.ceg@gmail.com", subject: 'SMS delivery error')
    end
  end

end

