--[[
	transferFrame.lua
		Overview frame of void storage transfers
--]]

local MODULE, Module =  ...
local ADDON, Addon = Module.ADDON, Module.Addon
local TransferFrame = Addon:NewClass('TransferFrame', 'Frame')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)

function TransferFrame:New(parent)
	local f = self:Bind(CreateFrame('Frame', nil, parent))
	local deposit = f:NewSection(DEPOSIT)
	deposit:SetPoint('TOPLEFT', 10, -20)

	local withdraw = f:NewSection(WITHDRAW)
	withdraw:SetPoint('TOPLEFT', deposit, 'BOTTOMLEFT', 0, -20)

	return f
end

function TransferFrame:NewSection(title)
	local frame = Addon.VaultItemFrame:New(self, {title})
	local text = frame:CreateFontString(nil, nil, 'GameFontHighlight')
	text:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT')
	text:SetText(title)

	return frame
end
