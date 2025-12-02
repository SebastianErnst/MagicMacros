---@meta

--- Creates and overrides a txt file in gamedirectory\imports.
---@param filename string
---@param text string
function ExportFile(filename, text) end

--- Returns information about a spell id
---@param spellId integer
---@return string name
---@return string rank 
---@return string file
---@return integer minRangeToTarget 
---@return integer maxRangeToTarget 
function SpellInfo(spellId) end