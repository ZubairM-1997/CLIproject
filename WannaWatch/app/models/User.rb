require 'digest'

class User < ActiveRecord::Base
    has_many :wannawatches
    has_many :movies, :through => :wannawatches

    def authenticate
        pw = $prompt.mask("Please enter your password.")
        if self.password_check(pw) == true
            $current_user = self
            small_break
            small_break
            main_menu
        else
            selection = $prompt.select("#{random_quotes_generator($errors)} Try again?", per_page: 10) do |option|
                option.choice 'Try again'
                option.choice 'Go back'
            end
        end
    end

    def password_check(pw)
        User.hash_password(pw) == self.password ? true : false
    end

    def self.hash_password(pw)
        encrypted_pw = Digest::SHA1.hexdigest(pw)
        return encrypted_pw
    end

    def add_a_watch 
    end 

    def return_watch_list 
    end 

end
    
