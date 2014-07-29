#!/usr/bin/env bash
mpc listall | grep -v 'Popular/' |  shuf -n 375 | mpc add
mpc listall | grep 'Popular/' |  shuf -n 125 | mpc add
