local helpers = {
    version = "1";
    link = "https://raw.githubusercontent.com/superyor/helpers/master/helpers.lua";
    versionLink = "https://raw.githubusercontent.com/superyor/helpers/master/version.txt";
    b64charset="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
};

function helpers.b64encode(data)
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return helpers.b64charset:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

function helpers.b64decode(data)
    data = string.gsub(data, '[^'..helpers.b64charset..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(helpers.b64charset:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
    end))
end

function helpers.DecimalToHex(decimalNum)
    local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
    while decimalNum>0 do
        I=I+1
        decimalNum,D=math.floor(decimalNum/B),math.mod(decimalNum,B)+1
        OUT=string.sub(K,D,D)..OUT
    end
    return OUT
end

function helpers.StringToHex(string)
    local output = "";

    for letter in string.gmatch(string, "%a") do
        output = output .. string.format('%02X',string.byte(letter))
    end

    return output;
end

local function updateCheck()
    if helpers.version ~= http.Get(helpers.versionLink) then
        local scriptName = GetScriptName()
        local script = file.Open("Modules\\Superyu\\helpers.lua", "w");
        newScript = http.Get(helpers.link)
        script:Write(newScript);
        script:Close()
        return false;
    else
        return true;
    end
end

if updateCheck() then
    return helpers;
else
    return "Updated";
end