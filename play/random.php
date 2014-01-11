#!/usr/bin/env php
<?
while(1) {
	echo "RANDOM - Running loop\n";

	// Get current playlist
	$playlist = explode("\n", shell_exec("mpc playlist"));

	// Dump the last playlist value because it's not a song
	array_pop($playlist);

	// Get number of songs in the playlist
	$count = count($playlist);

	// Get position of current song
	$current = shell_exec("mpc current");

	// Figure out the current playlist position
	foreach ($playlist as $key => $item) {
		if (trim($item)== trim($current)) $pos = $key;
	}

	// Figure out how many songs have been played and how many are left
	$remain = $count - $pos;
	$played = ($count - $remain);

	//Debugging info
	echo "RANDOM - Current song: $current";
	echo "RANDOM - Playlist Count: $count \n";
	echo "RANDOM - Playlist Position: $pos \n";
	echo "RANDOM - Songs Remaining: $remain \n";
	echo "RANDOM - Songs Played: $played \n";

	// If the current playing song is not at the top, delete everything above it
	if ($played > 0) {
		$i = 1;
		echo "RANDOM - Deleting " . $played . " songs\n";
		while ($i <= $played) {
			shell_exec("mpc del " . $i);
			$i++;
		}
	}

	// Pick random songs and add them to the list if we're getting low
	// Expects a popular folder with top 40 hits in it to play every 2nd song to keep radio lovers happy :)
	if ($remain < 5) {
	echo "RANDOM - Adding 2 random songs\n";
		shell_exec("mpc listall | grep -v 'Popular/' | shuf -n 1 | mpc add");
		shell_exec("mpc listall | grep 'Popular/' | shuf -n 1 | mpc add");
	}

	echo "RANDOM - Sleeping for 20s\n";
	sleep(20);
}
