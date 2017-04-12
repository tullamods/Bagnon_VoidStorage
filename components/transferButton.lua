--[[
	transferButton.lua
		A void storage transfer button
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local TransferButton = Addon:NewClass('TransferButton', 'Button', Addon.MoneyFrame)
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)


--[[ Constructor ]]--

function TransferButton:New (...)
	local f = Addon.MoneyFrame.New(self, ...)
	local b = CreateFrame('Button', nil, f, ADDON..'MenuButtonTemplate')
	b.Icon:SetTexture('Interface/Icons/ACHIEVEMENT_GUILDPERK_BARTERING')
	b:SetScript('OnEnter', function() f:OnEnter() end)
	b:SetScript('OnLeave', function() f:OnLeave() end)
	b:SetScript('OnClick', function() f:OnClick() end)
	b:SetPoint('RIGHT', - 3, 0)
	b:SetSize(30, 30)

	f.Button, f.info = b, MoneyTypeInfo['STATIC']
	f:RegisterEvents()
	f:SetHeight(36)

	return f
end


--[[ Interaction ]]--

function TransferButton:OnClick ()
	if self:HasTransfer() then
		self:SendFrameMessage('SHOW_TRANSFER')
	end
end

function TransferButton:OnEnter ()
	local withdraws = GetNumVoidTransferWithdrawal()
	local deposits = GetNumVoidTransferDeposit()

	if (withdraws + deposits) > 0 then
		GameTooltip:SetOwner(self, self:GetRight() > (GetScreenWidth() / 2) and 'ANCHOR_LEFT' or 'ANCHOR_RIGHT')
		GameTooltip:SetText(TRANSFER)

		if withdraws > 0 then
			GameTooltip:AddLine(format(L.NumWithdraw, withdraws), 1,1,1)
		end

		if deposits > 0 then
			GameTooltip:AddLine(format(L.NumDeposit, deposits), 1,1,1)
		end

		GameTooltip:Show()
	end
end

function TransferButton:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end


--[[ Update ]]--

function TransferButton:RegisterEvents()
	self:RegisterEvent('VOID_STORAGE_DEPOSIT_UPDATE', 'Update')
	self:RegisterEvent('VOID_STORAGE_CONTENTS_UPDATE', 'Update')
	self:RegisterEvent('VOID_TRANSFER_DONE', 'Update')
	self:Update()
end

function TransferButton:Update()
	MoneyFrame_Update(self:GetName(), self:GetMoney())

	local hasTransfer = self:HasTransfer()
	self.Button.Icon:SetDesaturated(not hasTransfer)
	self.Button:EnableMouse(hasTransfer)
end

function TransferButton:HasTransfer()
	return (GetNumVoidTransferWithdrawal() + GetNumVoidTransferDeposit()) > 0
end

function TransferButton:GetMoney()
	return GetVoidTransferCost()
end
