--- Test module
--
-- This just a test module
-- @ext mvp.test
local MODULE = MODULE


MODULE:SetName('Test module')

function MODULE:OnLoaded()
    
end

--- Test function
-- @realm shared
function MODULE:Test()
    
end

MODULE:Hook('Think', function(self)

end)