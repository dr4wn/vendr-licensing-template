-- Written by @draaawn & @Venturo1

local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local GroupService = game:GetService("GroupService")

local module = {}

local statusLink = "https://webserver.com/choice/%s" -- NOT an actual link! or maybe it is.. i don't know.
local licenseUrl = "https://api.onpointrblx.com/vendr/v2/licences/getlicence/roblox/%s/%s/%s" -- %s placeId, %s hubId, %s productName

local whitelistActive = true
local debugging = false

local modalDetails = {
	presetModals = {
		["httpRequestsError"] = {
			title = "Can't check if you own this product.",
			message = "",
			hint = "",
			icon = "alert",
			closable = false,
			footerText = nil,
			footerLink = nil
		},
		["unlicensed"] = {
			title = "You do not own this product.",
			message = ".",
			hint = "",
			icon = "alert",
			closable = false,
			footerText = nil,
			footerLink = nil
		},
		["error"] = {
			title = "",
			message = "",
			hint = "",
			icon = "",
			closable = false,
			footerText = "",
			footerLink = ""
		}
	},
	iconTranslations = {
		alert = "rbxassetid://",
		error = "rbxassetid://",
		security = "rbxassetid://"
	}
}

local defaultRejection = { licenseInfo = {licensed = false, showModal = false}, modalInfo = generateModalDetails(false, nil, "error") }

function generateModalDetails(custom, arguments, selectedModal)
	assert(custom ~= nil, "\"custom\" was not present.")
	assert(arguments ~= nil, "\"arguments\" was not present.")
	assert(selectedModal ~= nil, "\"selectedModal\" was not present.")

	if custom then
		return {
			title = arguments.title or "n/a",
			message = arguments.message or "n/a",
			hint = arguments.hint or "n/a",
			closable = arguments.closable or false,
			icon = arguments.icon or "warning",
			footerText =  arguments.footerText ~= nil and arguments.footerText or "default",
			footerLink = arguments.footerLink ~= nil and arguments.footerLink or "default",
		}
	else
		if not modalDetails["presetModals"][selectedModal] then
			return modalDetails["presetModals"]["error"]
		end

		return modalDetails["presetModals"][selectedModal]
	end
end


function module.getLicense(arguments)
	if not whitelistActive then return {licensed = true}, nil end

	local place, hubId, productName = unpack(arguments)
	local placeInfo = MarketplaceService:GetProductInfo(place)
	local playerId = nil

	if not place or hubId or productName then return defaultRejection end
	assert(type(place) == "number", "\"place\" was not a number")
	assert(type(hubId) == "number", "\"hubId\" was not a number")
	assert(type(productName) == "string", "\"productName\" was not a string")

	if placeInfo.Creator.CreatorType == "Group" then
		playerId = GroupService:GetGroupInfoAsync(placeInfo.Creator.CreatorTargetId).Owner.Id
	else
		playerId = placeInfo.Creator.Id
	end

	if not playerId then
		return {
			licenseInfo = {licensed = false, showModal = false},
			modalInfo = generateModalDetails(false, nil, "error")
		}
	end

	local function getStatus()
		local requestInformation
		local success = pcall(function()
			local formattedStatusLink = statusLink:format(string.lower(productName))
			requestInformation = HttpService:GetAsync(formattedStatusLink)
		end)
		if success then
			return success, HttpService:JSONDecode(requestInformation)
		else
			return success, nil
		end
	end

	local success, modalInfo = getStatus()

	if not success then
		return {
			licenseInfo = {licensed = false, showModal = true},
			modalInfo = generateModalDetails(false, nil, "httpRequestsError")
		}
	end

	local allInfo

	if modalInfo.ModalEnabled then
		allInfo = {
			licenseInfo = {},
			modalInfo = generateModalDetails(true, {
					title = modalInfo.Title,
					message = modalInfo.Message,
					hint = modalInfo.Hint,
					closable = modalInfo.ClosingModal,
					icon = modalInfo.Icon,
					footerLink = modalInfo.FooterLink,
					footerText = modalInfo.FooterText
			}, nil)
		}
		if not modalInfo.ClosingModal then
			allInfo["licenseInfo"] = {licensed = false, showModal = true}
		else
			allInfo["licenseInfo"] = {licensed = true, showModal = true}
		end
	else
		allInfo = { licenseInfo = {licensed = true, showModal = false} }
	end

	local formattedUrl = (licenseUrl):format(playerId, hubId, productName)
	local response = HttpService:RequestAsync({ Url = formattedUrl, Method = "GET" })
	local doesUserOwnLicense = response.Success == true

	if debugging then
		local decodedBody = HttpService:JSONDecode(response.Body)
		for index, value in decodedBody do
			warn("["..tostring(index).."]", value)
		end
	end

	if not doesUserOwnLicense then
		return {
			licenseInfo = {licensed = false, showModal = true},
			modalInfo = generateModalDetails(false, nil, "unlicensed")
		}
	end

	return allInfo
end

return module