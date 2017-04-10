--[[
	transferButton.lua
		A void storage transfer button
--]]

local L = LibStub('AceLocale-3.0'):GetLocale('Bagnon-VoidStorage')
local TransferButton = Bagnon:NewClass('TransferButton', 'Button', Bagnon.MoneyFrame)


--[[ Constructor ]]--

function TransferButton:New (...)
	local f = Bagnon.MoneyFrame.New(self, ...)
	local b = CreateFrame('Button', nil, f, ADDON..'MenuCheckButtonTemplate')
	b.OnTooltip = f.OnTooltip
	b.Icon:SetTexture('Interface/Icons/ACHIEVEMENT_GUILDPERK_BARTERING')
	b:SetScript('OnClick', function() f:OnClick() end)
	b:SetPoint('RIGHT', - 3, 0)
	b:SetSize(30, 30)

	f.info, f.button = MoneyTypeInfo["STATIC"], b
	f:SetScript('OnHide', self.UnregisterEvents)
	f:SetScript('OnShow', self.RegisterEvents)
	f:SetHeight(36)
	f:Update()

	return f
end


--[[ Interaction ]]--

function TransferButton:OnClick ()
	if self:HasTransfer() then
		self:SendFrameMessage('SHOW_TRANSFER')
	end
end

function TransferButton:OnTooltip ()
	local withdraws = GetNumVoidTransferWithdrawal()
	local deposits = GetNumVoidTransferDeposit()

	if (withdraws + deposits) > 0 then
		GameTooltip:SetText(TRANSFER)

		if withdraws > 0 then
			GameTooltip:AddLine(format(L.NumWithdraw, withdraws), 1,1,1)
		end

		if deposits > 0 then
			GameTooltip:AddLine(format(L.NumDeposit, deposits), 1,1,1)
		end
	end
end


--[[ Update ]]--

function TransferButton:RegisterEvents()
	self:RegisterEvent('VOID_STORAGE_DEPOSIT_UPDATE', 'Update')
	self:RegisterEvent('VOID_STORAGE_CONTENTS_UPDATE', 'Update')
	self:RegisterEvent('VOID_TRANSFER_DONE', 'Update')
end

function TransferButton:Update()
	MoneyFrame_Update(self:GetName(), GetVoidTransferCost())

	local hasTransfer = self:HasTransfer()
	self.button:SetDesaturated(not hasTransfer)
	self.button:EnableMouse(hasTransfer)
end

function TransferButton:HasTransfer()
	return (GetNumVoidTransferWithdrawal() + GetNumVoidTransferDeposit()) > 0
end
