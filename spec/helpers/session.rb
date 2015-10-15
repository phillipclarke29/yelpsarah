module SessionHelpers
  def sign_up(user)
     visit '/users/sign_up'
     fill_in :Email,                      with: user.email
     fill_in :user_password,              with: user.password
     fill_in :user_password_confirmation, with: user.password_confirmation
     click_button 'Sign up'
   end
end
