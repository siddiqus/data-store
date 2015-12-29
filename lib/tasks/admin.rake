require ::File.expand_path('../../../config/environment',  __FILE__)

namespace :admin do
  task :create_admin_account do
    admin_account = User.new(
                     :first_name =>     "Administrator",
                     :last_name =>      "Administrator",
                     :username =>       "admin",
                     :password =>       "password",
                     :email =>          "admin@gmail.com",
                     :approved =>       true,
                     :admin =>          true,
                     :agree_license =>  true)
    admin_account.save!
  end

  task :create_staff do
    admin_account = User.new(
                     :first_name =>     "Data",
                     :last_name =>      "Entry",
                     :username =>       "dataentry",
                     :password =>       "",
                     :email =>          "admin@live.com",
                     :staff_role =>     true,
                     :approved =>       true,
                     :admin =>          false,
                     :agree_license =>  true)
    admin_account.save!
  end
end
