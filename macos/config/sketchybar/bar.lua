local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  y_offset=10,
  padding_right=10,
  padding_left=10,
  margin=10,
  blur_radius=20,
  corner_radius=12,
  height = 40,
  color = colors.bar.bg,
  padding_right = 2,
  padding_left = 2,
})
