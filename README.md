= MPD controller =
== Requirements ==
 * MPD
 * replaygain
 * rsync
 * A folder full of music
 * A couple more folders for "Popular" - see below

== Setup ==
Configure your path in config.ini and the run the runner!

=== Popular system ===
You need to have 3 folders inside your music folder: Popular, zPopularProcessing and zPopularSource
You also need to put a .mpdignore file in the last two, with an asterisk inside the file

=== Phone call system ===
If you have a way to get an "On" or "Off" from your phone system when people in the area are on the phone you can use this to turn the volume down.
Just add a URL to the config file and the script will check the file every 3 seconds for an "On" or an "Off". You can also set the volume it turns it down to in the config file.
We assume you have alsamixer at 100% and use both your physical volume control and the built in MPD volume control.

=== Replaygain ===
You will need to turn replaygain on in mpd.conf and then use our run script to add the appropriate tags
