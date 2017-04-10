--[[
	dialogs.lua
		Static dialog popups for the void storage window
--]]


local MODULE, Module =  ...
local ADDON, Addon = Module.ADDON, Module.Addon
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
Addon.VAULT_COST = 100 * 100 * 100

StaticPopupDialogs[ADDON .. 'VAULT_PURCHASE'] = {
	text = format(L.PurchaseDialog, GetCoinTextureString(Addon.VAULT_COST)),
	button1 = UNLOCK,
	button2 = NO,

	OnAccept = function(self)
		PlaySound('UI_Voidstorage_Unlock')
		UnlockVoidStorage()
	end,

	OnCancel = CloseVoidStorageFrame,
	timeout = 0, preferredIndex = STATICPOPUP_NUMDIALOGS,
	hideOnEscape = 1
}

StaticPopupDialogs[ADDON .. 'CANNOT_PURCHASE_VAULT'] = {
	text = format(L.CannotPurchaseDialog, GetCoinTextureString(Addon.VAULT_COST)),
	button1 = CHAT_LEAVE,
	button2 = L.AskMafia,

	OnAccept = CloseVoidStorageFrame,
	OnCancel = CloseVoidStorageFrame,
	timeout = 0, preferredIndex = STATICPOPUP_NUMDIALOGS,
	hideOnEscape = 1
}

StaticPopupDialogs[ADDON .. 'COMFIRM_TRANSFER'] = {
	text = L.ConfirmTransfer,
	button1 = YES,
	button2 = NO,

	OnAccept = function(dialog, frame)
		ExecuteVoidTransfer()
		frame:CloseTransfer()
	end,

	OnCancel = function(dialog, frame)
		frame:ShowTransferFrame(false)
	end,

	timeout = 0, preferredIndex = STATICPOPUP_NUMDIALOGS,
	hideOnEscape = 1
}
