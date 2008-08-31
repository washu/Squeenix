

Squeenix = {}
local Squeenix, f = Squeenix, CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...) if Squeenix[event] then return Squeenix[event](Squeenix, event, ...) end end)
f:RegisterEvent("ADDON_LOADED")


function Squeenix:ADDON_LOADED()
	SqueenixDB2 = SqueenixDB2 or {}
	self.db = SqueenixDB2

	MinimapBorder:SetTexture()
	MinimapBorderTop:Hide()

	Minimap:SetMaskTexture("Interface\\AddOns\\Squeenix\\Mask.blp")

	MinimapZoneTextButton:ClearAllPoints()
	MinimapZoneTextButton:SetPoint("BOTTOM", Minimap, "TOP", -8, 5)
	MinimapZoneTextButton:SetScript("OnClick", ToggleMinimap)

	MinimapZoneText:SetPoint("TOP", MinimapZoneTextButton, "TOP", 9, 1)

	MiniMapTracking:ClearAllPoints()
	MiniMapTracking:SetPoint("BOTTOMRIGHT", Minimap, "TOPLEFT", 5, -18)

	MiniMapBattlefieldFrame:ClearAllPoints()
	MiniMapBattlefieldFrame:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 13, 0)

	MiniMapWorldMapButton:ClearAllPoints()
	MiniMapWorldMapButton:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", 5, -22)

	MiniMapMeetingStoneFrame:ClearAllPoints()
	MiniMapMeetingStoneFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", 5, -53)

	MiniMapVoiceChatFrame:ClearAllPoints()
	MiniMapVoiceChatFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", 5, 20)

	MinimapZoomIn:ClearAllPoints()
	MinimapZoomIn:SetPoint("LEFT", Minimap, "BOTTOMRIGHT", -10, 5)

	MinimapZoomOut:ClearAllPoints()
	MinimapZoomOut:SetPoint("TOP", Minimap, "BOTTOMRIGHT", -15, 0)

	GameTimeFrame:ClearAllPoints()
	GameTimeFrame:SetPoint("CENTER", Minimap, "TOPRIGHT", 5, -20)

	MinimapToggleButton:ClearAllPoints()
	MinimapToggleButton:SetPoint("LEFT", MinimapZoneText, "RIGHT", -2, 0)

	self:SetBorder()
	self:HideButtons()
	self:ShowCompass()
	self:SetPosition()
	self:SetScale()

	f:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil
end


-- Global function, tells others the minimap shape
-- http://wowwiki.com/GetMinimapShape
function GetMinimapShape() return "SQUARE" end


-------------------------
--      LDB feeds      --
-------------------------

local function GetTipAnchor(frame)
	local x,y = frame:GetCenter()
	if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end
	local hhalf = (x > UIParent:GetWidth()*2/3) and "RIGHT" or (x < UIParent:GetWidth()/3) and "LEFT" or ""
	local vhalf = (y > UIParent:GetHeight()/2) and "TOP" or "BOTTOM"
	return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf
end


function GameTime_GetLocalTime(wantAMPM)
--~ 	local dateInfo = date("*t"); -- THIS CREATES A TABLE EVERY CALL!  Bad!!!!
	local hour, minute = date("%H"), date("%M")
	return GameTime_GetFormattedTime(tonumber(hour), tonumber(minute), wantAMPM), hour, minute
end


local timeobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("BlizzClock", {
	icon = "Interface\\Icons\\INV_Misc_PocketWatch_01",
	text = "12:00",
	OnClick = function()
		if TimeManagerClockButton.alarmFiring then
			PlaySound("igMainMenuQuit")
			TimeManager_TurnOffAlarm()
		else TimeManager_Toggle() end
	end,
	OnEnter = function(self)
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint(GetTipAnchor(self))

		TimeManagerClockButton_UpdateTooltip()
	end,
	OnLeave = function() GameTooltip:Hide() end,
})

local elapsed = 0
f:SetScript("OnUpdate", function(self, elap)
	elapsed = elapsed + elap
	if elapsed < 0.5 then return end

	elapsed = 0
	timeobj.text = GameTime_GetTime(false)
end)


