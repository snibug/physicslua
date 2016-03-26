NaiveBroadPhase = class('NaiveBroadPhase', BroadPhase)

function NaiveBroadPhase:initialize()
  BroadPhase.initialize(self, BroadPhase.NAIVE)
end

function NaiveBroadPhase.get_collision_pairs(world)
  local result = {}
  for i = 1, #world.bodies do
    local ith = world.bodies[i]
    for j = 1, i - 1 do
      local jth = world.bodies[j]
      if BroadPhase.can_collide(ith, jth) and
         BroadPhase.bounding_volume_check(ith, jth) then
        table.insert(result, {ith, jth})
      end
    end
  end
  return result
end

function NaiveBroadPhase.aabb_query(world, aabb, result)
  result = result or {}
  for i = 1, #world.bodies do
    local body = world.bodies[i]
    if body.aabb_need_update then
      body:update_aabb()
    end

    if a.aabb:overlaps(aabb) then
      table.insert(result, body)
    end
  end

  return result
end
