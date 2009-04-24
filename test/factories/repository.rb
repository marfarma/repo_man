Factory.define :repository do |f|
  f.name "awesome"
  f.scm  "git"
  f.association :user, :factory => :email_confirmed_user
end
