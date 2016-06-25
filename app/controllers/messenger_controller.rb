class MessengerController < Messenger::MessengerController
  def webhook
    logger.debug "params: #{params}"
    if fb_params.message?
      Messenger::Client.send(
          Messenger::Request.new(
              Messenger::Elements::Text.new(text: 'some text'),
              fb_params.sender_id
          )
      )
    end
    render nothing: true, status: 200
  end
end