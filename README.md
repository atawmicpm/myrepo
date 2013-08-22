details
======

I used this project to better familiarize myself with chef.  Previous
to this my experience with chef was a simple deploy using their online
tutorial.  I'm using a public 'rvm' cookbook to install rvm, sinatra,
and rails (used for parsing date).  webapp.rb is where all the host
specific configuration happens.  I created an upstart config for the
webapp so it starts on boot and respawns if the process dies.  I output
the sinatra output to a log and parse it every 5 minutes using cron.
It all gets created using templates, but I kept parser.rb in the root of
this project so it is easier to find.

Assumptions:
	-Vagrant 1.2.7
	-precise32 box

Files created:
	Vagrantfile
	parser.rb
	cookbooks/rvm/recipes/sinatra.rb
	cookbooks/pagerduty/apt.rb
	cookbooks/pagerduty/webapp.rb
	cookbooks/pagerduty/templates/default/*
