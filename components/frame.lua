--[[
	frame.lua
		A specialized version of the bagnon frame for void storage
--]]

local MODULE, Module =  ...
local ADDON, Addon = Module.ADDON, Module.Addon
local Frame = Addon:NewClass('VaultFrame', 'Frame', Addon.Frame)

Frame.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).Title
Frame.ItemFrame = Addon.VaultItemFrame
Frame.MoneyFrame = Addon.TransferButton
Frame.Bags = {'vault'}

Frame.OpenSound = 'UI_EtherealWindow_Open'
Frame.CloseSound = 'UI_EtherealWindow_Close'
Frame.BrokerSpacing = 4


--[[ Events ]]--

function Frame:OnShow()
	Addon.Frame.OnShow(self)
	self:RegisterFrameEvent('SHOW_TRANSFER', 'ShowTransfer')
end

function Frame:OnHide()
	Addon.Frame.OnHide(self)
	self:CloseTransfer()

	StaticPopup_Hide(ADDON .. 'CANNOT_PURCHASE_VAULT')
	StaticPopup_Hide(ADDON .. 'VAULT_PURCHASE')
	StaticPopup_Hide('VOID_DEPOSIT_CONFIRM')
	CloseVoidStorageFrame()
end


--[[ Components ]]--

function Frame:ShowTransfer()
	Addon:FadeSwitch(self.itemFrame, self:GetTransferFrame())
	StaticPopup_Show(ADDON .. 'COMFIRM_TRANSFER').data = self
end

function Frame:CloseTransfer()
	Addon:FadeSwitch(self.transferFrame, self.itemFrame)
	StaticPopup_Hide(ADDON .. 'COMFIRM_TRANSFER')
end

function Frame:GetTransferFrame()
	return self.transferFrame or self:CreateTransferFrame()
end

function Frame:CreateTransferFrame()
	local frame = Addon.TransferFrame:New(self)
	frame:SetAllPoints(self.itemFrame)
	self.transferFrame = frame
	return frame
end

function Frame:GetSpecialButtons() end
function Frame:HasMoneyFrame()
	return true
end

function Frame:HasBagFrame()
	return false
end
