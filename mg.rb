require 'mail'

Mail.defaults do
  delivery_method :smtp, {
    :port      => 587,
    :address   => "smtp.mailgun.com",
    :user_name => "buywaylink.com@gmail.com",
    :password  => "haribabu",
  }
end

mail = Mail.deliver do
  to      'itzhari.g@gmail.com'
  from    'info@buywaylink.com'
  subject 'Hello'

  text_part do
    body 'Testing some Mailgun awesomness'
  end
end