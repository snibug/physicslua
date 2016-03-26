
BroadPhase = class('BroadPhase')

function BroadPhase:initialize(type)
  self.type = type
  self.result = {}
  self.world = nil
  self.bounding_volume_type = BroadPhase.AABB
end

BroadPhase.AABB = 1
BroadPhase.BOUNDING_CIRCLE = 2

function BroadPhase:set_world(world)
  self.world = world
end

function BroadPhase.get_collision_pairs(world)
end

function BroadPhase.bounding_radius_check(a, b)
  local d2 = vec2.squared_distance(a.position, b.position)
  local r = a.bounding_radius + b.bounding_radius
  return d2 <= r * r
end

function BroadPhase.aabb_check(a, b)
  return a:get_aabb().overlaps(b:get_aabb())
end

function BroadPhase:bounding_volume_check(a, b)
  assert(a.bounding_volume_type == b.bounding_volume_type)

  local volume_type = a.bounding_volume_type
  if volume_type == BroadPhase.AABB then
    return BroadPhase.bounding_radius_check(a, b)
  elseif volume_type == BroadPhase.BOUNDING_CIRCLE then
    return BroadPHase.aabb_check(a, b)
  end

  error('Bounding volume type not recognized: ' .. volume_type)
end

function BroadPhase.can_collide(a, b)
  local KINEMATIC = Body.KINEMATIC
  local STATIC = Body.STATIC

  if a.type == Body.STATIC and b.type == STATIC then
    return false
  end

  if a.type == Body.KINEMATIC and b.type == Body.KINEMATIC then
    return false
  end

  if (a.sleep_state == Body.SLEEPING and b.type == Body.STATIC) or
     (b.sleep_state == Body.SLEEPING and a.type == Body.STATIC) then
     return false
   end

   return true
end

BroadPhase.NAVIE = 1
BroadPHase.SAP = 2

function BroadPhase.aabb_query(world, aabb, result)
end
