class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    if session[:user_id]
      return @current_user ||= User.find(session[:user_id])
    end
  end

  def authorize
    if !current_user
      flash[:alert] = "You need to sign in."
      redirect_to '/'
    end
  end

  def authorize_conversation(user, conversation)
    if current_user.id != conversation.user1_id && current_user.id != conversation.user2_id
      flash[:alert] = 'You are not authorized to access that feature.'
      redirect_to '/'
    end
  end

  def encode_message(message, key)
    if key > 26 || key < 1
      return 'I told you not to do that'
    end
    alphabet = ('a'..'z').to_a
    alphabet_slice_first = alphabet.slice(key..-1)
    alphabet_slice_last = alphabet.slice(0..(key-1))
    encoded_alphabet = alphabet_slice_first + alphabet_slice_last
    message_array = message.downcase.split('')
    coded_message_array = []
    message_array.each do |char|
      if alphabet.include?(char)
        new_char = encoded_alphabet[alphabet.find_index(char)]
        coded_message_array.push(new_char)
      else
        coded_message_array.push(char)
      end
    end
    encoded_message = coded_message_array.join
  end

  def decode_message(message, key)
    if key > 26 || key < 1
      return 'I told you not to do that'
    end
    alphabet = ('a'..'z').to_a
    alphabet_slice_first = alphabet.slice(key..-1)
    alphabet_slice_last = alphabet.slice(0..(key-1))
    encoded_alphabet = alphabet_slice_first + alphabet_slice_last
    encoded_message_array = message.split('')
    decoded_message_array = []
    encoded_message_array.each do |char|
      if encoded_alphabet.include?(char)
        new_char = alphabet[encoded_alphabet.find_index(char)]
        decoded_message_array.push(new_char)
      else
        decoded_message_array.push(char)
      end
    end
    decoded_message = decoded_message_array.join
  end

end
