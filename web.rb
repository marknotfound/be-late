require 'rubygems'
require 'twilio-ruby'
require 'sinatra'
require 'json'
require 'date'

users = [
  # Add names and phone numbers here
  {
    "name" => "FirstName LastName",
    "phones" => [ "+15555555555", "+15555555556" ]
  }
]

get '/' do
  account_sid = 'TWILIO_ACCOUNT_SID'
  auth_token = 'TWILIO_AUTH_TOKEN'
  @client = Twilio::REST::Client.new account_sid, auth_token

  lates = []

  messages = @client.account.messages.list({ :date_sent => Date.today.to_s })

  messages.each do |message|
    if message.status == 'received'
      data = { 'name' => get_name(message.from, users), 'late_by' => message.body }
      lates.push(data)
    end
  end

  content_type :json
  lates.to_json
end

def get_name(phone_number, users)
  for user in users
    if user['phones'].include?(phone_number)
      return user['name']
    end
  end

  return "Unknown - #{phone_number}"
end
