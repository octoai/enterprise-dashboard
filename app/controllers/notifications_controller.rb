class MessagesController < ApplicationController

  get '/' do
    messages = [
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
    messages.to_json
  end

end