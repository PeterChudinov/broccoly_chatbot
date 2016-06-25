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
        createButtonTemplate(
            'Select gender you identity with',
            'Female',
            'Male',
            'Neutral',
        )
      when 'Male', 'Female', 'Neutral'
        User.where(facebook_id: fb_params.sender_id).update_all(gender: value)
        createButtonTemplate(
            'Great. Now please select type of items are you looking for.',
            'Clothing',
            'Accessories',
            'Shoes',
            'All',
        )
        when 'Clothing', 'Accessories', 'Shoes', 'All'
          User.where(facebook_id: fb_params.sender_id).update_all(type: value)
          createButtonTemplate(
              'What about your aesthetics? Select the word that most matches your style',
              'Casual',
              'Formal',
              'Active',
              'Avant-Garde',
          )
        when 'Casual', 'Formal', 'Active', 'Avant-Garde'
          User.where(facebook_id: fb_params.sender_id).update_all(style: value)

      end
    end
    render nothing: true, status: 200
  end

  private

  def createButtonTemplate(name, *options)
    buttons = []
    options.each do |val|
      buttons.push(Messenger::Elements::Button.new(
          type: 'postback',
          title: val,
          value: val
      ))
    end

    Messenger::Client.send(
        Messenger::Request.new(Messenger::Templates::Buttons.new(
            text: name,
            buttons: buttons,
        ), fb_params.sender_id)
    )
  end
end