Warden::Manager.after_authentication do |user,auth,opts|

end

Warden::Manager.before_failure do |env, opts|
  request = Rack::Request.new(env)
  attempted_login_name = request.params[:user].try(:[], :username)
  attempted_login_name ||= 'unknown'
end

Warden::Manager.before_logout do |user,auth,opts|
  #this has a chance of getting called with a nil user, in which case we skip loggin
end
