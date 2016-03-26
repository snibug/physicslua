
AABB = class('AABB')

function AABB:initialize(options)
  options = options or {}
  self.lower_bound = (options.lower_bound and
                      vec2.clone(options.lower_bound) or
                      vec2.create())

  self.upper_bound = (options.upper_bound and
                      vec2.clone(options.upper_bound) or
                      vec2.create())
end

function AABB:set_from_point(points, position, angle, skin_size)
  local lower = self.lower_bound
  local upper = self.upper_bound

  if angle ~= 0 then
    vec2.rotate(lower, points[1], angle)
  else
    vec2.copy(lower, points[1])
  end
  vec2.copy(upper, lower)

  local cos_angle = math.cos(angle)
  local sin_angle = math.sin(angle)
  for i = 2, #point do
    local point = points[i]
    local x, y = points[i][1], points[i][2]
    if angle ~= 0 then
      points[i][1] = cos_angle * x - sin_angle * y
      points[i][2] = sin_angle * x + cos_angle * y
    end

    for j = 1, 2 do
      upper[j] = math.max(upper[j], point[j])
      lower[j] = math.min(lower[j], point[j])
    end
  end

  if position then
    vec2.add(lower, lower, position)
    vec2.add(upper, upper, position)
  end

  if skin_size then
    lower[1] = lower[1] - skin_size
    lower[2] = lower[2] - skin_size
    upper[1] = upper[1] + skin_size
    upper[2] = upper[2] + skin_size
  end
end

function AABB:copy(other)
  vec2.copy(self.lower_bound, other.lower_bound)
  vec2.copy(self.upper_bound, other.upper_bound)
end

function AABB:extend(other)
  for i = 1, 2 do
    self.upper_bound[i] = math.max(self.upper_bound[i], other.upper_bound[i])
    self.lower_bound[i] = math.min(self.lower_bound[i], other.lower_bound[i])
  end
end

function AABB:overlaps(other)
  local l1 = self.lower_bound
  local u1 = self.upper_bound
  local l2 = other.lower_bound
  local u2 = other.upper_bound

  return ((l2[1] <= u1[1] and u1[1] <= u2[1]) or
          (l1[1] <= u2[1] and u2[1] <= u1[1])) and
         ((l2[2] <= u1[2] and u1[2] <= u2[2]) or
          (l1[2] <= u2[2] and u2[2] <= u1[2]))
end

function AABB:contains_point(point)
  local lower = self.lower_bound
  local upper = self.upper_bound

  return (lower[1] <= point[1] and
          point[1] <= upper[1] and
          lower[2] <= point[2] and
          point[2] <= upper[2])
end

function AABB:overlaps_ray(ray)
  local dir_frac_x = 1 / ray.direction[1]
  local dir_frac_y = 1 / ray.direction[2]

  local from = ray.from
  local upper_bound = self.upper_bound
  local lower_bound = self.lower_bound
  local t1 = (lower_bound[1] - from[1]) * dir_frac_x
  local t2 = (upper_bound[1] - from[1]) * dir_frac_x
  local t3 = (lower_bound[2] - from[2]) * dir_frac_y
  local t4 = (upper_bound[2] - from[2]) * dir_frac_y

  local tmin = math.max(math.max(math.min(t1, t2), math.min(t3, t4)))
  local tmax = math.min(math.min(math.max(t1, t2), math.max(t3, t4)))

  if tmax < 0 then
    return -1
  end

  if tmin > tmax then
    return -1
  end

  return tmin
end
