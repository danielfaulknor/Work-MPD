#!/usr/bin/env php
<?
while(1) {
	$status = shell_exec("mpc | grep playing");
	if (!is_null($status)) {

		echo date("Y-m-d H:i:s") . " PLAYLIST MANAGER - Running loop\n";

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
		echo date("Y-m-d H:i:s") . " PLAYLIST MANAGER - Current song: $current";
		echo date("Y-m-d H:i:s") . " PLAYLIST MANAGER - Playlist Count: $count \n";
		echo date("Y-m-d H:i:s") . " PLAYLIST MANAGER - Playlist Position: $pos \n";
		echo date("Y-m-d H:i:s") . " PLAYLIST MANAGER - Songs Remaining: $remain \n";
		echo date("Y-m-d H:i:s") . " PLAYLIST MANAGER - Songs Played: $played \n";

		// If the current playing song is not at the top, delete everything above it
		if ($played > 0) {
			$i = 1;
			echo date("Y-m-d H:i:s") . " PLAYLIST MANAGER - Deleting " . $played . " songs\n";
			while ($i <= $played) {
				shell_exec("mpc del " . $i);
				$i++;
			}
		}

		// Pick PLAYLIST MANAGER songs and add them to the list if we're getting low
		// Expects a popular folder with top 40 hits in it to play every 2nd song to keep radio lovers happy :)
		if ($remain < 5) {
			echo date("Y-m-d H:i:s") . " PLAYLIST MANAGER - Time to add more songs!\n";
			shell_exec(dirname(__FILE__) . "/addsongs.sh");
			shell_exec(dirname(__FILE__) . "/shuffle.sh");
		}

		echo date("Y-m-d H:i:s") . " PLAYLIST MANAGER - Sleeping for 20s\n";
		echo "------------------------------------\n";
		sleep(20);
	}
	else {
		echo date("Y-m-d H:i:s") . " PLAYLIST MANAGER - Not playing\n";
		sleep(20);
	}
}
