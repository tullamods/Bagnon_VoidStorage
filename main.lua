--[[
	main.lua
		The bagnon driver thingy
--]]

local MODULE, Module =  ...
Module.ADDON = MODULE:find('^(%w)_')
Module.Addon = _G[Module.ADDON]

local Addon = Module.Addon
local Vault = Bagnon:NewModule('VoidStorage', Addon)

function Vault:OnEnable()
	self:RegisterEvent('VOID_STORAGE_CLOSE', 'OnClose')
end

function Vault:OnOpen()
	if Addon:GetFrame('vault') then
		Addon:GetFrame('vault'):SetPlayer(nil)
	end

	IsVoidStorageReady()
	Addon.Cache.AtVault = true
	Addon:ShowFrame('vault')

	if not CanUseVoidStorage() then
		if Addon.VAULT_COST > GetMoney() then
			StaticPopup_Show('BAGNON_CANNOT_PURCHASE_VAULT')
		else
			StaticPopup_Show('BAGNON_VAULT_PURCHASE')
		end
	end
end

function Vault:OnClose()
	Addon.Cache.AtVault = nil
	Addon:HideFrame('vault')
end
