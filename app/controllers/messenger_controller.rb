class MessengerController < Messenger::MessengerController
  def webhook
    # logger.debug "params: #{params}"
    logger.debug "message?: #{fb_params.message?}
delivery?: #{fb_params.delivery?}
postback?: #{fb_params.postback?}"
    if fb_params.message?

      Messenger::Client.send(
          Messenger::Request.new(
              Messenger::Elements::Text.new(text: "Your wrote #{fb_params.text_message}"),
              fb_params.sender_id
          )
      )
    end
    render nothing: true, status: 200
  end
end