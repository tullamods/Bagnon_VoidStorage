--[[
	itemFrame.lua
		A void storage item frame. Three kinds:
			nil -> deposited items
			DEPOSIT -> items to deposit
			WITHDRAW -> items to withdraw
--]]

local MODULE, Module =  ...
local Addon = Module.Addon
local ItemFrame = Addon:NewClass('VaultItemFrame', 'Button', Addon.ItemFrame)
ItemFrame.Button = Addon.VaultSlot
ItemFrame.Transposed = true

function ItemFrame:RegisterEvents()
	self:UnregisterEvents()
	self:RegisterFrameMessage('PLAYER_CHANGED', 'Update')
	self:RegisterMessage('UPDATE_ALL', 'RequestLayout')

	if self:IsCached() then
		self:RegisterEvent('VOID_STORAGE_OPEN', 'RegisterEvents')
	else
		if self:Type() == DEPOSIT then
			self:RegisterEvent('VOID_STORAGE_DEPOSIT_UPDATE', 'RequestLayout')
		elseif self:Type() == WITHDRAW then
			self:RegisterEvent('VOID_STORAGE_CONTENTS_UPDATE', 'RequestLayout')
		else
			self:RegisterEvent('VOID_STORAGE_CONTENTS_UPDATE', 'ForAll', 'Update')
			self:RegisterEvent('VOID_STORAGE_UPDATE', 'ForAll', 'Update')
			self:RegisterEvent('VOID_TRANSFER_DONE', 'ForAll', 'Update')
		end
	end
end

function ItemFrame:NumSlots()
	if self:Type() == DEPOSIT then
		return GetNumVoidTransferDeposit()
	elseif self:Type() == WITHDRAW then
		return GetNumVoidTransferWithdrawal()
	else
		return 80 * 2
	end
end

function ItemFrame:Type()
	return self.bags[1]
end
