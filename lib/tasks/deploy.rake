task :deploy do

  Dir['public/stylesheets/**/*.scss'].each do |sass|
    basename = sass.gsub(/public\/stylesheets\/sass\//, '').gsub(/\.scss$/, '')
    next if basename.match(/^_/)   # skip includes
    css = "public/stylesheets/#{basename}.css"
    puts "Compiling #{sass} -> #{css}"
    system "sass #{sass} #{css}"
    system "git add #{css}"
  end

  `jammit`
  raise unless $SERVER
  `git push #{$SERVER}`
end

task :staging do
  $SERVER="staging"
end

task :production do
  $SERVER="heroku master"
end
