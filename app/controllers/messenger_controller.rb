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
    elsif fb_params.postback?
      if fb_params.send(:messaging_entry)['postback']['payload'] == 'lets starts'
        buttons = Messenger::Templates::Buttons.new(
          text: 'Select gender you identity with',
          buttons: [
            Messenger::Elements::Button.new(
              type: 'postback',
              title: 'Female',
              value: 'female'
            ),
            Messenger::Elements::Button.new(
              type: 'postback',
              title: 'Male',
              value: 'male'
            ),
            Messenger::Elements::Button.new(
              type: 'postback',
              title: 'Neutral',
              value: 'neutral'
            ),
          ]
        )
        Messenger::Client.send(
            Messenger::Request.new(buttons, fb_params.sender_id)
        )
      end
    end
    render nothing: true, status: 200
  end
end