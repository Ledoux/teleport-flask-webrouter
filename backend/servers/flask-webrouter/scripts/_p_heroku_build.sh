if [[ ! $(heroku apps:info -a $(run.tag)) ]]; then
  git init && heroku create --app $(run.tag)
fi
