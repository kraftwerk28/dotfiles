#!/usr/bin/env bash
awk '
	/^Core / {
		cnt++
		gsub(/[^.0-9]+/, "", $3)
		s += $3
	}
	END {
		printf " %.0f°C\n", s/cnt
	}
' <(sensors)
