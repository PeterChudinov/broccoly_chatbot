class MessengerController < Messenger::MessengerController
  def webhook
    logger.debug "params: #{params}"
    if fb_params.first_entry.callback.message?
      Messenger::Client.send(
          Messenger::Request.new(
              Messenger::Elements::Text.new(text: 'some text'),
              fb_params.first_entry.sender_id
          )
      )
    end
    render nothing: true, status: 200
  end
end