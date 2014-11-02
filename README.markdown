# sinatra users webservice
The sinatra users websevice provides users related services.

## set up
Publish new code
``
git add --all . && git commit -m ".." && git push origin master && git push openshift master
``
Make sure RAILS_ENV is set to production
``
rhc env-list -a sinatrausers
``

## prepare db
``
rhc ssh sinatrausers
cd app-root/repo
bundle exec rake db:...
``

## how to start up
In order to start a webservice start the background service 
### local
``
bundle exec ruby -S rackup -w config.ru
``
### on openshift
``
bundle exec ruby -S rackup -w config.ru
``