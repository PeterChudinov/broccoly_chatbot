class MessengerController < Messenger::MessengerController
  def webhook
    # logger.debug "params: #{params}"
    logger.debug "message?: #{fb_params.message?}
delivery?: #{fb_params.delivery?}
postback?: #{fb_params.postback?}"

    unless User.exists?(facebook_id: fb_params.sender_id)
      fb_data = JSON.parse(Messenger::Client.get_user_profile(fb_params.sender_id))
      User.create(
        facebook_id: fb_params.sender_id,
        first_name: fb_data['first_name'],
        last_name: fb_data['last_name']
      )

    end
    if fb_params.message?
      Messenger::Client.send(
          Messenger::Request.new(
              Messenger::Elements::Text.new(text: "Your wrote #{fb_params.text_message}"),
              fb_params.sender_id
          )
      )
    elsif fb_params.postback?
      value = fb_params.send(:messaging_entry)['postback']['payload']
      case value
      when 'lets starts'
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
        when 'male', 'female', 'neutral'
          User.where(facebook_id: fb_params.sender_id).update_all(gender: value)
      end
    end
    render nothing: true, status: 200
  end
end