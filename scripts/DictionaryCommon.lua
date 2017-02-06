--local DictionaryCommon=class("DictionaryCommon",function()
--        return CCDictionary:create("DictionaryCommon");
--end)

dictionary={}

function dictionary.getGameStr(key)
     
     --if self:dictionary == nil then
     local dic = CCDictionary:createWithContentsOfFile("strings.xml")
     --end
    
     local str=dic:objectForKey(key):getCString();
     return str;
end

return dictionary

--return DictionaryCommon