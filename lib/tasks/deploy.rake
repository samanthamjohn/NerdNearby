task :deploy do


  if $SERVER
    `git push #{$SERVER}`
  else
    `git push && git push staging master && git push heroku master`
  end
end

task :staging do
  $SERVER="staging master"
end

task :production do
  $SERVER="heroku master"
end
