Body = class('Body')

function Body:initialize(options)
  options = options or {}
  EventEmitter.call(self)

  if options.id then
    self.id = options.id
  else
    self.id = Body.id_counter
    Body.id_counter = Body.id_count + 1
  end

  self.world = nil
  self.shapes = {}
  self.mass = options.mass or 0
end
