--[[
	item.lua
		A void storage item slot button
--]]

local Bagnon = LibStub('AceAddon-3.0'):GetAddon('Bagnon')
local ItemSlot = Bagnon:NewClass('VaultSlot', 'Button', Bagnon.ItemSlot)
ItemSlot.nextID = 0
ItemSlot.unused = {}


--[[ Constructor ]]--

function ItemSlot:Create()
	local item = Bagnon.ItemSlot.Create(self)
	item:SetScript('OnReceiveDrag', self.OnReceiveDrag)
	item:SetScript('OnDragStart', self.OnDragStart)
	item:SetScript('OnClick', self.OnClick)
	item:RegisterForDrag('LeftButton')
	item:RegisterForClicks('anyUp')
	return item
end

function ItemSlot:SetFrame(parent, bag, slot)
	self:SetParent(parent)
	self:SetID(slot)
	self.bag = bag
end

function ItemSlot:ConstructNewItemSlot(id)
	return CreateFrame('Button', 'BagnonVaultItemSlot' .. id, nil, 'ContainerFrameItemButtonTemplate')
end

function ItemSlot:CanReuseBlizzardBagSlots()
	return nil
end


--[[ Frame Events ]]--

function ItemSlot:OnClick (button)
	if IsModifiedClick() then
		local link = self:GetItem()
		if link then
			HandleModifiedItemClick(link)
		end
	elseif self.bag == 'vault' then
		local isRight = button == 'RightButton'
		
		if isRight and self:IsLocked() then
			ClickVoidTransferWithdrawalSlot(self.withdrawSlot, true)
		else
			ClickVoidStorageSlot(self:GetID(), isRight)
			self.withdrawSlot = GetNumVoidTransferWithdrawal()
		end
	end
end

function ItemSlot:OnDragStart()
	self:OnClick('LeftButton')
end

function ItemSlot:OnEnter()
	local link = self:GetItem()
	if link then
		self:AnchorTooltip()
		
		if self.bag == 'vault' then
			GameTooltip:SetVoidItem(self:GetID())
		elseif self.bag then
			GameTooltip:SetVoidDepositItem(self:GetID())
		else
			GameTooltip:SetVoidWithdrawalItem(self:GetID())
		end

		if IsModifiedClick('DRESSUP') then
			ShowInspectCursor()
		else
			ResetCursor()
		end
	else
		GameTooltip:Hide()
		ResetCursor()
	end
end


--[[ Fake Methods ]]--

function ItemSlot:UpdateSlotColor() end
function ItemSlot:UpdateCooldown() end


--[[ Proprieties ]]--

function ItemSlot:IsCached()
	-- delicious hack: behave as cached (disable interaction) while vault has not been purchased
	return not CanUseVoidStorage() or select(6, Bagnon.ItemSlot.GetInfo(self))
end

function ItemSlot:IsQuestItem()
	return false
end

function ItemSlot:GetInfo()
	local id, icon, locked = self:RequestInfo()
	local link, quality
	
	if id then
		link, quality = select(2, GetItemInfo(id))
	end
	
	return icon, 1, locked, quality, nil, nil, link
end

function ItemSlot:RequestInfo()
	if self.bag == 'vault' then
		return Bagnon.ItemSlot.GetInfo(self)
	elseif self.bag then
		return GetVoidTransferDepositInfo(self:GetID())
	else
		return GetVoidTransferWithdrawalInfo(self:GetID())
	end
end

function ItemSlot:GetBag()
	return 'vault'
end