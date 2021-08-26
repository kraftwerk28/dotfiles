{
	lines = lines "\\n" $0
}

/^Core / {
	cpu_cnt++
	gsub(/[^.0-9]+/, "", $3)
	cpu_sum += $3
}

END {
	cpu_avg = cpu_sum / cpu_cnt
	fmt = "{\"text\": \" %.0f°C\", \"tooltip\": \"%s\"}\n"
	printf fmt, cpu_avg, lines
}
