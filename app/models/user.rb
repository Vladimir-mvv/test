require 'digest/sha1'

class User < ActiveRecord::Base

  has_many :datafiles,  :dependent => :delete_all

  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken


 # validate :login_format
#
#  validates_presence_of     :login
#  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login, :message => "Login has already been taken. Choose another."
#  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

#  sexy validation swork only in Rails 3
#  validates :login, presence => true, uniqueness => true, length => { :minimum => 3, :maximum => 40} , format => Authentication.login_regex, :message => Authentication.bad_login_message


#  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
#  validates_length_of       :name,     :maximum => 100
#
#  validates_presence_of     :email
#  validates_length_of       :email,    :within => 6..100
  validates_uniqueness_of   :email, :message => "Email has already been taken"
#  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

 
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
private
 def login_format
    if self.login.blank?
      errors.add("login", "Login can't be empty! You must enter a login.") if login.blank?
      return false
    else
      if (self.login.length < 3 and self.login.length > 40)
#        if (self.login.length.within(3..40))
        errors.add("login", "Login must have from 3 to 40 symbols") if (self.login.length < 3 and self.login.length > 40)
        return false
      else
#        if !self.login.match(Authentication.login_regex)
#          errors.add(:login, Authentication.bad_login_message)
#          return false
#        end
      end


  end
 end
 def validate
    if self.login.blank?
      errors.add(:login, "Login can't be blank")
      return false
    else
      if (self.login.length<=3)||(self.login.length > 40)
        errors.add(:login, "Login should be in range 4..40")
        return false
      else
        if self.login.match(Authentication.login_regex)== nil
          errors.add(:login, Authentication.bad_login_message)
          return false
        else
          # if self.name.match(Authentication.name_regex)== nil
          # errors.add(:name, Authentication.bad_name_message)
          # return false
          # else
          # if (self.name.length > 100)
          # errors.add(:name, "Name should be less than 100 symbols")
          # return false
          # else
          if self.email.blank?
            errors.add(:email, "Email can't be blank")
            return false
          else
            if (self.email.length<6)||(self.email.length > 100)
              errors.add(:email, "Email should be in range 6..100")
              return false
            else
              if self.email.match(Authentication.email_regex)== nil
                errors.add(:email, "Email " + Authentication.bad_email_message)
                return false
              else
                if self.password.blank?
                  errors.add(:password, "Password can't be blank")
                  return false
                else
                  if self.password_confirmation.blank?
                    errors.add(:password, "Password can't be blank")
                    return false
                  end
                end
              end
            end
          end
        end
      end
    end
  end



  
end
