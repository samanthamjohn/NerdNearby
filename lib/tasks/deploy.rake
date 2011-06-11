task :deploy do


  raise unless $SERVER
  `git push #{$SERVER}`
end

task :staging do
  $SERVER="staging master"
end

task :production do
  $SERVER="heroku master"
end
