#!/bin/bash
w1=$(i3-msg -rt get_workspaces | jq -r '.[]|select(.focused).name')
i3-msg "rename workspace ${w1} to ${w1}_temp__"
i3-msg "rename workspace ${1} to ${w1}"
i3-msg "rename workspace ${w1}_temp__ to ${1}"
