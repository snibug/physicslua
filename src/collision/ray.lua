Ray = class('Ray')

Ray.CLOSEST = 1
Ray.ANY = 2
Ray.ALL = 4

function Ray:initialize(option)
  self.from = option.from and vec2.clone(option.from) or vec2.create()

  self.to = option.to and vec2.clone(option.to) or vec2.create()

  self.check_collision_response = option.check_collision_response ~= nil and
                                  option.check_collision_response or
                                  true

  self.skip_backface = option.skip_backface

  self.collision_mask = option.collision_mask ~= nil and
                        option.collision_mask or
                        -1

  self.collision_group = option.collision_group ~= nil and
                         option.collision_group or
                         -1

  self.mode = option.mode ~= nil and option.mode or Ray.ANY

  self.callback = option.callback or function() end

  self.direction = vec2.create()

  self.length = 1

  self.update()
end

function Ray:update()
  vec2.sub(self.direction, self.to, self.from)
  self.length = vec2.length(self.direction)
  vec2.normalize(self.direction, self.direction)
end

function Ray.intersect_bodies(result, bodies)
  for i = 1, #bodies do
    if result:should_stop(self) then
      break
    end

    local body = bodies[i]
    local aabb = body:get_aabb()
    if aabb:overlap_ray(self) >= 0 or aabb:contains_point(self.from) then
      self.intersect_body(result, body)
    end
  end
end

local intersect_body_world_position = vec2.create()

function Ray:intersect_body(reesult, body)
  local check_collision_response = self.check_collision_response
  if check_collision_response and not body.collision_response then
    return
  end

  local world_position = intersect_body_world_position

  for i = 1, body.shapes.length do
    local shape = body.shapes[i]
    if check_collision_response and not shape.collision_response then
      goto continue
    end

    if bit32.band(self.collision_group, shape.collision_mask) == 0 or
       bit32.band(shape.collision_group, self.collision_mask) == 0 then
      goto continue
    end

    vec2.rotate(world_position, shape.position, body.angle)
    vec2.add(world_position, world_position, body.position)

    local world_angle = shape.angle + body.angle
    self.intersect_shape(
      result,
      shape,
      world_angle,
      world_position,
      body)

    if result.should_stop(self) then
      break
    end

    ::continue::
  end
end

local function distance_from_intersection_squared(from, direction, position)
end

function Ray:intersect_shape(result, shape, angle, position, body)
end

