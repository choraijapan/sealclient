local BaseDB = class("BaseDB")

-- init
function BaseDB:init()
end

function BaseDB:open(path)
end

function BaseDB:close()
end

function BaseDB:simpleExec(query)
end

function BaseDB:find(...)
end

function BaseDB:findAll(...)
end

function BaseDB:orderBy(...)
end

function BaseDB:limit(...)
end

function BaseDB:delete(...)
end

function BaseDB:update(...)
end

return BaseDB