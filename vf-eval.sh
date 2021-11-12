#!/bin/bash
# Copyright 2021 Mobile Robotics Lab. at Skoltech
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -eo pipefail

CONFIG_PATH=$1
BAGS_PATH=$2
TRAJ_PATH=$3


source ../devel/setup.bash

# Launch roscore in background
roscore &
ros_proc=$!

BAGS_PATH=$(echo "$BAGS_PATH" | sed 's:/*$::')
BAGS="$BAGS_PATH/*"

# Loop by bag files
for BAG in $BAGS
do
    if [[ -f "$BAG" ]]
    then
        DATE=$(basename "$BAG" ".bag")

        # Run eval node
        rosrun vins vins_node "$CONFIG_PATH" &
        node_proc=$!

        # PLay bag file
        rosbag play "$BAG"

        kill "$node_proc"

        # Convert trajectory
        python3 traj_to_tum.py --date "$DATE" --traj_path "$TRAJ_PATH" --traj_file "vio.csv"
    fi
done



# Kill roscore running in background
kill "$ros_proc"