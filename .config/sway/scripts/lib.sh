# shellcheck shell=bash
roundadd() {
	echo $(( $1 + $2 - ($1 % $2 ? ($1 % $2 + ($2 < 0 ? $2 : 0)) : 0) ))
}
