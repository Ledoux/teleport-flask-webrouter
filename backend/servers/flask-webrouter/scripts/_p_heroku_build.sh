if [[ ! $(heroku apps:info -a $[run.tag]) ]]; then
  git init
  heroku create --app $[run.tag] --buildpack heroku/python --remote $[type.name]
  heroku config:set --app $[run.tag] TYPE=$[type.name]
else
  echo "$[run.tag] has been already created"
fi
