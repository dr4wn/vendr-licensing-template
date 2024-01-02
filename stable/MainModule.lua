local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local GroupService = game:GetService("GroupService")

local module = {}

local licenseUrl = "https://api.onpointrblx.com/vendr/v2/licences/getlicence/roblox/%s/%s/%s"
local whitelistActive = true
local developerDebug = false

local defaultRejection = {
	licenseInfo = {licensed = false}
}

function module.getLicense(arguments)
	if not whitelistActive then return {licenseInfo = {licensed = true}} end

	local place, hubId, productName = unpack(arguments)

	if not (place and hubId and productName) then return defaultRejection end
	assert(type(place) == "number", "\"place\" was not a number")
	assert(type(hubId) == "number", "\"hubId\" was not a number")
	assert(type(productName) == "string", "\"productName\" was not a string")

	local placeInfo = MarketplaceService:GetProductInfo(place)
	local playerId = nil

	if placeInfo.Creator.CreatorType == "Group" then
		playerId = GroupService:GetGroupInfoAsync(placeInfo.Creator.CreatorTargetId).Owner.Id
	else
		playerId = placeInfo.Creator.Id
	end

	if not playerId then
		return defaultRejection
	end

	local formattedUrl = string.format(licenseUrl, playerId, hubId, productName)
	local response = HttpService:RequestAsync({ Url = formattedUrl, Method = "GET" })

	if developerDebug then
		local decodedBody = HttpService:JSONDecode(response.Body)
		for index, value in pairs(decodedBody) do
			warn("["..tostring(index).."]", value)
		end
	end

	return {
		licenseInfo = {
			licensed = response.Success == true
		}
	}
end

return module
