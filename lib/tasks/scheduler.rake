require 'nokogiri'
require "httparty"
require 'sendgrid-ruby'
include SendGrid


desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
    html = HTTParty.get('https://shop.lululemon.com/p/men-shorts/Commission-Short-Classic-Warpstreme-9/_/prod9610182?color=31311&sz=30')
    response = Nokogiri::XML(html)
    # # url = 'https://en.wikipedia.org/wiki/Recursion_(computer_science)'
    # page = Nokogiri::HTML(open(url))

    if response.css('.notificationBlock-klGFi').length === 0
        puts "In stock"


        data = {
        'personalizations': [
          {
            'to': [
              {
                'email': 'jflashner17@gmail.com'
              }
            ],
            'subject': 'Item Back in-stock'
          }
        ],
        'from': {
          'email': 'jflashner17@gmail.com'
        },
        'content': [
          {
            'type': 'text/plain',
            'value': 'Your item is in stock'
          }
        ]
      }
      
      key = ENV["API_KEY"]
      sg = SendGrid::API.new(api_key: key)
      response = sg.client.mail._("send").post(request_body: data)
      puts response.status_code
      puts response.body
      puts response.headers


    else
        tester = response.css('.notificationBlock-klGFi')
        hash = Hash.from_xml(tester.to_s)["div"]["div"]
        puts hash
    end
end

task :send_reminders => :environment do
  User.send_reminders
end