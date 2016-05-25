class NotificationsController < ApplicationController

  get '/' do
    hashmap = [
      {
        title: 'Dummy1',
        keyword: 'keyword',
        time: '1 min ago',
        link: '#'
      },
      {
        title: 'Dummy2',
        keyword: 'keyword',
        time: '2 min ago',
        link: '#'
      }
    ]
    hashmap.to_json
  end

end