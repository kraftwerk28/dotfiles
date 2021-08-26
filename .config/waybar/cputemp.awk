{
	lines = lines "\\n" $0
}

/^Core / {
	cpu_cnt++
	gsub(/[^.0-9]+/, "", $3)
	cpu_sum += $3
}

/^fan/ {
	fan_cnt++
	fan_sum += $2
}

END {
	cpu_avg = cpu_sum / cpu_cnt
	fan_avg = fan_sum / fan_cnt
	gsub(/^\\n|\\n$/, "", lines)
	fmt = "{\"text\": \" %.0f°C  %.0f rpm\", \"tooltip\": \"%s\"}\n"
	printf fmt, cpu_avg, fan_avg, lines
}
