###### ----- ######

import matplotlib.pyplot as plt
import numpy as np
import matplotlib.pyplot as plt
import string

###### ROBOT ######

import stretch_body.robot
from stretch_body.hello_utils import *
import time


###### ----- ######

# Setup the Python API
robot = stretch_body.robot.Robot()
if not robot.startup():
    print("Failed to open connection to the robot")

# Ensure robot is homed
if not robot.is_calibrated():
    robot.home()

robot.stow()

# import json
# data = robot.status
# with open("data_sensors/output.json", "w") as outfile:
#     json.dump(data, outfile, indent=2)

print(robot.base.status)
print("--------------------------")
print(robot.pimu.status)