if [[ ! $(heroku apps:info -a $[run.subDomain]) ]]; then
  git init
  heroku create --app $[run.subDomain] --buildpack heroku/python --remote $[type.name]
  heroku config:set --app $[run.subDomain] TYPE=$[type.name]
else
  echo "$[run.subDomain] has been already created"
fi
