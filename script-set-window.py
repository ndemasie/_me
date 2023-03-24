import subprocess

# Get the desktop bounds
desktop_bounds = subprocess.check_output(['osascript', '-e', 'tell application "Finder" to get bounds of window of desktop'])

# Parse the bounds into separate variables
desktop_left_width_offset, \
desktop_left_height_offset, \
desktop_right_width_offset, \
desktop_right_height_offset \
  = map(int, desktop_bounds.decode().strip().split(","))

# Get the frontmost process
app = subprocess \
  .check_output(['osascript', '-e', 'tell application "System Events" to get name of first process whose frontmost is true']) \
  .decode() \
  .rstrip()

menu = subprocess \
    .check_output(['osascript', '-e', f'tell application "System Events" to tell process "{app}" to get size of menu bar 1']) \
    .decode() \
    .strip() \
    .split(",")

menu_height = int(menu[1])
width_offset = 100

position_x = desktop_left_width_offset
position_y = desktop_left_height_offset
size_width = -desktop_left_width_offset - width_offset
size_height = desktop_right_height_offset - menu_height

# Set window
subprocess.run(['osascript', '-e', f'tell application "{app}" to tell front window to set {{position, size}} to {{ {{{position_x}, {position_y}}}, {{{size_width}, {size_height}}}}}'])
