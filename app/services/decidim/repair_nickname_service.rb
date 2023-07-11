# frozen_string_literal: true

module Decidim
  class RepairNicknameService
<<<<<<< HEAD
=======
    def initialize; end

>>>>>>> 784dfcc (Cleanup rake tasks (#288))
    def self.run
      new.execute
    end

    def execute
      return [] if ok?

      update_nicknames!
    end

    def ok?
<<<<<<< HEAD
      invalid_users.empty?
    end

    def invalid_users
      @invalid_users ||= Decidim::User.all.map do |user|
        new_nickname = valid_nickname_for(user)
        next if user.nickname == new_nickname

        [user, new_nickname]
      end.compact
=======
      users.blank?
>>>>>>> 784dfcc (Cleanup rake tasks (#288))
    end

    private

    # Update each users with new nickname
    # Returns Array of updated User ID
    def update_nicknames!
<<<<<<< HEAD
      invalid_users.map do |user, new_nickname|
        user.nickname = if Decidim::User.exists?(nickname: new_nickname)
                          "#{new_nickname}#{user.id}"
                        else
                          new_nickname
                        end
=======
      @users.map do |user|
        user.nickname = valid_nickname_for(user)
>>>>>>> 784dfcc (Cleanup rake tasks (#288))

        user.id if user.save!
      end.compact
    end

    # Remove invalid chars from nickname and concatenate unique ID of user
    def valid_nickname_for(user)
<<<<<<< HEAD
      I18n.locale = user.locale
      I18n.transliterate(user.nickname).codepoints.map { |ascii_code| ascii_to_valid_char(ascii_code) }.join
=======
      sanitized = user.nickname.codepoints.map { |ascii_code| ascii_to_valid_char(ascii_code) }.join

      "#{sanitized}#{user.id}"
    end

    # Find users with nicknames containing invalid chars
    def users
      @users ||= Decidim::User.where.not("nickname ~* ?", "^[\\w-]+$")
>>>>>>> 784dfcc (Cleanup rake tasks (#288))
    end

    # Check for a given ascii code if it is included in valid_ascii_code list
    # If true
    #   Returns the corresponding char
    # Else returns nil
    def ascii_to_valid_char(id)
      letters = ("A".."Z").to_a.join("").codepoints
      letters += ("a".."z").to_a.join("").codepoints
      digits = ("0".."9").to_a.join("").codepoints
      special_chars = %w(- _).join("").codepoints

      valid_ascii_code = letters + digits + special_chars

      id.chr if valid_ascii_code.include?(id)
    end
  end
end
