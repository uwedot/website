-- afem max 1.4
if not game:IsLoaded() then
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Script loading",
		Text = "Waiting for the game to finish loading!",
		Duration = 5
	})
	game.Loaded:Wait()
end

-- Instances:
local Converted = {
	["_AFEMMax"] = Instance.new("ScreenGui"),
	["_FUNCTIONS"] = Instance.new("ModuleScript"),
	["_SBT"] = Instance.new("ModuleScript"),
	["_DraggableObject"] = Instance.new("ModuleScript"),
	["_Init"] = Instance.new("LocalScript"),
	["_Menu"] = Instance.new("Frame"),
	["_UICorner"] = Instance.new("UICorner"),
	["_Branding"] = Instance.new("Frame"),
	["_Icon"] = Instance.new("ImageLabel"),
	["_UIListLayout"] = Instance.new("UIListLayout"),
	["_Naming"] = Instance.new("Frame"),
	["_HoverEffect"] = Instance.new("LocalScript"),
	["_PriorityLine"] = Instance.new("TextLabel"),
	["_UIFlexItem"] = Instance.new("UIFlexItem"),
	["_UIListLayout1"] = Instance.new("UIListLayout"),
	["_Line"] = Instance.new("TextLabel"),
	["_UIFlexItem1"] = Instance.new("UIFlexItem"),
	["_UIGradient"] = Instance.new("UIGradient"),
	["_UISizeConstraint"] = Instance.new("UISizeConstraint"),
	["_Bar"] = Instance.new("ImageButton"),
	["_Tip"] = Instance.new("TextLabel"),
	["_UICorner1"] = Instance.new("UICorner"),
	["_UIPadding"] = Instance.new("UIPadding"),
	["_UIScale"] = Instance.new("UIScale"),
	["_CanvasGroup"] = Instance.new("CanvasGroup"),
	["_UICorner2"] = Instance.new("UICorner"),
	["_Icon1"] = Instance.new("ImageLabel"),
	["_Open"] = Instance.new("TextButton"),
	["_Area"] = Instance.new("Frame"),
	["_UIListLayout2"] = Instance.new("UIListLayout"),
	["_CategorySelect"] = Instance.new("Frame"),
	["_UIFlexItem2"] = Instance.new("UIFlexItem"),
	["_UIListLayout3"] = Instance.new("UIListLayout"),
	["_Emotes"] = Instance.new("TextButton"),
	["_UICorner3"] = Instance.new("UICorner"),
	["_UIPadding1"] = Instance.new("UIPadding"),
	["_Icon2"] = Instance.new("ImageLabel"),
	["_TextLabel"] = Instance.new("TextLabel"),
	["_UIScale1"] = Instance.new("UIScale"),
	["_UIStroke"] = Instance.new("UIStroke"),
	["_Glass"] = Instance.new("UIGradient"),
	["_AnimationPacks"] = Instance.new("TextButton"),
	["_UICorner4"] = Instance.new("UICorner"),
	["_UIPadding2"] = Instance.new("UIPadding"),
	["_Icon3"] = Instance.new("ImageLabel"),
	["_TextLabel1"] = Instance.new("TextLabel"),
	["_UIScale2"] = Instance.new("UIScale"),
	["_UIStroke1"] = Instance.new("UIStroke"),
	["_Glass1"] = Instance.new("UIGradient"),
	["_Settings"] = Instance.new("TextButton"),
	["_UICorner5"] = Instance.new("UICorner"),
	["_UIPadding3"] = Instance.new("UIPadding"),
	["_Icon4"] = Instance.new("ImageLabel"),
	["_UIScale3"] = Instance.new("UIScale"),
	["_UIStroke2"] = Instance.new("UIStroke"),
	["_Glass2"] = Instance.new("UIGradient"),
	["_SwitchSCR"] = Instance.new("LocalScript"),
	["_AnimationController"] = Instance.new("TextButton"),
	["_UICorner6"] = Instance.new("UICorner"),
	["_UIPadding4"] = Instance.new("UIPadding"),
	["_Icon5"] = Instance.new("ImageLabel"),
	["_UIScale4"] = Instance.new("UIScale"),
	["_UIStroke3"] = Instance.new("UIStroke"),
	["_Glass3"] = Instance.new("UIGradient"),
	["_ItemSelect"] = Instance.new("Frame"),
	["_UIFlexItem3"] = Instance.new("UIFlexItem"),
	["_UIPageLayout"] = Instance.new("UIPageLayout"),
	["_Emotes1"] = Instance.new("Frame"),
	["_UIListLayout4"] = Instance.new("UIListLayout"),
	["_TextLabel2"] = Instance.new("TextLabel"),
	["_Listing"] = Instance.new("ScrollingFrame"),
	["_UIFlexItem4"] = Instance.new("UIFlexItem"),
	["_UIGridLayout"] = Instance.new("UIGridLayout"),
	["_UIPadding5"] = Instance.new("UIPadding"),
	["_PaginationBar"] = Instance.new("Frame"),
	["_UIListLayout5"] = Instance.new("UIListLayout"),
	["_SamplePage"] = Instance.new("Frame"),
	["_UICorner7"] = Instance.new("UICorner"),
	["_Label"] = Instance.new("TextLabel"),
	["_UIScale5"] = Instance.new("UIScale"),
	["_Next"] = Instance.new("TextButton"),
	["_UIScale6"] = Instance.new("UIScale"),
	["_UIPadding6"] = Instance.new("UIPadding"),
	["_UICorner8"] = Instance.new("UICorner"),
	["_UIStroke4"] = Instance.new("UIStroke"),
	["_UIPadding7"] = Instance.new("UIPadding"),
	["_Previous"] = Instance.new("TextButton"),
	["_UIScale7"] = Instance.new("UIScale"),
	["_UIPadding8"] = Instance.new("UIPadding"),
	["_UICorner9"] = Instance.new("UICorner"),
	["_UIStroke5"] = Instance.new("UIStroke"),
	["_ActionBar"] = Instance.new("Frame"),
	["_Search"] = Instance.new("TextBox"),
	["_UICorner10"] = Instance.new("UICorner"),
	["_UIPadding9"] = Instance.new("UIPadding"),
	["_UISizeConstraint1"] = Instance.new("UISizeConstraint"),
	["_Favorites"] = Instance.new("TextButton"),
	["_UICorner11"] = Instance.new("UICorner"),
	["_UIPadding10"] = Instance.new("UIPadding"),
	["_UIStroke6"] = Instance.new("UIStroke"),
	["_Label1"] = Instance.new("TextLabel"),
	["_UIListLayout6"] = Instance.new("UIListLayout"),
	["_Spacer"] = Instance.new("Frame"),
	["_UIFlexItem5"] = Instance.new("UIFlexItem"),
	["_Spinner"] = Instance.new("Frame"),
	["_UIAspectRatioConstraint"] = Instance.new("UIAspectRatioConstraint"),
	["_Spinner1"] = Instance.new("ImageLabel"),
	["_UIAspectRatioConstraint1"] = Instance.new("UIAspectRatioConstraint"),
	["_Spin"] = Instance.new("LocalScript"),
	["_TextLabel3"] = Instance.new("TextLabel"),
	["_UIPadding11"] = Instance.new("UIPadding"),
	["_OldSwitch"] = Instance.new("TextButton"),
	["_UICorner12"] = Instance.new("UICorner"),
	["_UIPadding12"] = Instance.new("UIPadding"),
	["_UIStroke7"] = Instance.new("UIStroke"),
	["_UIPageLayout1"] = Instance.new("UIPageLayout"),
	["_UGCEmote"] = Instance.new("TextLabel"),
	["_RobloxEmotes"] = Instance.new("TextLabel"),
	["_SwitchTabs"] = Instance.new("Frame"),
	["_UICorner13"] = Instance.new("UICorner"),
	["_UIPadding13"] = Instance.new("UIPadding"),
	["_UIStroke8"] = Instance.new("UIStroke"),
	["_Roblox"] = Instance.new("TextButton"),
	["_UICorner14"] = Instance.new("UICorner"),
	["_UIPadding14"] = Instance.new("UIPadding"),
	["_UIListLayout7"] = Instance.new("UIListLayout"),
	["_UGC"] = Instance.new("TextButton"),
	["_UICorner15"] = Instance.new("UICorner"),
	["_UIPadding15"] = Instance.new("UIPadding"),
	["_SearchSuggestion"] = Instance.new("Frame"),
	["_UIListLayout8"] = Instance.new("UIListLayout"),
	["_UIPadding16"] = Instance.new("UIPadding"),
	["_ChipSample"] = Instance.new("Frame"),
	["_Clickable"] = Instance.new("TextButton"),
	["_UICorner16"] = Instance.new("UICorner"),
	["_UIPadding17"] = Instance.new("UIPadding"),
	["_UIStroke9"] = Instance.new("UIStroke"),
	["_Label2"] = Instance.new("TextLabel"),
	["_FavoritesSection"] = Instance.new("Frame"),
	["_UIGradient1"] = Instance.new("UIGradient"),
	["_UIStroke10"] = Instance.new("UIStroke"),
	["_UICorner17"] = Instance.new("UICorner"),
	["_UIListLayout9"] = Instance.new("UIListLayout"),
	["_TextLabel4"] = Instance.new("TextLabel"),
	["_UIPadding18"] = Instance.new("UIPadding"),
	["_Listing1"] = Instance.new("ScrollingFrame"),
	["_UIFlexItem6"] = Instance.new("UIFlexItem"),
	["_UIListLayout10"] = Instance.new("UIListLayout"),
	["_UIPadding19"] = Instance.new("UIPadding"),
	["_FavoritesSetup"] = Instance.new("LocalScript"),
	["_AnimationPacks1"] = Instance.new("Frame"),
	["_UIListLayout11"] = Instance.new("UIListLayout"),
	["_TextLabel5"] = Instance.new("TextLabel"),
	["_Listing2"] = Instance.new("ScrollingFrame"),
	["_UIFlexItem7"] = Instance.new("UIFlexItem"),
	["_UIGridLayout1"] = Instance.new("UIGridLayout"),
	["_UIPadding20"] = Instance.new("UIPadding"),
	["_PaginationBar1"] = Instance.new("Frame"),
	["_UIListLayout12"] = Instance.new("UIListLayout"),
	["_Previous1"] = Instance.new("TextButton"),
	["_UIScale8"] = Instance.new("UIScale"),
	["_SamplePage1"] = Instance.new("Frame"),
	["_UICorner18"] = Instance.new("UICorner"),
	["_Label3"] = Instance.new("TextLabel"),
	["_UIScale9"] = Instance.new("UIScale"),
	["_Next1"] = Instance.new("TextButton"),
	["_UIScale10"] = Instance.new("UIScale"),
	["_PackEditor"] = Instance.new("Frame"),
	["_UIGradient2"] = Instance.new("UIGradient"),
	["_UIStroke11"] = Instance.new("UIStroke"),
	["_UICorner19"] = Instance.new("UICorner"),
	["_UIListLayout13"] = Instance.new("UIListLayout"),
	["_TextLabel6"] = Instance.new("TextLabel"),
	["_UIPadding21"] = Instance.new("UIPadding"),
	["_Listing3"] = Instance.new("ScrollingFrame"),
	["_UIFlexItem8"] = Instance.new("UIFlexItem"),
	["_UIListLayout14"] = Instance.new("UIListLayout"),
	["_UIPadding22"] = Instance.new("UIPadding"),
	["_PackEditorScr"] = Instance.new("LocalScript"),
	["_PackEditorUpdate"] = Instance.new("BindableEvent"),
	["_Settings1"] = Instance.new("Frame"),
	["_UIListLayout15"] = Instance.new("UIListLayout"),
	["_Listing4"] = Instance.new("ScrollingFrame"),
	["_UIFlexItem9"] = Instance.new("UIFlexItem"),
	["_UIPadding23"] = Instance.new("UIPadding"),
	["_UIListLayout16"] = Instance.new("UIListLayout"),
	["_Samples"] = Instance.new("Frame"),
	["_TextLabel7"] = Instance.new("TextLabel"),
	["_Toggle"] = Instance.new("TextButton"),
	["_ToggleTrack"] = Instance.new("Frame"),
	["_UICorner20"] = Instance.new("UICorner"),
	["_Ball"] = Instance.new("Frame"),
	["_UIAspectRatioConstraint2"] = Instance.new("UIAspectRatioConstraint"),
	["_UICorner21"] = Instance.new("UICorner"),
	["_UIPadding24"] = Instance.new("UIPadding"),
	["_UIListLayout17"] = Instance.new("UIListLayout"),
	["_Label4"] = Instance.new("TextLabel"),
	["_Select"] = Instance.new("Frame"),
	["_UIListLayout18"] = Instance.new("UIListLayout"),
	["_UIPadding25"] = Instance.new("UIPadding"),
	["_UICorner22"] = Instance.new("UICorner"),
	["_SelectButton"] = Instance.new("TextButton"),
	["_UICorner23"] = Instance.new("UICorner"),
	["_UIPadding26"] = Instance.new("UIPadding"),
	["_TextLabel8"] = Instance.new("TextLabel"),
	["_SettingsSetup"] = Instance.new("LocalScript"),
	["_PaginationNSearch"] = Instance.new("LocalScript"),
	["_AnimationController1"] = Instance.new("Frame"),
	["_DockerSwitch"] = Instance.new("TextButton"),
	["_UICorner24"] = Instance.new("UICorner"),
	["_UIPadding27"] = Instance.new("UIPadding"),
	["_UIStroke12"] = Instance.new("UIStroke"),
	["_Docking"] = Instance.new("LocalScript"),
	["_Dockable"] = Instance.new("Frame"),
	["_UIListLayout19"] = Instance.new("UIListLayout"),
	["_AnimContSetup"] = Instance.new("LocalScript"),
	["_Samples1"] = Instance.new("Frame"),
	["_TextLabel9"] = Instance.new("TextLabel"),
	["_Toggle1"] = Instance.new("TextButton"),
	["_ToggleTrack1"] = Instance.new("Frame"),
	["_UICorner25"] = Instance.new("UICorner"),
	["_Ball1"] = Instance.new("Frame"),
	["_UIAspectRatioConstraint3"] = Instance.new("UIAspectRatioConstraint"),
	["_UICorner26"] = Instance.new("UICorner"),
	["_UIPadding28"] = Instance.new("UIPadding"),
	["_UIListLayout20"] = Instance.new("UIListLayout"),
	["_Label5"] = Instance.new("TextLabel"),
	["_Select1"] = Instance.new("Frame"),
	["_UIListLayout21"] = Instance.new("UIListLayout"),
	["_UIPadding29"] = Instance.new("UIPadding"),
	["_UICorner27"] = Instance.new("UICorner"),
	["_SelectButton1"] = Instance.new("TextButton"),
	["_UICorner28"] = Instance.new("UICorner"),
	["_UIPadding30"] = Instance.new("UIPadding"),
	["_TextLabel10"] = Instance.new("TextLabel"),
	["_SelectTrack"] = Instance.new("Frame"),
	["_UIGradient3"] = Instance.new("UIGradient"),
	["_UICorner29"] = Instance.new("UICorner"),
	["_UIStroke13"] = Instance.new("UIStroke"),
	["_UIPadding31"] = Instance.new("UIPadding"),
	["_UIListLayout22"] = Instance.new("UIListLayout"),
	["_TextLabel11"] = Instance.new("TextLabel"),
	["_Listing5"] = Instance.new("ScrollingFrame"),
	["_UIListLayout23"] = Instance.new("UIListLayout"),
	["_UIPadding32"] = Instance.new("UIPadding"),
	["_Sample"] = Instance.new("TextButton"),
	["_UICorner30"] = Instance.new("UICorner"),
	["_UIPadding33"] = Instance.new("UIPadding"),
	["_UIStroke14"] = Instance.new("UIStroke"),
	["_UIListLayout24"] = Instance.new("UIListLayout"),
	["_TextLabel12"] = Instance.new("TextLabel"),
	["_TrackName"] = Instance.new("TextLabel"),
	["_UIFlexItem10"] = Instance.new("UIFlexItem"),
	["_Listing6"] = Instance.new("ScrollingFrame"),
	["_UIFlexItem11"] = Instance.new("UIFlexItem"),
	["_UIPadding34"] = Instance.new("UIPadding"),
	["_UIListLayout25"] = Instance.new("UIListLayout"),
	["_Seekbar"] = Instance.new("TextButton"),
	["_Track"] = Instance.new("Frame"),
	["_UICorner31"] = Instance.new("UICorner"),
	["_Ball2"] = Instance.new("Frame"),
	["_UIAspectRatioConstraint4"] = Instance.new("UIAspectRatioConstraint"),
	["_UICorner32"] = Instance.new("UICorner"),
	["_TimePos"] = Instance.new("TextLabel"),
	["_UIPadding35"] = Instance.new("UIPadding"),
	["_UIPadding36"] = Instance.new("UIPadding"),
	["_Tactical"] = Instance.new("Frame"),
	["_UIListLayout26"] = Instance.new("UIListLayout"),
	["_Bar1"] = Instance.new("Frame"),
	["_UICorner33"] = Instance.new("UICorner"),
	["_Bar2"] = Instance.new("Frame"),
	["_UICorner34"] = Instance.new("UICorner"),
	["_Bar3"] = Instance.new("Frame"),
	["_UICorner35"] = Instance.new("UICorner"),
	["_Bar4"] = Instance.new("Frame"),
	["_UICorner36"] = Instance.new("UICorner"),
	["_Bar5"] = Instance.new("Frame"),
	["_UICorner37"] = Instance.new("UICorner"),
	["_Bar6"] = Instance.new("Frame"),
	["_UICorner38"] = Instance.new("UICorner"),
	["_Bar7"] = Instance.new("Frame"),
	["_UICorner39"] = Instance.new("UICorner"),
	["_Bar8"] = Instance.new("Frame"),
	["_UICorner40"] = Instance.new("UICorner"),
	["_Bar9"] = Instance.new("Frame"),
	["_UICorner41"] = Instance.new("UICorner"),
	["_Bar10"] = Instance.new("Frame"),
	["_UICorner42"] = Instance.new("UICorner"),
	["_Bar11"] = Instance.new("Frame"),
	["_UICorner43"] = Instance.new("UICorner"),
	["_UIListLayout27"] = Instance.new("UIListLayout"),
	["_UICorner44"] = Instance.new("UICorner"),
	["_UIPadding37"] = Instance.new("UIPadding"),
	["_Handle"] = Instance.new("TextButton"),
	["_UICorner45"] = Instance.new("UICorner"),
	["_ItemListTemplate"] = Instance.new("Frame"),
	["_UIPadding38"] = Instance.new("UIPadding"),
	["_Clickable1"] = Instance.new("TextButton"),
	["_UIPadding39"] = Instance.new("UIPadding"),
	["_Details"] = Instance.new("Frame"),
	["_Description"] = Instance.new("TextLabel"),
	["_UIFlexItem12"] = Instance.new("UIFlexItem"),
	["_Buttons"] = Instance.new("Frame"),
	["_Loading"] = Instance.new("Frame"),
	["_Progress"] = Instance.new("Frame"),
	["_UICorner46"] = Instance.new("UICorner"),
	["_UICorner47"] = Instance.new("UICorner"),
	["_UIFlexItem13"] = Instance.new("UIFlexItem"),
	["_Play"] = Instance.new("TextButton"),
	["_UIPadding40"] = Instance.new("UIPadding"),
	["_UICorner48"] = Instance.new("UICorner"),
	["_OffSale"] = Instance.new("TextButton"),
	["_UIPadding41"] = Instance.new("UIPadding"),
	["_UICorner49"] = Instance.new("UICorner"),
	["_UIFlexItem14"] = Instance.new("UIFlexItem"),
	["_UIListLayout28"] = Instance.new("UIListLayout"),
	["_Title"] = Instance.new("TextLabel"),
	["_UIListLayout29"] = Instance.new("UIListLayout"),
	["_UIFlexItem15"] = Instance.new("UIFlexItem"),
	["_Thumbnail"] = Instance.new("ImageLabel"),
	["_UIStroke15"] = Instance.new("UIStroke"),
	["_UIAspectRatioConstraint5"] = Instance.new("UIAspectRatioConstraint"),
	["_UICorner50"] = Instance.new("UICorner"),
	["_UIFlexItem16"] = Instance.new("UIFlexItem"),
	["_UIListLayout30"] = Instance.new("UIListLayout"),
	["_UIStroke16"] = Instance.new("UIStroke"),
	["_CustomEffect"] = Instance.new("UIGradient"),
	["_UICorner51"] = Instance.new("UICorner"),
	["_OffSaleEffect"] = Instance.new("UIGradient"),
	["_UIScale11"] = Instance.new("UIScale"),
	["_Tip1"] = Instance.new("TextLabel"),
	["_MenuStateChange"] = Instance.new("BindableEvent"),
	["_MenuSpringTakeover"] = Instance.new("BindableEvent"),
	["_MenuDisplacement"] = Instance.new("LocalScript"),
	["_ItemDetail"] = Instance.new("Frame"),
	["_UIStroke17"] = Instance.new("UIStroke"),
	["_CustomEffect1"] = Instance.new("UIGradient"),
	["_UICorner52"] = Instance.new("UICorner"),
	["_UIListLayout31"] = Instance.new("UIListLayout"),
	["_UIPadding42"] = Instance.new("UIPadding"),
	["_Item"] = Instance.new("Frame"),
	["_UIFlexItem17"] = Instance.new("UIFlexItem"),
	["_AvatarPreview"] = Instance.new("ViewportFrame"),
	["_UIStroke18"] = Instance.new("UIStroke"),
	["_UICorner53"] = Instance.new("UICorner"),
	["_Preview"] = Instance.new("LocalScript"),
	["_PlayEmote"] = Instance.new("BindableEvent"),
	["_WorldModel"] = Instance.new("WorldModel"),
	["_Drag"] = Instance.new("TextButton"),
	["_UIFlexItem18"] = Instance.new("UIFlexItem"),
	["_UIListLayout32"] = Instance.new("UIListLayout"),
	["_Details1"] = Instance.new("Frame"),
	["_UIListLayout33"] = Instance.new("UIListLayout"),
	["_ItemName"] = Instance.new("TextLabel"),
	["_ItemDescription"] = Instance.new("TextLabel"),
	["_UIFlexItem19"] = Instance.new("UIFlexItem"),
	["_Actions"] = Instance.new("Frame"),
	["_UIListLayout34"] = Instance.new("UIListLayout"),
	["_Favorites1"] = Instance.new("TextButton"),
	["_UICorner54"] = Instance.new("UICorner"),
	["_UIPadding43"] = Instance.new("UIPadding"),
	["_UIStroke19"] = Instance.new("UIStroke"),
	["_Play1"] = Instance.new("TextButton"),
	["_UICorner55"] = Instance.new("UICorner"),
	["_UIPadding44"] = Instance.new("UIPadding"),
	["_UIStroke20"] = Instance.new("UIStroke"),
	["_Spacer1"] = Instance.new("Frame"),
	["_UIFlexItem20"] = Instance.new("UIFlexItem"),
	["_Close"] = Instance.new("TextButton"),
	["_UICorner56"] = Instance.new("UICorner"),
	["_UIPadding45"] = Instance.new("UIPadding"),
	["_UIStroke21"] = Instance.new("UIStroke"),
	["_CopyAnimID"] = Instance.new("TextButton"),
	["_UICorner57"] = Instance.new("UICorner"),
	["_UIPadding46"] = Instance.new("UIPadding"),
	["_UIStroke22"] = Instance.new("UIStroke"),
	["_FloatingButton"] = Instance.new("TextButton"),
	["_UICorner58"] = Instance.new("UICorner"),
	["_UIPadding47"] = Instance.new("UIPadding"),
	["_UIStroke23"] = Instance.new("UIStroke"),
	["_Backdrop"] = Instance.new("Frame"),
	["_ShamelessCredit"] = Instance.new("TextLabel"),
	["_QuickSelectorIcon"] = Instance.new("BindableEvent"),
	["_PointSave"] = Instance.new("ModuleScript"),
	["_Modal"] = Instance.new("Frame"),
	["_Container"] = Instance.new("CanvasGroup"),
	["_UICorner59"] = Instance.new("UICorner"),
	["_UIStroke24"] = Instance.new("UIStroke"),
	["_UIListLayout35"] = Instance.new("UIListLayout"),
	["_Visual"] = Instance.new("Frame"),
	["_Desc"] = Instance.new("TextLabel"),
	["_UIFlexItem21"] = Instance.new("UIFlexItem"),
	["_Title1"] = Instance.new("TextLabel"),
	["_UIPadding48"] = Instance.new("UIPadding"),
	["_UIListLayout36"] = Instance.new("UIListLayout"),
	["_UIFlexItem22"] = Instance.new("UIFlexItem"),
	["_Buttons1"] = Instance.new("Frame"),
	["_UIListLayout37"] = Instance.new("UIListLayout"),
	["_Sample1"] = Instance.new("TextButton"),
	["_UICorner60"] = Instance.new("UICorner"),
	["_UIPadding49"] = Instance.new("UIPadding"),
	["_UIFlexItem23"] = Instance.new("UIFlexItem"),
	["_UIPadding50"] = Instance.new("UIPadding"),
	["_UIScale12"] = Instance.new("UIScale"),
	["_Input"] = Instance.new("Frame"),
	["_TextBox"] = Instance.new("TextBox"),
	["_UICorner61"] = Instance.new("UICorner"),
	["_UIPadding51"] = Instance.new("UIPadding"),
	["_UIStroke25"] = Instance.new("UIStroke"),
	["_UIPadding52"] = Instance.new("UIPadding"),
	["_GrabArea"] = Instance.new("TextButton"),
	["_Open1"] = Instance.new("TextButton"),
	["_ClickAndHold"] = Instance.new("ModuleScript"),
	["_MarketplaceEmotes"] = Instance.new("ModuleScript"),
	["_AIEngine"] = Instance.new("ModuleScript"),
	["_Notifications"] = Instance.new("Frame"),
	["_UIListLayout38"] = Instance.new("UIListLayout"),
	["_NotificationContainer"] = Instance.new("Frame"),
	["_Frame"] = Instance.new("Frame"),
	["_UICorner62"] = Instance.new("UICorner"),
	["_UIGradient4"] = Instance.new("UIGradient"),
	["_UIStroke26"] = Instance.new("UIStroke"),
	["_UIPadding53"] = Instance.new("UIPadding"),
	["_UIListLayout39"] = Instance.new("UIListLayout"),
	["_Title2"] = Instance.new("TextLabel"),
	["_Body"] = Instance.new("TextLabel"),
	["_UIPadding54"] = Instance.new("UIPadding"),
	["_UIPadding55"] = Instance.new("UIPadding"),
	["_ParticleEffects"] = Instance.new("ModuleScript"),
	["_FloatingButtons"] = Instance.new("Frame"),
	["_Sample2"] = Instance.new("TextButton"),
	["_UICorner63"] = Instance.new("UICorner"),
	["_UIPadding56"] = Instance.new("UIPadding"),
	["_UIStroke27"] = Instance.new("UIStroke"),
	["_ImageLabel"] = Instance.new("ImageLabel"),
	["_UIPadding57"] = Instance.new("UIPadding"),
	["_Update"] = Instance.new("BindableEvent"),
	["_UIGridLayout2"] = Instance.new("UIGridLayout"),
	["_QuickSelectorFrame"] = Instance.new("CanvasGroup"),
	["_UIStroke28"] = Instance.new("UIStroke"),
	["_UIPadding58"] = Instance.new("UIPadding"),
	["_ScrollingFrame"] = Instance.new("ScrollingFrame"),
	["_UIListLayout40"] = Instance.new("UIListLayout"),
	["_Sample3"] = Instance.new("Frame"),
	["_UIAspectRatioConstraint6"] = Instance.new("UIAspectRatioConstraint"),
	["_UICorner64"] = Instance.new("UICorner"),
	["_UIStroke29"] = Instance.new("UIStroke"),
	["_UIPadding59"] = Instance.new("UIPadding"),
	["_Thumbnail1"] = Instance.new("ImageLabel"),
	["_UIScale13"] = Instance.new("UIScale"),
	["_Tooltip"] = Instance.new("CanvasGroup"),
	["_Highlight"] = Instance.new("Frame"),
	["_UIStroke30"] = Instance.new("UIStroke"),
	["_UICorner65"] = Instance.new("UICorner"),
	["_UIPadding60"] = Instance.new("UIPadding"),
	["_Text"] = Instance.new("Frame"),
	["_UICorner66"] = Instance.new("UICorner"),
	["_UIStroke31"] = Instance.new("UIStroke"),
	["_TextLabel13"] = Instance.new("TextLabel"),
	["_UIPadding61"] = Instance.new("UIPadding"),
	["_UIScale14"] = Instance.new("UIScale"),
}

-- Properties:
Converted["_AFEMMax"].DisplayOrder = 2
Converted["_AFEMMax"].IgnoreGuiInset = true
Converted["_AFEMMax"].ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
Converted["_AFEMMax"].ResetOnSpawn = false
Converted["_AFEMMax"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Converted["_AFEMMax"].Name = "AFEMMax"
Converted["_AFEMMax"].Parent = game:GetService("CoreGui")
Converted["_Menu"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Menu"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Menu"].BackgroundTransparency = 0.5
Converted["_Menu"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Menu"].BorderSizePixel = 0
Converted["_Menu"].ClipsDescendants = true
Converted["_Menu"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Menu"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Menu"].Name = "Menu"
Converted["_Menu"].Parent = Converted["_AFEMMax"]
Converted["_UICorner"].CornerRadius = UDim.new(0, 0)
Converted["_UICorner"].Parent = Converted["_Menu"]
Converted["_Branding"].AutomaticSize = Enum.AutomaticSize.X
Converted["_Branding"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Branding"].BackgroundTransparency = 1
Converted["_Branding"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Branding"].Position = UDim2.new(0, 30, 0, 30)
Converted["_Branding"].Size = UDim2.new(0.174346209, 0, 0.08130081, 0)
Converted["_Branding"].Name = "Branding"
Converted["_Branding"].Parent = Converted["_Menu"]
Converted["_Icon"].Image = "rbxassetid://6567073136"
Converted["_Icon"].ScaleType = Enum.ScaleType.Fit
Converted["_Icon"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Icon"].BackgroundTransparency = 1
Converted["_Icon"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Icon"].BorderSizePixel = 0
Converted["_Icon"].Size = UDim2.new(0, 30, 1, 0)
Converted["_Icon"].Name = "Icon"
Converted["_Icon"].Parent = Converted["_Branding"]
Converted["_UIListLayout"].Padding = UDim.new(0, 8)
Converted["_UIListLayout"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout"].Parent = Converted["_Branding"]
Converted["_Naming"].AutomaticSize = Enum.AutomaticSize.X
Converted["_Naming"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Naming"].BackgroundTransparency = 1
Converted["_Naming"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Naming"].BorderSizePixel = 0
Converted["_Naming"].LayoutOrder = 1
Converted["_Naming"].Size = UDim2.new(0, 0, 1, 0)
Converted["_Naming"].Name = "Naming"
Converted["_Naming"].Parent = Converted["_Branding"]
Converted["_PriorityLine"].Font = Enum.Font.GothamBold
Converted["_PriorityLine"].Text = "AFEM"
Converted["_PriorityLine"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_PriorityLine"].TextScaled = true
Converted["_PriorityLine"].TextSize = 64
Converted["_PriorityLine"].TextWrapped = true
Converted["_PriorityLine"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_PriorityLine"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_PriorityLine"].BackgroundTransparency = 1
Converted["_PriorityLine"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_PriorityLine"].BorderSizePixel = 0
Converted["_PriorityLine"].Size = UDim2.new(0, 100, 0, 0)
Converted["_PriorityLine"].Name = "PriorityLine"
Converted["_PriorityLine"].Parent = Converted["_Naming"]
Converted["_UIFlexItem"].FlexMode = Enum.UIFlexMode.Custom
Converted["_UIFlexItem"].GrowRatio = 2
Converted["_UIFlexItem"].Parent = Converted["_PriorityLine"]
Converted["_UIListLayout1"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout1"].Parent = Converted["_Naming"]
Converted["_Line"].FontFace = Font.new("rbxassetid://12187365364")
Converted["_Line"].Text = "Max"
Converted["_Line"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Line"].TextScaled = true
Converted["_Line"].TextSize = 14
Converted["_Line"].TextWrapped = true
Converted["_Line"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_Line"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Line"].BackgroundTransparency = 1
Converted["_Line"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Line"].BorderSizePixel = 0
Converted["_Line"].Size = UDim2.new(0, 100, 0, 0)
Converted["_Line"].Name = "Line"
Converted["_Line"].Parent = Converted["_Naming"]
Converted["_UIFlexItem1"].FlexMode = Enum.UIFlexMode.Custom
Converted["_UIFlexItem1"].GrowRatio = 1
Converted["_UIFlexItem1"].Parent = Converted["_Line"]
Converted["_UIGradient"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(157, 157, 157)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
}
Converted["_UIGradient"].Rotation = 79
Converted["_UIGradient"].Parent = Converted["_Line"]
Converted["_UISizeConstraint"].MaxSize = Vector2.new(math.huge, 40)
Converted["_UISizeConstraint"].Parent = Converted["_Branding"]
Converted["_Bar"].Image = "rbxassetid://17333707046"
Converted["_Bar"].ImageTransparency = 0.699999988079071
Converted["_Bar"].ScaleType = Enum.ScaleType.Slice
Converted["_Bar"].SliceCenter = Rect.new(112, 112, 113, 113)
Converted["_Bar"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Bar"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Bar"].BackgroundTransparency = 1
Converted["_Bar"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Bar"].BorderSizePixel = 0
Converted["_Bar"].Position = UDim2.new(0.5, 0, 0, 40)
Converted["_Bar"].Size = UDim2.new(0, 128, 0, 6)
Converted["_Bar"].Name = "Bar"
Converted["_Bar"].Parent = Converted["_Menu"]
Converted["_Tip"].Font = Enum.Font.Gotham
Converted["_Tip"].Text = "Swipe down or tap to close."
Converted["_Tip"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Tip"].TextScaled = true
Converted["_Tip"].TextSize = 14
Converted["_Tip"].TextWrapped = true
Converted["_Tip"].AnchorPoint = Vector2.new(0.5, 0)
Converted["_Tip"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Tip"].BackgroundTransparency = 0.699999988079071
Converted["_Tip"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Tip"].BorderSizePixel = 0
Converted["_Tip"].Position = UDim2.new(0.5, 0, 1, 5)
Converted["_Tip"].Size = UDim2.new(1, 80, 0, 40)
Converted["_Tip"].Name = "Tip"
Converted["_Tip"].Parent = Converted["_Bar"]
Converted["_UICorner1"].Parent = Converted["_Tip"]
Converted["_UIPadding"].PaddingBottom = UDim.new(0, 6)
Converted["_UIPadding"].PaddingLeft = UDim.new(0, 12)
Converted["_UIPadding"].PaddingRight = UDim.new(0, 12)
Converted["_UIPadding"].PaddingTop = UDim.new(0, 6)
Converted["_UIPadding"].Parent = Converted["_Tip"]
Converted["_UIScale"].Parent = Converted["_Menu"]
Converted["_CanvasGroup"].GroupTransparency = 1
Converted["_CanvasGroup"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_CanvasGroup"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_CanvasGroup"].BorderSizePixel = 0
Converted["_CanvasGroup"].Interactable = false
Converted["_CanvasGroup"].Size = UDim2.new(1, 0, 1, 0)
Converted["_CanvasGroup"].ZIndex = 99
Converted["_CanvasGroup"].Parent = Converted["_Menu"]
Converted["_UICorner2"].CornerRadius = UDim.new(0, 0)
Converted["_UICorner2"].Parent = Converted["_CanvasGroup"]
Converted["_Icon1"].Image = "rbxassetid://6567073136"
Converted["_Icon1"].ImageColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Icon1"].ScaleType = Enum.ScaleType.Fit
Converted["_Icon1"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Icon1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Icon1"].BackgroundTransparency = 1
Converted["_Icon1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Icon1"].BorderSizePixel = 0
Converted["_Icon1"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Icon1"].Size = UDim2.new(1, -200, 1, -200)
Converted["_Icon1"].Name = "Icon"
Converted["_Icon1"].Parent = Converted["_CanvasGroup"]
Converted["_Open"].Font = Enum.Font.SourceSans
Converted["_Open"].Text = ""
Converted["_Open"].TextColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Open"].TextSize = 14
Converted["_Open"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Open"].BackgroundTransparency = 1
Converted["_Open"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Open"].BorderSizePixel = 0
Converted["_Open"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Open"].Name = "Open"
Converted["_Open"].Parent = Converted["_CanvasGroup"]
Converted["_Area"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Area"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Area"].BackgroundTransparency = 1
Converted["_Area"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Area"].BorderSizePixel = 0
Converted["_Area"].Position = UDim2.new(0.5, 0, 0.550000012, 0)
Converted["_Area"].Size = UDim2.new(1, -70, 1, -100)
Converted["_Area"].Name = "Area"
Converted["_Area"].Parent = Converted["_Menu"]
Converted["_UIListLayout2"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout2"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout2"].Parent = Converted["_Area"]
Converted["_CategorySelect"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_CategorySelect"].BackgroundTransparency = 1
Converted["_CategorySelect"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_CategorySelect"].BorderSizePixel = 0
Converted["_CategorySelect"].Size = UDim2.new(0, 0, 1, 0)
Converted["_CategorySelect"].Name = "CategorySelect"
Converted["_CategorySelect"].Parent = Converted["_Area"]
Converted["_UIFlexItem2"].FlexMode = Enum.UIFlexMode.Custom
Converted["_UIFlexItem2"].GrowRatio = 1.2000000476837158
Converted["_UIFlexItem2"].Parent = Converted["_CategorySelect"]
Converted["_UIListLayout3"].Padding = UDim.new(0, 8)
Converted["_UIListLayout3"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIListLayout3"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout3"].VerticalAlignment = Enum.VerticalAlignment.Center
Converted["_UIListLayout3"].Parent = Converted["_CategorySelect"]
Converted["_Emotes"].Font = Enum.Font.Gotham
Converted["_Emotes"].Text = ""
Converted["_Emotes"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Emotes"].TextScaled = true
Converted["_Emotes"].TextSize = 14
Converted["_Emotes"].TextWrapped = true
Converted["_Emotes"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Emotes"].BackgroundTransparency = 0.20000000298023224
Converted["_Emotes"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Emotes"].BorderSizePixel = 0
Converted["_Emotes"].Size = UDim2.new(0, 50, 0, 75)
Converted["_Emotes"].Name = "Emotes"
Converted["_Emotes"].Parent = Converted["_CategorySelect"]
Converted["_UICorner3"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner3"].Parent = Converted["_Emotes"]
Converted["_UIPadding1"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding1"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding1"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding1"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding1"].Parent = Converted["_Emotes"]
Converted["_Icon2"].Image = "rbxassetid://6567073136"
Converted["_Icon2"].ImageColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Icon2"].ScaleType = Enum.ScaleType.Fit
Converted["_Icon2"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Icon2"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Icon2"].BackgroundTransparency = 1
Converted["_Icon2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Icon2"].BorderSizePixel = 0
Converted["_Icon2"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Icon2"].Size = UDim2.new(0, 30, 0, 30)
Converted["_Icon2"].Name = "Icon"
Converted["_Icon2"].Parent = Converted["_Emotes"]
Converted["_TextLabel"].Font = Enum.Font.GothamBold
Converted["_TextLabel"].Text = "EM"
Converted["_TextLabel"].TextColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel"].TextScaled = true
Converted["_TextLabel"].TextSize = 14
Converted["_TextLabel"].TextWrapped = true
Converted["_TextLabel"].AnchorPoint = Vector2.new(1, 1)
Converted["_TextLabel"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel"].BackgroundTransparency = 1
Converted["_TextLabel"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel"].BorderSizePixel = 0
Converted["_TextLabel"].Position = UDim2.new(1, 0, 1, 3)
Converted["_TextLabel"].Size = UDim2.new(0, 10, 0, 10)
Converted["_TextLabel"].Parent = Converted["_Emotes"]
Converted["_UIScale1"].Scale = 1.2000000476837158
Converted["_UIScale1"].Parent = Converted["_Emotes"]
Converted["_UIStroke"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke"].Parent = Converted["_Emotes"]
Converted["_Glass"].Rotation = -22
Converted["_Glass"].Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.46633419394493103, 0),
	NumberSequenceKeypoint.new(0.9476309418678284, 0.90625),
	NumberSequenceKeypoint.new(1, 1)
}
Converted["_Glass"].Name = "Glass"
Converted["_Glass"].Parent = Converted["_UIStroke"]
Converted["_AnimationPacks"].Font = Enum.Font.Gotham
Converted["_AnimationPacks"].Text = ""
Converted["_AnimationPacks"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_AnimationPacks"].TextScaled = true
Converted["_AnimationPacks"].TextSize = 14
Converted["_AnimationPacks"].TextWrapped = true
Converted["_AnimationPacks"].BackgroundColor3 = Color3.fromRGB(36, 36, 36)
Converted["_AnimationPacks"].BackgroundTransparency = 0.20000000298023224
Converted["_AnimationPacks"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_AnimationPacks"].BorderSizePixel = 0
Converted["_AnimationPacks"].LayoutOrder = 1
Converted["_AnimationPacks"].Size = UDim2.new(0, 50, 0, 50)
Converted["_AnimationPacks"].Name = "AnimationPacks"
Converted["_AnimationPacks"].Parent = Converted["_CategorySelect"]
Converted["_UICorner4"].CornerRadius = UDim.new(0, 32)
Converted["_UICorner4"].Parent = Converted["_AnimationPacks"]
Converted["_UIPadding2"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding2"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding2"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding2"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding2"].Parent = Converted["_AnimationPacks"]
Converted["_Icon3"].Image = "rbxassetid://6567073136"
Converted["_Icon3"].ScaleType = Enum.ScaleType.Fit
Converted["_Icon3"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Icon3"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Icon3"].BackgroundTransparency = 1
Converted["_Icon3"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Icon3"].BorderSizePixel = 0
Converted["_Icon3"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Icon3"].Size = UDim2.new(0, 30, 0, 30)
Converted["_Icon3"].Name = "Icon"
Converted["_Icon3"].Parent = Converted["_AnimationPacks"]
Converted["_TextLabel1"].Font = Enum.Font.GothamBold
Converted["_TextLabel1"].Text = "AP"
Converted["_TextLabel1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel1"].TextScaled = true
Converted["_TextLabel1"].TextSize = 14
Converted["_TextLabel1"].TextWrapped = true
Converted["_TextLabel1"].AnchorPoint = Vector2.new(1, 1)
Converted["_TextLabel1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel1"].BackgroundTransparency = 1
Converted["_TextLabel1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel1"].BorderSizePixel = 0
Converted["_TextLabel1"].Position = UDim2.new(1, 0, 1, 3)
Converted["_TextLabel1"].Size = UDim2.new(0, 10, 0, 10)
Converted["_TextLabel1"].Parent = Converted["_AnimationPacks"]
Converted["_UIScale2"].Parent = Converted["_AnimationPacks"]
Converted["_UIStroke1"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke1"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke1"].Parent = Converted["_AnimationPacks"]
Converted["_Glass1"].Rotation = -22
Converted["_Glass1"].Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.46633419394493103, 0),
	NumberSequenceKeypoint.new(0.9476309418678284, 0.90625),
	NumberSequenceKeypoint.new(1, 1)
}
Converted["_Glass1"].Name = "Glass"
Converted["_Glass1"].Parent = Converted["_UIStroke1"]
Converted["_Settings"].Font = Enum.Font.Gotham
Converted["_Settings"].Text = ""
Converted["_Settings"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Settings"].TextScaled = true
Converted["_Settings"].TextSize = 14
Converted["_Settings"].TextWrapped = true
Converted["_Settings"].BackgroundColor3 = Color3.fromRGB(36, 36, 36)
Converted["_Settings"].BackgroundTransparency = 0.20000000298023224
Converted["_Settings"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Settings"].BorderSizePixel = 0
Converted["_Settings"].LayoutOrder = 3
Converted["_Settings"].Size = UDim2.new(0, 50, 0, 50)
Converted["_Settings"].Name = "Settings"
Converted["_Settings"].Parent = Converted["_CategorySelect"]
Converted["_UICorner5"].CornerRadius = UDim.new(0, 32)
Converted["_UICorner5"].Parent = Converted["_Settings"]
Converted["_UIPadding3"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding3"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding3"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding3"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding3"].Parent = Converted["_Settings"]
Converted["_Icon4"].Image = "rbxassetid://9405931578"
Converted["_Icon4"].ScaleType = Enum.ScaleType.Fit
Converted["_Icon4"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Icon4"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Icon4"].BackgroundTransparency = 1
Converted["_Icon4"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Icon4"].BorderSizePixel = 0
Converted["_Icon4"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Icon4"].Size = UDim2.new(0, 30, 0, 30)
Converted["_Icon4"].Name = "Icon"
Converted["_Icon4"].Parent = Converted["_Settings"]
Converted["_UIScale3"].Parent = Converted["_Settings"]
Converted["_UIStroke2"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke2"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke2"].Parent = Converted["_Settings"]
Converted["_Glass2"].Rotation = -22
Converted["_Glass2"].Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.46633419394493103, 0),
	NumberSequenceKeypoint.new(0.9476309418678284, 0.90625),
	NumberSequenceKeypoint.new(1, 1)
}
Converted["_Glass2"].Name = "Glass"
Converted["_Glass2"].Parent = Converted["_UIStroke2"]
Converted["_AnimationController"].Font = Enum.Font.Gotham
Converted["_AnimationController"].Text = ""
Converted["_AnimationController"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_AnimationController"].TextScaled = true
Converted["_AnimationController"].TextSize = 14
Converted["_AnimationController"].TextWrapped = true
Converted["_AnimationController"].BackgroundColor3 = Color3.fromRGB(36, 36, 36)
Converted["_AnimationController"].BackgroundTransparency = 0.20000000298023224
Converted["_AnimationController"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_AnimationController"].BorderSizePixel = 0
Converted["_AnimationController"].LayoutOrder = 2
Converted["_AnimationController"].Size = UDim2.new(0, 50, 0, 50)
Converted["_AnimationController"].Name = "AnimationController"
Converted["_AnimationController"].Parent = Converted["_CategorySelect"]
Converted["_UICorner6"].CornerRadius = UDim.new(0, 32)
Converted["_UICorner6"].Parent = Converted["_AnimationController"]
Converted["_UIPadding4"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding4"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding4"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding4"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding4"].Parent = Converted["_AnimationController"]
Converted["_Icon5"].Image = "rbxassetid://102776659673039"
Converted["_Icon5"].ScaleType = Enum.ScaleType.Fit
Converted["_Icon5"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Icon5"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Icon5"].BackgroundTransparency = 1
Converted["_Icon5"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Icon5"].BorderSizePixel = 0
Converted["_Icon5"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Icon5"].Size = UDim2.new(0, 30, 0, 30)
Converted["_Icon5"].Name = "Icon"
Converted["_Icon5"].Parent = Converted["_AnimationController"]
Converted["_UIScale4"].Parent = Converted["_AnimationController"]
Converted["_UIStroke3"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke3"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke3"].Parent = Converted["_AnimationController"]
Converted["_Glass3"].Rotation = -22
Converted["_Glass3"].Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.46633419394493103, 0),
	NumberSequenceKeypoint.new(0.9476309418678284, 0.90625),
	NumberSequenceKeypoint.new(1, 1)
}
Converted["_Glass3"].Name = "Glass"
Converted["_Glass3"].Parent = Converted["_UIStroke3"]
Converted["_ItemSelect"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ItemSelect"].BackgroundTransparency = 1
Converted["_ItemSelect"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ItemSelect"].BorderSizePixel = 0
Converted["_ItemSelect"].ClipsDescendants = true
Converted["_ItemSelect"].Size = UDim2.new(0, 0, 1, 0)
Converted["_ItemSelect"].Name = "ItemSelect"
Converted["_ItemSelect"].Parent = Converted["_Area"]
Converted["_UIFlexItem3"].FlexMode = Enum.UIFlexMode.Custom
Converted["_UIFlexItem3"].GrowRatio = 10
Converted["_UIFlexItem3"].Parent = Converted["_ItemSelect"]
Converted["_UIPageLayout"].EasingStyle = Enum.EasingStyle.Exponential
Converted["_UIPageLayout"].GamepadInputEnabled = false
Converted["_UIPageLayout"].Padding = UDim.new(0, 20)
Converted["_UIPageLayout"].ScrollWheelInputEnabled = false
Converted["_UIPageLayout"].TouchInputEnabled = false
Converted["_UIPageLayout"].TweenTime = 0.6000000238418579
Converted["_UIPageLayout"].FillDirection = Enum.FillDirection.Vertical
Converted["_UIPageLayout"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIPageLayout"].Parent = Converted["_ItemSelect"]
Converted["_Emotes1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Emotes1"].BackgroundTransparency = 1
Converted["_Emotes1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Emotes1"].BorderSizePixel = 0
Converted["_Emotes1"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Emotes1"].Name = "Emotes"
Converted["_Emotes1"].Parent = Converted["_ItemSelect"]
Converted["_UIListLayout4"].Padding = UDim.new(0, 8)
Converted["_UIListLayout4"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIListLayout4"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout4"].Parent = Converted["_Emotes1"]
Converted["_TextLabel2"].Font = Enum.Font.GothamBold
Converted["_TextLabel2"].Text = "Emotes"
Converted["_TextLabel2"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel2"].TextScaled = true
Converted["_TextLabel2"].TextSize = 14
Converted["_TextLabel2"].TextWrapped = true
Converted["_TextLabel2"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel2"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel2"].BackgroundTransparency = 1
Converted["_TextLabel2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel2"].BorderSizePixel = 0
Converted["_TextLabel2"].LayoutOrder = -10
Converted["_TextLabel2"].Size = UDim2.new(1, 0, 0, 20)
Converted["_TextLabel2"].Parent = Converted["_Emotes1"]
Converted["_Listing"].AutomaticCanvasSize = Enum.AutomaticSize.Y
Converted["_Listing"].CanvasSize = UDim2.new(0, 0, 0, 0)
Converted["_Listing"].ScrollBarThickness = 2
Converted["_Listing"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Listing"].BackgroundTransparency = 1
Converted["_Listing"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Listing"].BorderSizePixel = 0
Converted["_Listing"].Selectable = false
Converted["_Listing"].Size = UDim2.new(1, 0, 0, 0)
Converted["_Listing"].Name = "Listing"
Converted["_Listing"].Parent = Converted["_Emotes1"]
Converted["_UIFlexItem4"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem4"].Parent = Converted["_Listing"]
Converted["_UIGridLayout"].CellPadding = UDim2.new(0, 10, 0, 10)
Converted["_UIGridLayout"].CellSize = UDim2.new(0.400000006, -3, 0, 100)
Converted["_UIGridLayout"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIGridLayout"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIGridLayout"].Parent = Converted["_Listing"]
Converted["_UIPadding5"].PaddingBottom = UDim.new(0, 16)
Converted["_UIPadding5"].PaddingTop = UDim.new(0, 8)
Converted["_UIPadding5"].Parent = Converted["_Listing"]
Converted["_PaginationBar"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_PaginationBar"].BackgroundTransparency = 1
Converted["_PaginationBar"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_PaginationBar"].BorderSizePixel = 0
Converted["_PaginationBar"].Size = UDim2.new(1, 0, 0, 25)
Converted["_PaginationBar"].Name = "PaginationBar"
Converted["_PaginationBar"].Parent = Converted["_Emotes1"]
Converted["_UIListLayout5"].Padding = UDim.new(0, 8)
Converted["_UIListLayout5"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout5"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIListLayout5"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout5"].VerticalAlignment = Enum.VerticalAlignment.Center
Converted["_UIListLayout5"].Parent = Converted["_PaginationBar"]
Converted["_SamplePage"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_SamplePage"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_SamplePage"].BorderSizePixel = 0
Converted["_SamplePage"].LayoutOrder = 1
Converted["_SamplePage"].Size = UDim2.new(0, 25, 0, 25)
Converted["_SamplePage"].Visible = false
Converted["_SamplePage"].Name = "SamplePage"
Converted["_SamplePage"].Parent = Converted["_PaginationBar"]
Converted["_UICorner7"].CornerRadius = UDim.new(1, 0)
Converted["_UICorner7"].Parent = Converted["_SamplePage"]
Converted["_Label"].Font = Enum.Font.GothamBold
Converted["_Label"].Text = "1"
Converted["_Label"].TextColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Label"].TextScaled = true
Converted["_Label"].TextSize = 14
Converted["_Label"].TextTransparency = 1
Converted["_Label"].TextWrapped = true
Converted["_Label"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Label"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Label"].BackgroundTransparency = 1
Converted["_Label"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Label"].BorderSizePixel = 0
Converted["_Label"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Label"].Size = UDim2.new(1, -5, 1, -5)
Converted["_Label"].Name = "Label"
Converted["_Label"].Parent = Converted["_SamplePage"]
Converted["_UIScale5"].Scale = 0.30000001192092896
Converted["_UIScale5"].Parent = Converted["_SamplePage"]
Converted["_Next"].Font = Enum.Font.GothamBold
Converted["_Next"].Text = "Next"
Converted["_Next"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Next"].TextScaled = true
Converted["_Next"].TextSize = 14
Converted["_Next"].TextWrapped = true
Converted["_Next"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Next"].BackgroundTransparency = 0.75
Converted["_Next"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Next"].BorderSizePixel = 0
Converted["_Next"].LayoutOrder = 999
Converted["_Next"].Size = UDim2.new(0, 40, 0, 25)
Converted["_Next"].Name = "Next"
Converted["_Next"].Parent = Converted["_PaginationBar"]
Converted["_UIScale6"].Parent = Converted["_Next"]
Converted["_UIPadding6"].PaddingLeft = UDim.new(0, 4)
Converted["_UIPadding6"].PaddingRight = UDim.new(0, 4)
Converted["_UIPadding6"].Parent = Converted["_Next"]
Converted["_UICorner8"].Parent = Converted["_Next"]
Converted["_UIStroke4"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke4"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke4"].Parent = Converted["_Next"]
Converted["_UIPadding7"].PaddingBottom = UDim.new(0, 2)
Converted["_UIPadding7"].Parent = Converted["_PaginationBar"]
Converted["_Previous"].Font = Enum.Font.GothamBold
Converted["_Previous"].Text = "Previous"
Converted["_Previous"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Previous"].TextScaled = true
Converted["_Previous"].TextSize = 14
Converted["_Previous"].TextWrapped = true
Converted["_Previous"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Previous"].BackgroundTransparency = 0.75
Converted["_Previous"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Previous"].BorderSizePixel = 0
Converted["_Previous"].LayoutOrder = -999
Converted["_Previous"].Size = UDim2.new(0, 60, 0, 25)
Converted["_Previous"].Name = "Previous"
Converted["_Previous"].Parent = Converted["_PaginationBar"]
Converted["_UIScale7"].Scale = 1.0000000116860974e-07
Converted["_UIScale7"].Parent = Converted["_Previous"]
Converted["_UIPadding8"].PaddingLeft = UDim.new(0, 4)
Converted["_UIPadding8"].PaddingRight = UDim.new(0, 4)
Converted["_UIPadding8"].Parent = Converted["_Previous"]
Converted["_UICorner9"].Parent = Converted["_Previous"]
Converted["_UIStroke5"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke5"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke5"].Parent = Converted["_Previous"]
Converted["_ActionBar"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ActionBar"].BackgroundTransparency = 1
Converted["_ActionBar"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ActionBar"].BorderSizePixel = 0
Converted["_ActionBar"].LayoutOrder = -3
Converted["_ActionBar"].Size = UDim2.new(1, 0, 0, 25)
Converted["_ActionBar"].Name = "ActionBar"
Converted["_ActionBar"].Parent = Converted["_Emotes1"]
Converted["_Search"].Font = Enum.Font.Gotham
Converted["_Search"].PlaceholderText = "Search"
Converted["_Search"].Text = ""
Converted["_Search"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Search"].TextScaled = true
Converted["_Search"].TextSize = 14
Converted["_Search"].TextWrapped = true
Converted["_Search"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_Search"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Search"].BackgroundTransparency = 0.550000011920929
Converted["_Search"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Search"].BorderSizePixel = 0
Converted["_Search"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Search"].Name = "Search"
Converted["_Search"].Parent = Converted["_ActionBar"]
Converted["_UICorner10"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner10"].Parent = Converted["_Search"]
Converted["_UIPadding9"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding9"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding9"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding9"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding9"].Parent = Converted["_Search"]
Converted["_UISizeConstraint1"].MaxSize = Vector2.new(200, math.huge)
Converted["_UISizeConstraint1"].Parent = Converted["_Search"]
Converted["_Favorites"].Font = Enum.Font.Gotham
Converted["_Favorites"].Text = ""
Converted["_Favorites"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Favorites"].TextScaled = true
Converted["_Favorites"].TextSize = 14
Converted["_Favorites"].TextWrapped = true
Converted["_Favorites"].AnchorPoint = Vector2.new(1, 0)
Converted["_Favorites"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Favorites"].BackgroundTransparency = 0.550000011920929
Converted["_Favorites"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Favorites"].BorderSizePixel = 0
Converted["_Favorites"].ClipsDescendants = true
Converted["_Favorites"].LayoutOrder = 10
Converted["_Favorites"].Position = UDim2.new(1, -2, 0, 0)
Converted["_Favorites"].Size = UDim2.new(0, 75, 1, 0)
Converted["_Favorites"].Name = "Favorites"
Converted["_Favorites"].Parent = Converted["_ActionBar"]
Converted["_UICorner11"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner11"].Parent = Converted["_Favorites"]
Converted["_UIPadding10"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding10"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding10"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding10"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding10"].Parent = Converted["_Favorites"]
Converted["_UIStroke6"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke6"].Color = Color3.fromRGB(164, 179, 0)
Converted["_UIStroke6"].Parent = Converted["_Favorites"]
Converted["_Label1"].Font = Enum.Font.Gotham
Converted["_Label1"].Text = "Favorites"
Converted["_Label1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Label1"].TextScaled = true
Converted["_Label1"].TextSize = 14
Converted["_Label1"].TextWrapped = true
Converted["_Label1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Label1"].BackgroundTransparency = 1
Converted["_Label1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Label1"].BorderSizePixel = 0
Converted["_Label1"].LayoutOrder = 1
Converted["_Label1"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Label1"].Name = "Label"
Converted["_Label1"].Parent = Converted["_Favorites"]
Converted["_UIListLayout6"].Padding = UDim.new(0, 8)
Converted["_UIListLayout6"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout6"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout6"].Parent = Converted["_ActionBar"]
Converted["_Spacer"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Spacer"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Spacer"].BorderSizePixel = 0
Converted["_Spacer"].LayoutOrder = 9
Converted["_Spacer"].Name = "Spacer"
Converted["_Spacer"].Parent = Converted["_ActionBar"]
Converted["_UIFlexItem5"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem5"].Parent = Converted["_Spacer"]
Converted["_Spinner"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Spinner"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Spinner"].BackgroundTransparency = 1
Converted["_Spinner"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Spinner"].BorderSizePixel = 0
Converted["_Spinner"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Spinner"].Rotation = -180
Converted["_Spinner"].Size = UDim2.new(0, 0, 1, 0)
Converted["_Spinner"].Visible = false
Converted["_Spinner"].Name = "Spinner"
Converted["_Spinner"].Parent = Converted["_ActionBar"]
Converted["_UIAspectRatioConstraint"].AspectType = Enum.AspectType.ScaleWithParentSize
Converted["_UIAspectRatioConstraint"].DominantAxis = Enum.DominantAxis.Height
Converted["_UIAspectRatioConstraint"].Parent = Converted["_Spinner"]
Converted["_Spinner1"].Image = "rbxassetid://17119858971"
Converted["_Spinner1"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Spinner1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Spinner1"].BackgroundTransparency = 1
Converted["_Spinner1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Spinner1"].BorderSizePixel = 0
Converted["_Spinner1"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Spinner1"].Rotation = -180
Converted["_Spinner1"].Size = UDim2.new(0, 0, 1, 0)
Converted["_Spinner1"].Name = "Spinner"
Converted["_Spinner1"].Parent = Converted["_Spinner"]
Converted["_UIAspectRatioConstraint1"].AspectType = Enum.AspectType.ScaleWithParentSize
Converted["_UIAspectRatioConstraint1"].DominantAxis = Enum.DominantAxis.Height
Converted["_UIAspectRatioConstraint1"].Parent = Converted["_Spinner1"]
Converted["_TextLabel3"].Font = Enum.Font.Gotham
Converted["_TextLabel3"].Text = ""
Converted["_TextLabel3"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel3"].TextScaled = true
Converted["_TextLabel3"].TextSize = 14
Converted["_TextLabel3"].TextTransparency = 0.8500000238418579
Converted["_TextLabel3"].TextWrapped = true
Converted["_TextLabel3"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel3"].BackgroundTransparency = 1
Converted["_TextLabel3"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel3"].BorderSizePixel = 0
Converted["_TextLabel3"].LayoutOrder = 1
Converted["_TextLabel3"].Size = UDim2.new(0, 15, 1, 0)
Converted["_TextLabel3"].Parent = Converted["_ActionBar"]
Converted["_UIPadding11"].PaddingRight = UDim.new(0, 2)
Converted["_UIPadding11"].Parent = Converted["_ActionBar"]
Converted["_OldSwitch"].Font = Enum.Font.Gotham
Converted["_OldSwitch"].Text = ""
Converted["_OldSwitch"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_OldSwitch"].TextScaled = true
Converted["_OldSwitch"].TextSize = 14
Converted["_OldSwitch"].TextWrapped = true
Converted["_OldSwitch"].AnchorPoint = Vector2.new(1, 0)
Converted["_OldSwitch"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_OldSwitch"].BackgroundTransparency = 0.550000011920929
Converted["_OldSwitch"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_OldSwitch"].BorderSizePixel = 0
Converted["_OldSwitch"].ClipsDescendants = true
Converted["_OldSwitch"].LayoutOrder = 10
Converted["_OldSwitch"].Position = UDim2.new(1, -2, 0, 0)
Converted["_OldSwitch"].Size = UDim2.new(0, 100, 1, 0)
Converted["_OldSwitch"].Visible = false
Converted["_OldSwitch"].Name = "OldSwitch"
Converted["_OldSwitch"].Parent = Converted["_ActionBar"]
Converted["_UICorner12"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner12"].Parent = Converted["_OldSwitch"]
Converted["_UIPadding12"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding12"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding12"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding12"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding12"].Parent = Converted["_OldSwitch"]
Converted["_UIStroke7"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke7"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke7"].Parent = Converted["_OldSwitch"]
Converted["_UIPageLayout1"].EasingStyle = Enum.EasingStyle.Quart
Converted["_UIPageLayout1"].GamepadInputEnabled = false
Converted["_UIPageLayout1"].Padding = UDim.new(0, 8)
Converted["_UIPageLayout1"].ScrollWheelInputEnabled = false
Converted["_UIPageLayout1"].TouchInputEnabled = false
Converted["_UIPageLayout1"].TweenTime = 0.5
Converted["_UIPageLayout1"].FillDirection = Enum.FillDirection.Vertical
Converted["_UIPageLayout1"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIPageLayout1"].Parent = Converted["_OldSwitch"]
Converted["_UGCEmote"].Font = Enum.Font.Gotham
Converted["_UGCEmote"].Text = "UGC Emotes"
Converted["_UGCEmote"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_UGCEmote"].TextScaled = true
Converted["_UGCEmote"].TextSize = 14
Converted["_UGCEmote"].TextWrapped = true
Converted["_UGCEmote"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_UGCEmote"].BackgroundTransparency = 1
Converted["_UGCEmote"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_UGCEmote"].BorderSizePixel = 0
Converted["_UGCEmote"].LayoutOrder = 1
Converted["_UGCEmote"].Size = UDim2.new(1, 0, 1, 0)
Converted["_UGCEmote"].Name = "UGCEmote"
Converted["_UGCEmote"].Parent = Converted["_OldSwitch"]
Converted["_RobloxEmotes"].Font = Enum.Font.Gotham
Converted["_RobloxEmotes"].Text = "Roblox Emotes"
Converted["_RobloxEmotes"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_RobloxEmotes"].TextScaled = true
Converted["_RobloxEmotes"].TextSize = 14
Converted["_RobloxEmotes"].TextWrapped = true
Converted["_RobloxEmotes"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_RobloxEmotes"].BackgroundTransparency = 1
Converted["_RobloxEmotes"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_RobloxEmotes"].BorderSizePixel = 0
Converted["_RobloxEmotes"].Size = UDim2.new(1, 0, 1, 0)
Converted["_RobloxEmotes"].Name = "RobloxEmotes"
Converted["_RobloxEmotes"].Parent = Converted["_OldSwitch"]
Converted["_SwitchTabs"].AutomaticSize = Enum.AutomaticSize.X
Converted["_SwitchTabs"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_SwitchTabs"].BackgroundTransparency = 0.75
Converted["_SwitchTabs"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_SwitchTabs"].BorderSizePixel = 0
Converted["_SwitchTabs"].LayoutOrder = 10
Converted["_SwitchTabs"].Size = UDim2.new(0, 100, 1, 0)
Converted["_SwitchTabs"].Name = "SwitchTabs"
Converted["_SwitchTabs"].Parent = Converted["_ActionBar"]
Converted["_UICorner13"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner13"].Parent = Converted["_SwitchTabs"]
Converted["_UIPadding13"].PaddingBottom = UDim.new(0, 2)
Converted["_UIPadding13"].PaddingLeft = UDim.new(0, 2)
Converted["_UIPadding13"].PaddingRight = UDim.new(0, 2)
Converted["_UIPadding13"].PaddingTop = UDim.new(0, 2)
Converted["_UIPadding13"].Parent = Converted["_SwitchTabs"]
Converted["_UIStroke8"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke8"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke8"].Parent = Converted["_SwitchTabs"]
Converted["_Roblox"].Font = Enum.Font.Gotham
Converted["_Roblox"].Text = "Roblox"
Converted["_Roblox"].TextColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Roblox"].TextScaled = true
Converted["_Roblox"].TextSize = 14
Converted["_Roblox"].TextWrapped = true
Converted["_Roblox"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Roblox"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Roblox"].BorderSizePixel = 0
Converted["_Roblox"].Size = UDim2.new(0, 75, 1, 0)
Converted["_Roblox"].Name = "Roblox"
Converted["_Roblox"].Parent = Converted["_SwitchTabs"]
Converted["_UICorner14"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner14"].Parent = Converted["_Roblox"]
Converted["_UIPadding14"].PaddingBottom = UDim.new(0, 3)
Converted["_UIPadding14"].PaddingTop = UDim.new(0, 3)
Converted["_UIPadding14"].Parent = Converted["_Roblox"]
Converted["_UIListLayout7"].Padding = UDim.new(0, 2)
Converted["_UIListLayout7"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout7"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout7"].Parent = Converted["_SwitchTabs"]
Converted["_UGC"].Font = Enum.Font.Gotham
Converted["_UGC"].Text = "UGC"
Converted["_UGC"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_UGC"].TextScaled = true
Converted["_UGC"].TextSize = 14
Converted["_UGC"].TextWrapped = true
Converted["_UGC"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_UGC"].BackgroundTransparency = 1
Converted["_UGC"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_UGC"].BorderSizePixel = 0
Converted["_UGC"].Size = UDim2.new(0, 50, 1, 0)
Converted["_UGC"].Name = "UGC"
Converted["_UGC"].Parent = Converted["_SwitchTabs"]
Converted["_UICorner15"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner15"].Parent = Converted["_UGC"]
Converted["_UIPadding15"].PaddingBottom = UDim.new(0, 3)
Converted["_UIPadding15"].PaddingTop = UDim.new(0, 3)
Converted["_UIPadding15"].Parent = Converted["_UGC"]
Converted["_SearchSuggestion"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_SearchSuggestion"].BackgroundTransparency = 1
Converted["_SearchSuggestion"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_SearchSuggestion"].BorderSizePixel = 0
Converted["_SearchSuggestion"].ClipsDescendants = true
Converted["_SearchSuggestion"].LayoutOrder = -2
Converted["_SearchSuggestion"].Size = UDim2.new(1, 0, 0, 0)
Converted["_SearchSuggestion"].Name = "SearchSuggestion"
Converted["_SearchSuggestion"].Parent = Converted["_Emotes1"]
Converted["_UIListLayout8"].Padding = UDim.new(0, 8)
Converted["_UIListLayout8"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout8"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout8"].Parent = Converted["_SearchSuggestion"]
Converted["_UIPadding16"].PaddingBottom = UDim.new(0, 4)
Converted["_UIPadding16"].PaddingLeft = UDim.new(0, 3)
Converted["_UIPadding16"].PaddingRight = UDim.new(0, 3)
Converted["_UIPadding16"].PaddingTop = UDim.new(0, 1)
Converted["_UIPadding16"].Parent = Converted["_SearchSuggestion"]
Converted["_ChipSample"].AutomaticSize = Enum.AutomaticSize.X
Converted["_ChipSample"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ChipSample"].BackgroundTransparency = 1
Converted["_ChipSample"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ChipSample"].BorderSizePixel = 0
Converted["_ChipSample"].Size = UDim2.new(0, 0, 0, 25)
Converted["_ChipSample"].Visible = false
Converted["_ChipSample"].Name = "ChipSample"
Converted["_ChipSample"].Parent = Converted["_SearchSuggestion"]
Converted["_Clickable"].Font = Enum.Font.Gotham
Converted["_Clickable"].Text = ""
Converted["_Clickable"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Clickable"].TextScaled = true
Converted["_Clickable"].TextSize = 14
Converted["_Clickable"].TextWrapped = true
Converted["_Clickable"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Clickable"].BackgroundTransparency = 0.550000011920929
Converted["_Clickable"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Clickable"].BorderSizePixel = 0
Converted["_Clickable"].ClipsDescendants = true
Converted["_Clickable"].LayoutOrder = 10
Converted["_Clickable"].Position = UDim2.new(0, 0, 0, 25)
Converted["_Clickable"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Clickable"].Name = "Clickable"
Converted["_Clickable"].Parent = Converted["_ChipSample"]
Converted["_UICorner16"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner16"].Parent = Converted["_Clickable"]
Converted["_UIPadding17"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding17"].PaddingLeft = UDim.new(0, 9)
Converted["_UIPadding17"].PaddingRight = UDim.new(0, 9)
Converted["_UIPadding17"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding17"].Parent = Converted["_Clickable"]
Converted["_UIStroke9"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke9"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke9"].Parent = Converted["_Clickable"]
Converted["_Label2"].Font = Enum.Font.Gotham
Converted["_Label2"].Text = "suggestion"
Converted["_Label2"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Label2"].TextScaled = true
Converted["_Label2"].TextSize = 14
Converted["_Label2"].TextWrapped = true
Converted["_Label2"].AutomaticSize = Enum.AutomaticSize.X
Converted["_Label2"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Label2"].BackgroundTransparency = 1
Converted["_Label2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Label2"].BorderSizePixel = 0
Converted["_Label2"].LayoutOrder = 1
Converted["_Label2"].Size = UDim2.new(0, 0, 1, 0)
Converted["_Label2"].Name = "Label"
Converted["_Label2"].Parent = Converted["_Clickable"]
Converted["_FavoritesSection"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_FavoritesSection"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_FavoritesSection"].BorderSizePixel = 0
Converted["_FavoritesSection"].ClipsDescendants = true
Converted["_FavoritesSection"].LayoutOrder = -1
Converted["_FavoritesSection"].Size = UDim2.new(1, -4, 0, 0)
Converted["_FavoritesSection"].Name = "FavoritesSection"
Converted["_FavoritesSection"].Parent = Converted["_Emotes1"]
Converted["_UIGradient1"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 0))
}
Converted["_UIGradient1"].Rotation = -90
Converted["_UIGradient1"].Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.7562500238418579),
	NumberSequenceKeypoint.new(1, 1)
}
Converted["_UIGradient1"].Parent = Converted["_FavoritesSection"]
Converted["_UIStroke10"].Color = Color3.fromRGB(255, 200, 0)
Converted["_UIStroke10"].Thickness = 0
Converted["_UIStroke10"].Parent = Converted["_FavoritesSection"]
Converted["_UICorner17"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner17"].Parent = Converted["_FavoritesSection"]
Converted["_UIListLayout9"].Padding = UDim.new(0, 4)
Converted["_UIListLayout9"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout9"].Parent = Converted["_FavoritesSection"]
Converted["_TextLabel4"].Font = Enum.Font.GothamBold
Converted["_TextLabel4"].Text = "Favorites"
Converted["_TextLabel4"].TextColor3 = Color3.fromRGB(255, 200, 0)
Converted["_TextLabel4"].TextScaled = true
Converted["_TextLabel4"].TextSize = 14
Converted["_TextLabel4"].TextWrapped = true
Converted["_TextLabel4"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel4"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel4"].BackgroundTransparency = 1
Converted["_TextLabel4"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel4"].BorderSizePixel = 0
Converted["_TextLabel4"].Size = UDim2.new(0, 200, 0, 15)
Converted["_TextLabel4"].Parent = Converted["_FavoritesSection"]
Converted["_UIPadding18"].PaddingBottom = UDim.new(0, 8)
Converted["_UIPadding18"].PaddingLeft = UDim.new(0, 16)
Converted["_UIPadding18"].PaddingRight = UDim.new(0, 16)
Converted["_UIPadding18"].PaddingTop = UDim.new(0, 8)
Converted["_UIPadding18"].Parent = Converted["_FavoritesSection"]
Converted["_Listing1"].AutomaticCanvasSize = Enum.AutomaticSize.X
Converted["_Listing1"].CanvasSize = UDim2.new(0, 0, 0, 0)
Converted["_Listing1"].ScrollBarThickness = 2
Converted["_Listing1"].Active = true
Converted["_Listing1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Listing1"].BackgroundTransparency = 1
Converted["_Listing1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Listing1"].BorderSizePixel = 0
Converted["_Listing1"].Size = UDim2.new(1, 0, 0, 0)
Converted["_Listing1"].Name = "Listing"
Converted["_Listing1"].Parent = Converted["_FavoritesSection"]
Converted["_UIFlexItem6"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem6"].Parent = Converted["_Listing1"]
Converted["_UIListLayout10"].Padding = UDim.new(0, 8)
Converted["_UIListLayout10"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout10"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout10"].Parent = Converted["_Listing1"]
Converted["_UIPadding19"].PaddingBottom = UDim.new(0, 4)
Converted["_UIPadding19"].PaddingTop = UDim.new(0, 4)
Converted["_UIPadding19"].Parent = Converted["_Listing1"]
Converted["_AnimationPacks1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_AnimationPacks1"].BackgroundTransparency = 1
Converted["_AnimationPacks1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_AnimationPacks1"].BorderSizePixel = 0
Converted["_AnimationPacks1"].LayoutOrder = 1
Converted["_AnimationPacks1"].Size = UDim2.new(1, 0, 1, 0)
Converted["_AnimationPacks1"].Name = "AnimationPacks"
Converted["_AnimationPacks1"].Parent = Converted["_ItemSelect"]
Converted["_UIListLayout11"].Padding = UDim.new(0, 8)
Converted["_UIListLayout11"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIListLayout11"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout11"].Parent = Converted["_AnimationPacks1"]
Converted["_TextLabel5"].Font = Enum.Font.GothamBold
Converted["_TextLabel5"].Text = "Animation packs"
Converted["_TextLabel5"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel5"].TextScaled = true
Converted["_TextLabel5"].TextSize = 14
Converted["_TextLabel5"].TextWrapped = true
Converted["_TextLabel5"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel5"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel5"].BackgroundTransparency = 1
Converted["_TextLabel5"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel5"].BorderSizePixel = 0
Converted["_TextLabel5"].LayoutOrder = -10
Converted["_TextLabel5"].Size = UDim2.new(1, 0, 0, 20)
Converted["_TextLabel5"].Parent = Converted["_AnimationPacks1"]
Converted["_Listing2"].AutomaticCanvasSize = Enum.AutomaticSize.Y
Converted["_Listing2"].CanvasSize = UDim2.new(0, 0, 0, 0)
Converted["_Listing2"].ScrollBarThickness = 2
Converted["_Listing2"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Listing2"].BackgroundTransparency = 1
Converted["_Listing2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Listing2"].BorderSizePixel = 0
Converted["_Listing2"].Selectable = false
Converted["_Listing2"].Size = UDim2.new(1, 0, 0, 0)
Converted["_Listing2"].Name = "Listing"
Converted["_Listing2"].Parent = Converted["_AnimationPacks1"]
Converted["_UIFlexItem7"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem7"].Parent = Converted["_Listing2"]
Converted["_UIGridLayout1"].CellPadding = UDim2.new(0, 10, 0, 10)
Converted["_UIGridLayout1"].CellSize = UDim2.new(0.300000012, -3, 0, 100)
Converted["_UIGridLayout1"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIGridLayout1"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIGridLayout1"].Parent = Converted["_Listing2"]
Converted["_UIPadding20"].PaddingBottom = UDim.new(0, 16)
Converted["_UIPadding20"].PaddingTop = UDim.new(0, 8)
Converted["_UIPadding20"].Parent = Converted["_Listing2"]
Converted["_PaginationBar1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_PaginationBar1"].BackgroundTransparency = 1
Converted["_PaginationBar1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_PaginationBar1"].BorderSizePixel = 0
Converted["_PaginationBar1"].Size = UDim2.new(1, 0, 0, 25)
Converted["_PaginationBar1"].Name = "PaginationBar"
Converted["_PaginationBar1"].Parent = Converted["_AnimationPacks1"]
Converted["_UIListLayout12"].Padding = UDim.new(0, 8)
Converted["_UIListLayout12"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout12"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout12"].VerticalAlignment = Enum.VerticalAlignment.Center
Converted["_UIListLayout12"].Parent = Converted["_PaginationBar1"]
Converted["_Previous1"].Font = Enum.Font.GothamBold
Converted["_Previous1"].Text = "<"
Converted["_Previous1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Previous1"].TextScaled = true
Converted["_Previous1"].TextSize = 14
Converted["_Previous1"].TextWrapped = true
Converted["_Previous1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Previous1"].BackgroundTransparency = 1
Converted["_Previous1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Previous1"].BorderSizePixel = 0
Converted["_Previous1"].LayoutOrder = -999
Converted["_Previous1"].Size = UDim2.new(0, 25, 0, 25)
Converted["_Previous1"].Name = "Previous"
Converted["_Previous1"].Parent = Converted["_PaginationBar1"]
Converted["_UIScale8"].Scale = 1.0000000116860974e-07
Converted["_UIScale8"].Parent = Converted["_Previous1"]
Converted["_SamplePage1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_SamplePage1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_SamplePage1"].BorderSizePixel = 0
Converted["_SamplePage1"].LayoutOrder = 1
Converted["_SamplePage1"].Size = UDim2.new(0, 25, 0, 25)
Converted["_SamplePage1"].Visible = false
Converted["_SamplePage1"].Name = "SamplePage"
Converted["_SamplePage1"].Parent = Converted["_PaginationBar1"]
Converted["_UICorner18"].CornerRadius = UDim.new(1, 0)
Converted["_UICorner18"].Parent = Converted["_SamplePage1"]
Converted["_Label3"].Font = Enum.Font.GothamBold
Converted["_Label3"].Text = "1"
Converted["_Label3"].TextColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Label3"].TextScaled = true
Converted["_Label3"].TextSize = 14
Converted["_Label3"].TextWrapped = true
Converted["_Label3"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Label3"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Label3"].BackgroundTransparency = 1
Converted["_Label3"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Label3"].BorderSizePixel = 0
Converted["_Label3"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Label3"].Size = UDim2.new(1, -5, 1, -5)
Converted["_Label3"].Name = "Label"
Converted["_Label3"].Parent = Converted["_SamplePage1"]
Converted["_UIScale9"].Parent = Converted["_SamplePage1"]
Converted["_Next1"].Font = Enum.Font.GothamBold
Converted["_Next1"].Text = ">"
Converted["_Next1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Next1"].TextScaled = true
Converted["_Next1"].TextSize = 14
Converted["_Next1"].TextWrapped = true
Converted["_Next1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Next1"].BackgroundTransparency = 1
Converted["_Next1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Next1"].BorderSizePixel = 0
Converted["_Next1"].LayoutOrder = 999
Converted["_Next1"].Size = UDim2.new(0, 25, 0, 25)
Converted["_Next1"].Name = "Next"
Converted["_Next1"].Parent = Converted["_PaginationBar1"]
Converted["_UIScale10"].Parent = Converted["_Next1"]
Converted["_PackEditor"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_PackEditor"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_PackEditor"].BorderSizePixel = 0
Converted["_PackEditor"].ClipsDescendants = true
Converted["_PackEditor"].LayoutOrder = -1
Converted["_PackEditor"].Size = UDim2.new(1, -4, 0, 125)
Converted["_PackEditor"].Name = "PackEditor"
Converted["_PackEditor"].Parent = Converted["_AnimationPacks1"]
Converted["_UIGradient2"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
}
Converted["_UIGradient2"].Rotation = -90
Converted["_UIGradient2"].Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.7562500238418579),
	NumberSequenceKeypoint.new(1, 1)
}
Converted["_UIGradient2"].Parent = Converted["_PackEditor"]
Converted["_UIStroke11"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke11"].Parent = Converted["_PackEditor"]
Converted["_UICorner19"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner19"].Parent = Converted["_PackEditor"]
Converted["_UIListLayout13"].Padding = UDim.new(0, 4)
Converted["_UIListLayout13"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout13"].Parent = Converted["_PackEditor"]
Converted["_TextLabel6"].Font = Enum.Font.GothamBold
Converted["_TextLabel6"].Text = "Pack Editor"
Converted["_TextLabel6"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel6"].TextScaled = true
Converted["_TextLabel6"].TextSize = 14
Converted["_TextLabel6"].TextWrapped = true
Converted["_TextLabel6"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel6"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel6"].BackgroundTransparency = 1
Converted["_TextLabel6"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel6"].BorderSizePixel = 0
Converted["_TextLabel6"].Size = UDim2.new(0, 200, 0, 15)
Converted["_TextLabel6"].Parent = Converted["_PackEditor"]
Converted["_UIPadding21"].PaddingBottom = UDim.new(0, 8)
Converted["_UIPadding21"].PaddingLeft = UDim.new(0, 16)
Converted["_UIPadding21"].PaddingRight = UDim.new(0, 16)
Converted["_UIPadding21"].PaddingTop = UDim.new(0, 8)
Converted["_UIPadding21"].Parent = Converted["_PackEditor"]
Converted["_Listing3"].AutomaticCanvasSize = Enum.AutomaticSize.X
Converted["_Listing3"].CanvasSize = UDim2.new(0, 0, 0, 0)
Converted["_Listing3"].ScrollBarThickness = 2
Converted["_Listing3"].Active = true
Converted["_Listing3"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Listing3"].BackgroundTransparency = 1
Converted["_Listing3"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Listing3"].BorderSizePixel = 0
Converted["_Listing3"].Size = UDim2.new(1, 0, 0, 0)
Converted["_Listing3"].Name = "Listing"
Converted["_Listing3"].Parent = Converted["_PackEditor"]
Converted["_UIFlexItem8"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem8"].Parent = Converted["_Listing3"]
Converted["_UIListLayout14"].Padding = UDim.new(0, 8)
Converted["_UIListLayout14"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout14"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout14"].Parent = Converted["_Listing3"]
Converted["_UIPadding22"].PaddingBottom = UDim.new(0, 4)
Converted["_UIPadding22"].PaddingTop = UDim.new(0, 4)
Converted["_UIPadding22"].Parent = Converted["_Listing3"]
Converted["_PackEditorUpdate"].Name = "PackEditorUpdate"
Converted["_PackEditorUpdate"].Parent = Converted["_AnimationPacks1"]
Converted["_Settings1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Settings1"].BackgroundTransparency = 1
Converted["_Settings1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Settings1"].BorderSizePixel = 0
Converted["_Settings1"].LayoutOrder = 3
Converted["_Settings1"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Settings1"].Name = "Settings"
Converted["_Settings1"].Parent = Converted["_ItemSelect"]
Converted["_UIListLayout15"].Padding = UDim.new(0, 8)
Converted["_UIListLayout15"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout15"].Parent = Converted["_Settings1"]
Converted["_Listing4"].AutomaticCanvasSize = Enum.AutomaticSize.Y
Converted["_Listing4"].CanvasSize = UDim2.new(0, 0, 0, 0)
Converted["_Listing4"].ScrollBarThickness = 2
Converted["_Listing4"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Listing4"].BackgroundTransparency = 1
Converted["_Listing4"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Listing4"].BorderSizePixel = 0
Converted["_Listing4"].Selectable = false
Converted["_Listing4"].Size = UDim2.new(1, 0, 0, 0)
Converted["_Listing4"].Name = "Listing"
Converted["_Listing4"].Parent = Converted["_Settings1"]
Converted["_UIFlexItem9"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem9"].Parent = Converted["_Listing4"]
Converted["_UIPadding23"].PaddingBottom = UDim.new(0, 16)
Converted["_UIPadding23"].PaddingTop = UDim.new(0, 8)
Converted["_UIPadding23"].Parent = Converted["_Listing4"]
Converted["_UIListLayout16"].Padding = UDim.new(0, 8)
Converted["_UIListLayout16"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout16"].Parent = Converted["_Listing4"]
Converted["_Samples"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Samples"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Samples"].BorderSizePixel = 0
Converted["_Samples"].Size = UDim2.new(0, 100, 0, 100)
Converted["_Samples"].Visible = false
Converted["_Samples"].Name = "Samples"
Converted["_Samples"].Parent = Converted["_Settings1"]
Converted["_TextLabel7"].Font = Enum.Font.GothamBold
Converted["_TextLabel7"].Text = "Sample"
Converted["_TextLabel7"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel7"].TextScaled = true
Converted["_TextLabel7"].TextSize = 14
Converted["_TextLabel7"].TextWrapped = true
Converted["_TextLabel7"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel7"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel7"].BackgroundTransparency = 1
Converted["_TextLabel7"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel7"].BorderSizePixel = 0
Converted["_TextLabel7"].Size = UDim2.new(1, 0, 0, 15)
Converted["_TextLabel7"].Parent = Converted["_Samples"]
Converted["_Toggle"].Text = ""
Converted["_Toggle"].Active = false
Converted["_Toggle"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Toggle"].BackgroundTransparency = 1
Converted["_Toggle"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Toggle"].BorderSizePixel = 0
Converted["_Toggle"].Selectable = false
Converted["_Toggle"].Size = UDim2.new(1, 0, 0, 25)
Converted["_Toggle"].Name = "Toggle"
Converted["_Toggle"].Parent = Converted["_Samples"]
Converted["_ToggleTrack"].BackgroundColor3 = Color3.fromRGB(48, 48, 48)
Converted["_ToggleTrack"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ToggleTrack"].BorderSizePixel = 0
Converted["_ToggleTrack"].Size = UDim2.new(0, 50, 1, 0)
Converted["_ToggleTrack"].Name = "ToggleTrack"
Converted["_ToggleTrack"].Parent = Converted["_Toggle"]
Converted["_UICorner20"].CornerRadius = UDim.new(1, 0)
Converted["_UICorner20"].Parent = Converted["_ToggleTrack"]
Converted["_Ball"].BackgroundColor3 = Color3.fromRGB(220, 220, 220)
Converted["_Ball"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Ball"].BorderSizePixel = 0
Converted["_Ball"].Size = UDim2.new(0, 0, 1, 0)
Converted["_Ball"].Name = "Ball"
Converted["_Ball"].Parent = Converted["_ToggleTrack"]
Converted["_UIAspectRatioConstraint2"].AspectType = Enum.AspectType.ScaleWithParentSize
Converted["_UIAspectRatioConstraint2"].DominantAxis = Enum.DominantAxis.Height
Converted["_UIAspectRatioConstraint2"].Parent = Converted["_Ball"]
Converted["_UICorner21"].CornerRadius = UDim.new(1, 0)
Converted["_UICorner21"].Parent = Converted["_Ball"]
Converted["_UIPadding24"].PaddingBottom = UDim.new(0, 3)
Converted["_UIPadding24"].PaddingLeft = UDim.new(0, 3)
Converted["_UIPadding24"].PaddingRight = UDim.new(0, 3)
Converted["_UIPadding24"].PaddingTop = UDim.new(0, 3)
Converted["_UIPadding24"].Parent = Converted["_ToggleTrack"]
Converted["_UIListLayout17"].Padding = UDim.new(0, 8)
Converted["_UIListLayout17"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout17"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout17"].VerticalAlignment = Enum.VerticalAlignment.Center
Converted["_UIListLayout17"].Parent = Converted["_Toggle"]
Converted["_Label4"].Font = Enum.Font.Gotham
Converted["_Label4"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Label4"].TextScaled = true
Converted["_Label4"].TextSize = 14
Converted["_Label4"].TextWrapped = true
Converted["_Label4"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_Label4"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Label4"].BackgroundTransparency = 1
Converted["_Label4"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Label4"].BorderSizePixel = 0
Converted["_Label4"].Size = UDim2.new(0, 200, 1, -10)
Converted["_Label4"].Name = "Label"
Converted["_Label4"].Parent = Converted["_Toggle"]
Converted["_Select"].AutomaticSize = Enum.AutomaticSize.X
Converted["_Select"].BackgroundColor3 = Color3.fromRGB(36, 36, 36)
Converted["_Select"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Select"].BorderSizePixel = 0
Converted["_Select"].Size = UDim2.new(0, 0, 0, 35)
Converted["_Select"].Name = "Select"
Converted["_Select"].Parent = Converted["_Samples"]
Converted["_UIListLayout18"].Padding = UDim.new(0, 4)
Converted["_UIListLayout18"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout18"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout18"].Parent = Converted["_Select"]
Converted["_UIPadding25"].PaddingBottom = UDim.new(0, 4)
Converted["_UIPadding25"].PaddingLeft = UDim.new(0, 4)
Converted["_UIPadding25"].PaddingRight = UDim.new(0, 4)
Converted["_UIPadding25"].PaddingTop = UDim.new(0, 4)
Converted["_UIPadding25"].Parent = Converted["_Select"]
Converted["_UICorner22"].Parent = Converted["_Select"]
Converted["_SelectButton"].Font = Enum.Font.Gotham
Converted["_SelectButton"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_SelectButton"].TextSize = 14
Converted["_SelectButton"].AutomaticSize = Enum.AutomaticSize.X
Converted["_SelectButton"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_SelectButton"].BackgroundTransparency = 1
Converted["_SelectButton"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_SelectButton"].BorderSizePixel = 0
Converted["_SelectButton"].Size = UDim2.new(0, 0, 1, 0)
Converted["_SelectButton"].Name = "SelectButton"
Converted["_SelectButton"].Parent = Converted["_Samples"]
Converted["_UICorner23"].Parent = Converted["_SelectButton"]
Converted["_UIPadding26"].PaddingBottom = UDim.new(0, 3)
Converted["_UIPadding26"].PaddingLeft = UDim.new(0, 8)
Converted["_UIPadding26"].PaddingRight = UDim.new(0, 8)
Converted["_UIPadding26"].PaddingTop = UDim.new(0, 3)
Converted["_UIPadding26"].Parent = Converted["_SelectButton"]
Converted["_TextLabel8"].Font = Enum.Font.GothamBold
Converted["_TextLabel8"].Text = "Settings"
Converted["_TextLabel8"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel8"].TextScaled = true
Converted["_TextLabel8"].TextSize = 14
Converted["_TextLabel8"].TextWrapped = true
Converted["_TextLabel8"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel8"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel8"].BackgroundTransparency = 1
Converted["_TextLabel8"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel8"].BorderSizePixel = 0
Converted["_TextLabel8"].LayoutOrder = -10
Converted["_TextLabel8"].Size = UDim2.new(1, 0, 0, 20)
Converted["_TextLabel8"].Parent = Converted["_Settings1"]
Converted["_AnimationController1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_AnimationController1"].BackgroundTransparency = 1
Converted["_AnimationController1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_AnimationController1"].BorderSizePixel = 0
Converted["_AnimationController1"].LayoutOrder = 2
Converted["_AnimationController1"].Size = UDim2.new(1, 0, 1, 0)
Converted["_AnimationController1"].Name = "AnimationController"
Converted["_AnimationController1"].Parent = Converted["_ItemSelect"]
Converted["_DockerSwitch"].Font = Enum.Font.Gotham
Converted["_DockerSwitch"].Text = "Undock"
Converted["_DockerSwitch"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_DockerSwitch"].TextScaled = true
Converted["_DockerSwitch"].TextSize = 14
Converted["_DockerSwitch"].TextWrapped = true
Converted["_DockerSwitch"].AnchorPoint = Vector2.new(1, 0)
Converted["_DockerSwitch"].BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Converted["_DockerSwitch"].BackgroundTransparency = 0.5
Converted["_DockerSwitch"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_DockerSwitch"].BorderSizePixel = 0
Converted["_DockerSwitch"].Position = UDim2.new(1, -2, 0, 2)
Converted["_DockerSwitch"].Size = UDim2.new(0, 50, 0, 20)
Converted["_DockerSwitch"].Name = "DockerSwitch"
Converted["_DockerSwitch"].Parent = Converted["_AnimationController1"]
Converted["_UICorner24"].Parent = Converted["_DockerSwitch"]
Converted["_UIPadding27"].PaddingBottom = UDim.new(0, 4)
Converted["_UIPadding27"].PaddingLeft = UDim.new(0, 4)
Converted["_UIPadding27"].PaddingRight = UDim.new(0, 4)
Converted["_UIPadding27"].PaddingTop = UDim.new(0, 4)
Converted["_UIPadding27"].Parent = Converted["_DockerSwitch"]
Converted["_UIStroke12"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke12"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke12"].Parent = Converted["_DockerSwitch"]
Converted["_Dockable"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Dockable"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Dockable"].BackgroundTransparency = 1
Converted["_Dockable"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Dockable"].BorderSizePixel = 0
Converted["_Dockable"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Dockable"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Dockable"].Name = "Dockable"
Converted["_Dockable"].Parent = Converted["_AnimationController1"]
Converted["_UIListLayout19"].Padding = UDim.new(0, 8)
Converted["_UIListLayout19"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIListLayout19"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout19"].Parent = Converted["_Dockable"]
Converted["_Samples1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Samples1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Samples1"].BorderSizePixel = 0
Converted["_Samples1"].Size = UDim2.new(0, 100, 0, 100)
Converted["_Samples1"].Visible = false
Converted["_Samples1"].Name = "Samples"
Converted["_Samples1"].Parent = Converted["_Dockable"]
Converted["_TextLabel9"].Font = Enum.Font.GothamBold
Converted["_TextLabel9"].Text = "Sample"
Converted["_TextLabel9"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel9"].TextScaled = true
Converted["_TextLabel9"].TextSize = 14
Converted["_TextLabel9"].TextWrapped = true
Converted["_TextLabel9"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel9"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel9"].BackgroundTransparency = 1
Converted["_TextLabel9"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel9"].BorderSizePixel = 0
Converted["_TextLabel9"].Size = UDim2.new(1, 0, 0, 15)
Converted["_TextLabel9"].Parent = Converted["_Samples1"]
Converted["_Toggle1"].Text = ""
Converted["_Toggle1"].Active = false
Converted["_Toggle1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Toggle1"].BackgroundTransparency = 1
Converted["_Toggle1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Toggle1"].BorderSizePixel = 0
Converted["_Toggle1"].Selectable = false
Converted["_Toggle1"].Size = UDim2.new(1, 0, 0, 25)
Converted["_Toggle1"].Name = "Toggle"
Converted["_Toggle1"].Parent = Converted["_Samples1"]
Converted["_ToggleTrack1"].BackgroundColor3 = Color3.fromRGB(48, 48, 48)
Converted["_ToggleTrack1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ToggleTrack1"].BorderSizePixel = 0
Converted["_ToggleTrack1"].Size = UDim2.new(0, 50, 1, 0)
Converted["_ToggleTrack1"].Name = "ToggleTrack"
Converted["_ToggleTrack1"].Parent = Converted["_Toggle1"]
Converted["_UICorner25"].CornerRadius = UDim.new(1, 0)
Converted["_UICorner25"].Parent = Converted["_ToggleTrack1"]
Converted["_Ball1"].BackgroundColor3 = Color3.fromRGB(220, 220, 220)
Converted["_Ball1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Ball1"].BorderSizePixel = 0
Converted["_Ball1"].Size = UDim2.new(0, 0, 1, 0)
Converted["_Ball1"].Name = "Ball"
Converted["_Ball1"].Parent = Converted["_ToggleTrack1"]
Converted["_UIAspectRatioConstraint3"].AspectType = Enum.AspectType.ScaleWithParentSize
Converted["_UIAspectRatioConstraint3"].DominantAxis = Enum.DominantAxis.Height
Converted["_UIAspectRatioConstraint3"].Parent = Converted["_Ball1"]
Converted["_UICorner26"].CornerRadius = UDim.new(1, 0)
Converted["_UICorner26"].Parent = Converted["_Ball1"]
Converted["_UIPadding28"].PaddingBottom = UDim.new(0, 3)
Converted["_UIPadding28"].PaddingLeft = UDim.new(0, 3)
Converted["_UIPadding28"].PaddingRight = UDim.new(0, 3)
Converted["_UIPadding28"].PaddingTop = UDim.new(0, 3)
Converted["_UIPadding28"].Parent = Converted["_ToggleTrack1"]
Converted["_UIListLayout20"].Padding = UDim.new(0, 8)
Converted["_UIListLayout20"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout20"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout20"].VerticalAlignment = Enum.VerticalAlignment.Center
Converted["_UIListLayout20"].Parent = Converted["_Toggle1"]
Converted["_Label5"].Font = Enum.Font.Gotham
Converted["_Label5"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Label5"].TextScaled = true
Converted["_Label5"].TextSize = 14
Converted["_Label5"].TextWrapped = true
Converted["_Label5"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_Label5"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Label5"].BackgroundTransparency = 1
Converted["_Label5"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Label5"].BorderSizePixel = 0
Converted["_Label5"].Size = UDim2.new(0, 200, 1, -10)
Converted["_Label5"].Name = "Label"
Converted["_Label5"].Parent = Converted["_Toggle1"]
Converted["_Select1"].AutomaticSize = Enum.AutomaticSize.X
Converted["_Select1"].BackgroundColor3 = Color3.fromRGB(36, 36, 36)
Converted["_Select1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Select1"].BorderSizePixel = 0
Converted["_Select1"].Size = UDim2.new(0, 0, 0, 35)
Converted["_Select1"].Name = "Select"
Converted["_Select1"].Parent = Converted["_Samples1"]
Converted["_UIListLayout21"].Padding = UDim.new(0, 4)
Converted["_UIListLayout21"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout21"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout21"].Parent = Converted["_Select1"]
Converted["_UIPadding29"].PaddingBottom = UDim.new(0, 4)
Converted["_UIPadding29"].PaddingLeft = UDim.new(0, 4)
Converted["_UIPadding29"].PaddingRight = UDim.new(0, 4)
Converted["_UIPadding29"].PaddingTop = UDim.new(0, 4)
Converted["_UIPadding29"].Parent = Converted["_Select1"]
Converted["_UICorner27"].Parent = Converted["_Select1"]
Converted["_SelectButton1"].Font = Enum.Font.Gotham
Converted["_SelectButton1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_SelectButton1"].TextSize = 14
Converted["_SelectButton1"].AutomaticSize = Enum.AutomaticSize.X
Converted["_SelectButton1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_SelectButton1"].BackgroundTransparency = 1
Converted["_SelectButton1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_SelectButton1"].BorderSizePixel = 0
Converted["_SelectButton1"].Size = UDim2.new(0, 0, 1, 0)
Converted["_SelectButton1"].Name = "SelectButton"
Converted["_SelectButton1"].Parent = Converted["_Samples1"]
Converted["_UICorner28"].Parent = Converted["_SelectButton1"]
Converted["_UIPadding30"].PaddingBottom = UDim.new(0, 3)
Converted["_UIPadding30"].PaddingLeft = UDim.new(0, 8)
Converted["_UIPadding30"].PaddingRight = UDim.new(0, 8)
Converted["_UIPadding30"].PaddingTop = UDim.new(0, 3)
Converted["_UIPadding30"].Parent = Converted["_SelectButton1"]
Converted["_TextLabel10"].Font = Enum.Font.GothamBold
Converted["_TextLabel10"].Text = "Animation controller"
Converted["_TextLabel10"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel10"].TextScaled = true
Converted["_TextLabel10"].TextSize = 14
Converted["_TextLabel10"].TextWrapped = true
Converted["_TextLabel10"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel10"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel10"].BackgroundTransparency = 1
Converted["_TextLabel10"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel10"].BorderSizePixel = 0
Converted["_TextLabel10"].LayoutOrder = -10
Converted["_TextLabel10"].Size = UDim2.new(1, 0, 0, 20)
Converted["_TextLabel10"].Parent = Converted["_Dockable"]
Converted["_SelectTrack"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_SelectTrack"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_SelectTrack"].BorderSizePixel = 0
Converted["_SelectTrack"].ClipsDescendants = true
Converted["_SelectTrack"].Size = UDim2.new(1, -4, 0, 125)
Converted["_SelectTrack"].Name = "SelectTrack"
Converted["_SelectTrack"].Parent = Converted["_Dockable"]
Converted["_UIGradient3"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(48, 48, 48))
}
Converted["_UIGradient3"].Rotation = -90
Converted["_UIGradient3"].Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.7562500238418579),
	NumberSequenceKeypoint.new(1, 1)
}
Converted["_UIGradient3"].Parent = Converted["_SelectTrack"]
Converted["_UICorner29"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner29"].Parent = Converted["_SelectTrack"]
Converted["_UIStroke13"].Color = Color3.fromRGB(159, 159, 159)
Converted["_UIStroke13"].Parent = Converted["_SelectTrack"]
Converted["_UIPadding31"].PaddingBottom = UDim.new(0, 8)
Converted["_UIPadding31"].PaddingLeft = UDim.new(0, 12)
Converted["_UIPadding31"].PaddingRight = UDim.new(0, 12)
Converted["_UIPadding31"].PaddingTop = UDim.new(0, 8)
Converted["_UIPadding31"].Parent = Converted["_SelectTrack"]
Converted["_UIListLayout22"].Padding = UDim.new(0, 4)
Converted["_UIListLayout22"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout22"].Parent = Converted["_SelectTrack"]
Converted["_TextLabel11"].Font = Enum.Font.GothamBold
Converted["_TextLabel11"].Text = "Select track to control"
Converted["_TextLabel11"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel11"].TextScaled = true
Converted["_TextLabel11"].TextSize = 14
Converted["_TextLabel11"].TextTransparency = 0.1899999976158142
Converted["_TextLabel11"].TextWrapped = true
Converted["_TextLabel11"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel11"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel11"].BackgroundTransparency = 1
Converted["_TextLabel11"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel11"].BorderSizePixel = 0
Converted["_TextLabel11"].Size = UDim2.new(0, 200, 0, 15)
Converted["_TextLabel11"].Parent = Converted["_SelectTrack"]
Converted["_Listing5"].AutomaticCanvasSize = Enum.AutomaticSize.X
Converted["_Listing5"].CanvasSize = UDim2.new(0, 0, 0, 0)
Converted["_Listing5"].ScrollBarImageTransparency = 0.4000000059604645
Converted["_Listing5"].ScrollBarThickness = 2
Converted["_Listing5"].Active = true
Converted["_Listing5"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Listing5"].BackgroundTransparency = 1
Converted["_Listing5"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Listing5"].BorderSizePixel = 0
Converted["_Listing5"].Size = UDim2.new(1, 0, 0, 90)
Converted["_Listing5"].Name = "Listing"
Converted["_Listing5"].Parent = Converted["_SelectTrack"]
Converted["_UIListLayout23"].Padding = UDim.new(0, 8)
Converted["_UIListLayout23"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout23"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout23"].Parent = Converted["_Listing5"]
Converted["_UIPadding32"].PaddingBottom = UDim.new(0, 6)
Converted["_UIPadding32"].PaddingLeft = UDim.new(0, 4)
Converted["_UIPadding32"].PaddingRight = UDim.new(0, 4)
Converted["_UIPadding32"].PaddingTop = UDim.new(0, 4)
Converted["_UIPadding32"].Parent = Converted["_Listing5"]
Converted["_Sample"].Font = Enum.Font.Gotham
Converted["_Sample"].Text = ""
Converted["_Sample"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Sample"].TextScaled = true
Converted["_Sample"].TextSize = 14
Converted["_Sample"].TextWrapped = true
Converted["_Sample"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Sample"].BackgroundTransparency = 0.699999988079071
Converted["_Sample"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Sample"].BorderSizePixel = 0
Converted["_Sample"].Size = UDim2.new(0, 200, 1, 0)
Converted["_Sample"].Visible = false
Converted["_Sample"].Name = "Sample"
Converted["_Sample"].Parent = Converted["_Listing5"]
Converted["_UICorner30"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner30"].Parent = Converted["_Sample"]
Converted["_UIPadding33"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding33"].PaddingLeft = UDim.new(0, 12)
Converted["_UIPadding33"].PaddingRight = UDim.new(0, 12)
Converted["_UIPadding33"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding33"].Parent = Converted["_Sample"]
Converted["_UIStroke14"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke14"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke14"].Thickness = 2.299999952316284
Converted["_UIStroke14"].Parent = Converted["_Sample"]
Converted["_UIListLayout24"].Padding = UDim.new(0, 4)
Converted["_UIListLayout24"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout24"].Parent = Converted["_Sample"]
Converted["_TextLabel12"].Font = Enum.Font.Gotham
Converted["_TextLabel12"].Text = "Track name"
Converted["_TextLabel12"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel12"].TextScaled = true
Converted["_TextLabel12"].TextSize = 14
Converted["_TextLabel12"].TextTransparency = 0.5400000214576721
Converted["_TextLabel12"].TextWrapped = true
Converted["_TextLabel12"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel12"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel12"].BackgroundTransparency = 1
Converted["_TextLabel12"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel12"].BorderSizePixel = 0
Converted["_TextLabel12"].Size = UDim2.new(0, 200, 0, 10)
Converted["_TextLabel12"].Parent = Converted["_Sample"]
Converted["_TrackName"].Font = Enum.Font.GothamBold
Converted["_TrackName"].Text = "Track name"
Converted["_TrackName"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TrackName"].TextSize = 14
Converted["_TrackName"].TextWrapped = true
Converted["_TrackName"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TrackName"].TextYAlignment = Enum.TextYAlignment.Top
Converted["_TrackName"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TrackName"].BackgroundTransparency = 1
Converted["_TrackName"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TrackName"].BorderSizePixel = 0
Converted["_TrackName"].Size = UDim2.new(1, 0, 0, 15)
Converted["_TrackName"].Name = "TrackName"
Converted["_TrackName"].Parent = Converted["_Sample"]
Converted["_UIFlexItem10"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem10"].Parent = Converted["_TrackName"]
Converted["_Listing6"].AutomaticCanvasSize = Enum.AutomaticSize.Y
Converted["_Listing6"].CanvasSize = UDim2.new(0, 0, 0, 0)
Converted["_Listing6"].ScrollBarThickness = 2
Converted["_Listing6"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Listing6"].BackgroundTransparency = 1
Converted["_Listing6"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Listing6"].BorderSizePixel = 0
Converted["_Listing6"].LayoutOrder = 2
Converted["_Listing6"].Selectable = false
Converted["_Listing6"].Size = UDim2.new(1, 0, 0, 0)
Converted["_Listing6"].Name = "Listing"
Converted["_Listing6"].Parent = Converted["_Dockable"]
Converted["_UIFlexItem11"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem11"].Parent = Converted["_Listing6"]
Converted["_UIPadding34"].PaddingBottom = UDim.new(0, 16)
Converted["_UIPadding34"].PaddingTop = UDim.new(0, 8)
Converted["_UIPadding34"].Parent = Converted["_Listing6"]
Converted["_UIListLayout25"].Padding = UDim.new(0, 8)
Converted["_UIListLayout25"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout25"].Parent = Converted["_Listing6"]
Converted["_Seekbar"].Text = ""
Converted["_Seekbar"].Modal = true
Converted["_Seekbar"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Seekbar"].BackgroundTransparency = 1
Converted["_Seekbar"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Seekbar"].BorderSizePixel = 0
Converted["_Seekbar"].LayoutOrder = 1
Converted["_Seekbar"].Selectable = false
Converted["_Seekbar"].Size = UDim2.new(1, 0, 0, 25)
Converted["_Seekbar"].Visible = false
Converted["_Seekbar"].Name = "Seekbar"
Converted["_Seekbar"].Parent = Converted["_Dockable"]
Converted["_Track"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Track"].BackgroundTransparency = 0.699999988079071
Converted["_Track"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Track"].BorderSizePixel = 0
Converted["_Track"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Track"].Name = "Track"
Converted["_Track"].Parent = Converted["_Seekbar"]
Converted["_UICorner31"].CornerRadius = UDim.new(1, 0)
Converted["_UICorner31"].Parent = Converted["_Track"]
Converted["_Ball2"].BackgroundColor3 = Color3.fromRGB(220, 220, 220)
Converted["_Ball2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Ball2"].BorderSizePixel = 0
Converted["_Ball2"].Size = UDim2.new(0, 0, 1, 0)
Converted["_Ball2"].Name = "Ball"
Converted["_Ball2"].Parent = Converted["_Track"]
Converted["_UIAspectRatioConstraint4"].AspectType = Enum.AspectType.ScaleWithParentSize
Converted["_UIAspectRatioConstraint4"].DominantAxis = Enum.DominantAxis.Height
Converted["_UIAspectRatioConstraint4"].Parent = Converted["_Ball2"]
Converted["_UICorner32"].CornerRadius = UDim.new(1, 0)
Converted["_UICorner32"].Parent = Converted["_Ball2"]
Converted["_TimePos"].Font = Enum.Font.GothamBold
Converted["_TimePos"].Text = "2.12"
Converted["_TimePos"].TextColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TimePos"].TextScaled = true
Converted["_TimePos"].TextSize = 14
Converted["_TimePos"].TextTransparency = 1
Converted["_TimePos"].TextWrapped = true
Converted["_TimePos"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TimePos"].BackgroundTransparency = 1
Converted["_TimePos"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TimePos"].BorderSizePixel = 0
Converted["_TimePos"].Size = UDim2.new(1, 0, 1, 0)
Converted["_TimePos"].Name = "TimePos"
Converted["_TimePos"].Parent = Converted["_Ball2"]
Converted["_UIPadding35"].PaddingBottom = UDim.new(0, 4)
Converted["_UIPadding35"].PaddingLeft = UDim.new(0, 4)
Converted["_UIPadding35"].PaddingRight = UDim.new(0, 4)
Converted["_UIPadding35"].PaddingTop = UDim.new(0, 4)
Converted["_UIPadding35"].Parent = Converted["_Ball2"]
Converted["_UIPadding36"].PaddingBottom = UDim.new(0, 3)
Converted["_UIPadding36"].PaddingLeft = UDim.new(0, 3)
Converted["_UIPadding36"].PaddingRight = UDim.new(0, 3)
Converted["_UIPadding36"].PaddingTop = UDim.new(0, 3)
Converted["_UIPadding36"].Parent = Converted["_Track"]
Converted["_Tactical"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Tactical"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Tactical"].BackgroundTransparency = 1
Converted["_Tactical"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Tactical"].BorderSizePixel = 0
Converted["_Tactical"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Tactical"].Size = UDim2.new(1, -20, 1, -5)
Converted["_Tactical"].Name = "Tactical"
Converted["_Tactical"].Parent = Converted["_Track"]
Converted["_UIListLayout26"].HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
Converted["_UIListLayout26"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout26"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout26"].VerticalAlignment = Enum.VerticalAlignment.Center
Converted["_UIListLayout26"].Parent = Converted["_Tactical"]
Converted["_Bar1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Bar1"].BackgroundTransparency = 0.8999999761581421
Converted["_Bar1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Bar1"].BorderSizePixel = 0
Converted["_Bar1"].Size = UDim2.new(0, 4, 0, 4)
Converted["_Bar1"].Name = "Bar"
Converted["_Bar1"].Parent = Converted["_Tactical"]
Converted["_UICorner33"].CornerRadius = UDim.new(0, 99)
Converted["_UICorner33"].Parent = Converted["_Bar1"]
Converted["_Bar2"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Bar2"].BackgroundTransparency = 0.8999999761581421
Converted["_Bar2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Bar2"].BorderSizePixel = 0
Converted["_Bar2"].Size = UDim2.new(0, 4, 0, 4)
Converted["_Bar2"].Name = "Bar"
Converted["_Bar2"].Parent = Converted["_Tactical"]
Converted["_UICorner34"].CornerRadius = UDim.new(0, 99)
Converted["_UICorner34"].Parent = Converted["_Bar2"]
Converted["_Bar3"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Bar3"].BackgroundTransparency = 0.8999999761581421
Converted["_Bar3"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Bar3"].BorderSizePixel = 0
Converted["_Bar3"].Size = UDim2.new(0, 4, 0, 4)
Converted["_Bar3"].Name = "Bar"
Converted["_Bar3"].Parent = Converted["_Tactical"]
Converted["_UICorner35"].CornerRadius = UDim.new(0, 99)
Converted["_UICorner35"].Parent = Converted["_Bar3"]
Converted["_Bar4"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Bar4"].BackgroundTransparency = 0.8999999761581421
Converted["_Bar4"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Bar4"].BorderSizePixel = 0
Converted["_Bar4"].Size = UDim2.new(0, 4, 0, 4)
Converted["_Bar4"].Name = "Bar"
Converted["_Bar4"].Parent = Converted["_Tactical"]
Converted["_UICorner36"].CornerRadius = UDim.new(0, 99)
Converted["_UICorner36"].Parent = Converted["_Bar4"]
Converted["_Bar5"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Bar5"].BackgroundTransparency = 0.8999999761581421
Converted["_Bar5"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Bar5"].BorderSizePixel = 0
Converted["_Bar5"].Size = UDim2.new(0, 4, 0, 4)
Converted["_Bar5"].Name = "Bar"
Converted["_Bar5"].Parent = Converted["_Tactical"]
Converted["_UICorner37"].CornerRadius = UDim.new(0, 99)
Converted["_UICorner37"].Parent = Converted["_Bar5"]
Converted["_Bar6"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Bar6"].BackgroundTransparency = 0.8999999761581421
Converted["_Bar6"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Bar6"].BorderSizePixel = 0
Converted["_Bar6"].Size = UDim2.new(0, 4, 0, 4)
Converted["_Bar6"].Name = "Bar"
Converted["_Bar6"].Parent = Converted["_Tactical"]
Converted["_UICorner38"].CornerRadius = UDim.new(0, 99)
Converted["_UICorner38"].Parent = Converted["_Bar6"]
Converted["_Bar7"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Bar7"].BackgroundTransparency = 0.8999999761581421
Converted["_Bar7"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Bar7"].BorderSizePixel = 0
Converted["_Bar7"].Size = UDim2.new(0, 4, 0, 4)
Converted["_Bar7"].Name = "Bar"
Converted["_Bar7"].Parent = Converted["_Tactical"]
Converted["_UICorner39"].CornerRadius = UDim.new(0, 99)
Converted["_UICorner39"].Parent = Converted["_Bar7"]
Converted["_Bar8"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Bar8"].BackgroundTransparency = 0.8999999761581421
Converted["_Bar8"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Bar8"].BorderSizePixel = 0
Converted["_Bar8"].Size = UDim2.new(0, 4, 0, 4)
Converted["_Bar8"].Name = "Bar"
Converted["_Bar8"].Parent = Converted["_Tactical"]
Converted["_UICorner40"].CornerRadius = UDim.new(0, 99)
Converted["_UICorner40"].Parent = Converted["_Bar8"]
Converted["_Bar9"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Bar9"].BackgroundTransparency = 0.8999999761581421
Converted["_Bar9"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Bar9"].BorderSizePixel = 0
Converted["_Bar9"].Size = UDim2.new(0, 4, 0, 4)
Converted["_Bar9"].Name = "Bar"
Converted["_Bar9"].Parent = Converted["_Tactical"]
Converted["_UICorner41"].CornerRadius = UDim.new(0, 99)
Converted["_UICorner41"].Parent = Converted["_Bar9"]
Converted["_Bar10"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Bar10"].BackgroundTransparency = 0.8999999761581421
Converted["_Bar10"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Bar10"].BorderSizePixel = 0
Converted["_Bar10"].Size = UDim2.new(0, 4, 0, 4)
Converted["_Bar10"].Name = "Bar"
Converted["_Bar10"].Parent = Converted["_Tactical"]
Converted["_UICorner42"].CornerRadius = UDim.new(0, 99)
Converted["_UICorner42"].Parent = Converted["_Bar10"]
Converted["_Bar11"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Bar11"].BackgroundTransparency = 0.8999999761581421
Converted["_Bar11"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Bar11"].BorderSizePixel = 0
Converted["_Bar11"].Size = UDim2.new(0, 4, 0, 4)
Converted["_Bar11"].Name = "Bar"
Converted["_Bar11"].Parent = Converted["_Tactical"]
Converted["_UICorner43"].CornerRadius = UDim.new(0, 99)
Converted["_UICorner43"].Parent = Converted["_Bar11"]
Converted["_UIListLayout27"].Padding = UDim.new(0, 8)
Converted["_UIListLayout27"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout27"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout27"].VerticalAlignment = Enum.VerticalAlignment.Center
Converted["_UIListLayout27"].Parent = Converted["_Seekbar"]
Converted["_UICorner44"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner44"].Parent = Converted["_Dockable"]
Converted["_UIPadding37"].Parent = Converted["_Dockable"]
Converted["_Handle"].Text = ""
Converted["_Handle"].Modal = true
Converted["_Handle"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Handle"].BackgroundTransparency = 0.699999988079071
Converted["_Handle"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Handle"].BorderSizePixel = 0
Converted["_Handle"].LayoutOrder = -100
Converted["_Handle"].Selectable = false
Converted["_Handle"].Size = UDim2.new(0, 100, 0, 10)
Converted["_Handle"].Visible = false
Converted["_Handle"].Name = "Handle"
Converted["_Handle"].Parent = Converted["_Dockable"]
Converted["_UICorner45"].Parent = Converted["_Handle"]
Converted["_ItemListTemplate"].Active = true
Converted["_ItemListTemplate"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Converted["_ItemListTemplate"].BackgroundTransparency = 1
Converted["_ItemListTemplate"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ItemListTemplate"].BorderSizePixel = 0
Converted["_ItemListTemplate"].ClipsDescendants = true
Converted["_ItemListTemplate"].Selectable = true
Converted["_ItemListTemplate"].Size = UDim2.new(0, 200, 0, 50)
Converted["_ItemListTemplate"].Visible = false
Converted["_ItemListTemplate"].Name = "ItemListTemplate"
Converted["_ItemListTemplate"].Parent = Converted["_ItemSelect"]
Converted["_UIPadding38"].PaddingBottom = UDim.new(0, 2)
Converted["_UIPadding38"].PaddingLeft = UDim.new(0, 2)
Converted["_UIPadding38"].PaddingRight = UDim.new(0, 2)
Converted["_UIPadding38"].PaddingTop = UDim.new(0, 2)
Converted["_UIPadding38"].Parent = Converted["_ItemListTemplate"]
Converted["_Clickable1"].Font = Enum.Font.SourceSans
Converted["_Clickable1"].Text = ""
Converted["_Clickable1"].TextColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Clickable1"].TextSize = 14
Converted["_Clickable1"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Clickable1"].BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Converted["_Clickable1"].BackgroundTransparency = 0.550000011920929
Converted["_Clickable1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Clickable1"].BorderSizePixel = 0
Converted["_Clickable1"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Clickable1"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Clickable1"].Name = "Clickable"
Converted["_Clickable1"].Parent = Converted["_ItemListTemplate"]
Converted["_UIPadding39"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding39"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding39"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding39"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding39"].Parent = Converted["_Clickable1"]
Converted["_Details"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Details"].BackgroundTransparency = 1
Converted["_Details"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Details"].BorderSizePixel = 0
Converted["_Details"].Size = UDim2.new(0, 0, 1, 0)
Converted["_Details"].Name = "Details"
Converted["_Details"].Parent = Converted["_Clickable1"]
Converted["_Description"].Font = Enum.Font.Gotham
Converted["_Description"].Text = ""
Converted["_Description"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Description"].TextSize = 14
Converted["_Description"].TextTransparency = 0.4000000059604645
Converted["_Description"].TextTruncate = Enum.TextTruncate.AtEnd
Converted["_Description"].TextWrapped = true
Converted["_Description"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_Description"].TextYAlignment = Enum.TextYAlignment.Top
Converted["_Description"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Description"].BackgroundTransparency = 1
Converted["_Description"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Description"].BorderSizePixel = 0
Converted["_Description"].LayoutOrder = 1
Converted["_Description"].Size = UDim2.new(1, 0, 0, 15)
Converted["_Description"].Name = "Description"
Converted["_Description"].Parent = Converted["_Details"]
Converted["_UIFlexItem12"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem12"].Parent = Converted["_Description"]
Converted["_Buttons"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Buttons"].BackgroundTransparency = 1
Converted["_Buttons"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Buttons"].BorderSizePixel = 0
Converted["_Buttons"].LayoutOrder = 10
Converted["_Buttons"].Size = UDim2.new(1, 0, 0, 0)
Converted["_Buttons"].Name = "Buttons"
Converted["_Buttons"].Parent = Converted["_Details"]
Converted["_Loading"].BackgroundColor3 = Color3.fromRGB(65, 65, 65)
Converted["_Loading"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Loading"].BorderSizePixel = 0
Converted["_Loading"].LayoutOrder = -10
Converted["_Loading"].Size = UDim2.new(0, 0, 0, 10)
Converted["_Loading"].Visible = false
Converted["_Loading"].Name = "Loading"
Converted["_Loading"].Parent = Converted["_Buttons"]
Converted["_Progress"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Progress"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Progress"].BorderSizePixel = 0
Converted["_Progress"].LayoutOrder = -10
Converted["_Progress"].Size = UDim2.new(0, 10, 0, 10)
Converted["_Progress"].Name = "Progress"
Converted["_Progress"].Parent = Converted["_Loading"]
Converted["_UICorner46"].Parent = Converted["_Progress"]
Converted["_UICorner47"].Parent = Converted["_Loading"]
Converted["_UIFlexItem13"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem13"].Parent = Converted["_Loading"]
Converted["_Play"].Font = Enum.Font.GothamBold
Converted["_Play"].Text = "PLAY"
Converted["_Play"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Play"].TextScaled = true
Converted["_Play"].TextSize = 14
Converted["_Play"].TextWrapped = true
Converted["_Play"].BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Converted["_Play"].BackgroundTransparency = 0.30000001192092896
Converted["_Play"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Play"].BorderSizePixel = 0
Converted["_Play"].Size = UDim2.new(0, 40, 0, 15)
Converted["_Play"].Name = "Play"
Converted["_Play"].Parent = Converted["_Buttons"]
Converted["_UIPadding40"].PaddingBottom = UDim.new(0, 4)
Converted["_UIPadding40"].PaddingLeft = UDim.new(0, 4)
Converted["_UIPadding40"].PaddingRight = UDim.new(0, 4)
Converted["_UIPadding40"].PaddingTop = UDim.new(0, 3)
Converted["_UIPadding40"].Parent = Converted["_Play"]
Converted["_UICorner48"].CornerRadius = UDim.new(0, 6)
Converted["_UICorner48"].Parent = Converted["_Play"]
Converted["_OffSale"].Font = Enum.Font.GothamBold
Converted["_OffSale"].Text = "OFF-SALE"
Converted["_OffSale"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_OffSale"].TextScaled = true
Converted["_OffSale"].TextSize = 14
Converted["_OffSale"].TextWrapped = true
Converted["_OffSale"].BackgroundColor3 = Color3.fromRGB(190, 0, 3)
Converted["_OffSale"].BackgroundTransparency = 0.30000001192092896
Converted["_OffSale"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_OffSale"].BorderSizePixel = 0
Converted["_OffSale"].Interactable = false
Converted["_OffSale"].LayoutOrder = -1
Converted["_OffSale"].Size = UDim2.new(0, 60, 0, 15)
Converted["_OffSale"].Visible = false
Converted["_OffSale"].Name = "OffSale"
Converted["_OffSale"].Parent = Converted["_Buttons"]
Converted["_UIPadding41"].PaddingBottom = UDim.new(0, 4)
Converted["_UIPadding41"].PaddingLeft = UDim.new(0, 4)
Converted["_UIPadding41"].PaddingRight = UDim.new(0, 4)
Converted["_UIPadding41"].PaddingTop = UDim.new(0, 3)
Converted["_UIPadding41"].Parent = Converted["_OffSale"]
Converted["_UICorner49"].CornerRadius = UDim.new(0, 6)
Converted["_UICorner49"].Parent = Converted["_OffSale"]
Converted["_UIFlexItem14"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem14"].Parent = Converted["_Buttons"]
Converted["_UIListLayout28"].Padding = UDim.new(0, 8)
Converted["_UIListLayout28"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout28"].HorizontalAlignment = Enum.HorizontalAlignment.Right
Converted["_UIListLayout28"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout28"].VerticalAlignment = Enum.VerticalAlignment.Center
Converted["_UIListLayout28"].Parent = Converted["_Buttons"]
Converted["_Title"].Font = Enum.Font.GothamBold
Converted["_Title"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Title"].TextSize = 14
Converted["_Title"].TextWrapped = true
Converted["_Title"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_Title"].AutomaticSize = Enum.AutomaticSize.Y
Converted["_Title"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Title"].BackgroundTransparency = 1
Converted["_Title"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Title"].BorderSizePixel = 0
Converted["_Title"].Size = UDim2.new(1, 0, 0, 15)
Converted["_Title"].Name = "Title"
Converted["_Title"].Parent = Converted["_Details"]
Converted["_UIListLayout29"].Padding = UDim.new(0, 4)
Converted["_UIListLayout29"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout29"].Parent = Converted["_Details"]
Converted["_UIFlexItem15"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem15"].Parent = Converted["_Details"]
Converted["_Thumbnail"].Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Converted["_Thumbnail"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Thumbnail"].BackgroundTransparency = 1
Converted["_Thumbnail"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Thumbnail"].BorderSizePixel = 0
Converted["_Thumbnail"].LayoutOrder = -1
Converted["_Thumbnail"].Size = UDim2.new(0, 0, 1, 0)
Converted["_Thumbnail"].Name = "Thumbnail"
Converted["_Thumbnail"].Parent = Converted["_Clickable1"]
Converted["_UIStroke15"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke15"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke15"].Parent = Converted["_Thumbnail"]
Converted["_UIAspectRatioConstraint5"].Parent = Converted["_Thumbnail"]
Converted["_UICorner50"].CornerRadius = UDim.new(0, 12)
Converted["_UICorner50"].Parent = Converted["_Thumbnail"]
Converted["_UIFlexItem16"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem16"].Parent = Converted["_Thumbnail"]
Converted["_UIListLayout30"].Padding = UDim.new(0, 8)
Converted["_UIListLayout30"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout30"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout30"].Parent = Converted["_Clickable1"]
Converted["_UIStroke16"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke16"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke16"].Thickness = 2.299999952316284
Converted["_UIStroke16"].Parent = Converted["_Clickable1"]
Converted["_CustomEffect"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 111, 224)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 219, 255))
}
Converted["_CustomEffect"].Enabled = false
Converted["_CustomEffect"].Rotation = -37
Converted["_CustomEffect"].Name = "CustomEffect"
Converted["_CustomEffect"].Parent = Converted["_UIStroke16"]
Converted["_UICorner51"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner51"].Parent = Converted["_Clickable1"]
Converted["_OffSaleEffect"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.49653980135917664, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
}
Converted["_OffSaleEffect"].Enabled = false
Converted["_OffSaleEffect"].Name = "OffSaleEffect"
Converted["_OffSaleEffect"].Parent = Converted["_Clickable1"]
Converted["_UIScale11"].Parent = Converted["_Area"]
Converted["_Tip1"].Font = Enum.Font.GothamBold
Converted["_Tip1"].RichText = true
Converted["_Tip1"].Text = "ALL UGC EMOTES                           FE                           MANY FEATURES"
Converted["_Tip1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Tip1"].TextScaled = true
Converted["_Tip1"].TextSize = 14
Converted["_Tip1"].TextTransparency = 1
Converted["_Tip1"].TextWrapped = true
Converted["_Tip1"].AnchorPoint = Vector2.new(0.5, 1)
Converted["_Tip1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Tip1"].BackgroundTransparency = 1
Converted["_Tip1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Tip1"].BorderSizePixel = 0
Converted["_Tip1"].Position = UDim2.new(0.5, 0, 1, -20)
Converted["_Tip1"].Size = UDim2.new(0, 600, 0, 10)
Converted["_Tip1"].Name = "Tip"
Converted["_Tip1"].Parent = Converted["_Menu"]
Converted["_MenuStateChange"].Name = "MenuStateChange"
Converted["_MenuStateChange"].Parent = Converted["_Menu"]
Converted["_MenuSpringTakeover"].Name = "MenuSpringTakeover"
Converted["_MenuSpringTakeover"].Parent = Converted["_Menu"]
Converted["_ItemDetail"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_ItemDetail"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ItemDetail"].BackgroundTransparency = 0.6499999761581421
Converted["_ItemDetail"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ItemDetail"].BorderSizePixel = 0
Converted["_ItemDetail"].ClipsDescendants = true
Converted["_ItemDetail"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_ItemDetail"].Size = UDim2.new(0, 400, 0, 350)
Converted["_ItemDetail"].Visible = false
Converted["_ItemDetail"].ZIndex = 100
Converted["_ItemDetail"].Name = "ItemDetail"
Converted["_ItemDetail"].Parent = Converted["_Menu"]
Converted["_UIStroke17"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke17"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke17"].Thickness = 2.299999952316284
Converted["_UIStroke17"].Parent = Converted["_ItemDetail"]
Converted["_CustomEffect1"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 111, 224)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 219, 255))
}
Converted["_CustomEffect1"].Enabled = false
Converted["_CustomEffect1"].Rotation = -37
Converted["_CustomEffect1"].Name = "CustomEffect"
Converted["_CustomEffect1"].Parent = Converted["_UIStroke17"]
Converted["_UICorner52"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner52"].Parent = Converted["_ItemDetail"]
Converted["_UIListLayout31"].Padding = UDim.new(0, 8)
Converted["_UIListLayout31"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout31"].Parent = Converted["_ItemDetail"]
Converted["_UIPadding42"].PaddingBottom = UDim.new(0, 8)
Converted["_UIPadding42"].PaddingLeft = UDim.new(0, 8)
Converted["_UIPadding42"].PaddingRight = UDim.new(0, 8)
Converted["_UIPadding42"].PaddingTop = UDim.new(0, 8)
Converted["_UIPadding42"].Parent = Converted["_ItemDetail"]
Converted["_Item"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Item"].BackgroundTransparency = 1
Converted["_Item"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Item"].BorderSizePixel = 0
Converted["_Item"].Size = UDim2.new(1, 0, 0, 0)
Converted["_Item"].Name = "Item"
Converted["_Item"].Parent = Converted["_ItemDetail"]
Converted["_UIFlexItem17"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem17"].Parent = Converted["_Item"]
Converted["_AvatarPreview"].Ambient = Color3.fromRGB(227, 227, 227)
Converted["_AvatarPreview"].LightColor = Color3.fromRGB(107, 146, 255)
Converted["_AvatarPreview"].LightDirection = Vector3.new(0.5, -0.5, -0.5)
Converted["_AvatarPreview"].AnchorPoint = Vector2.new(1, 0)
Converted["_AvatarPreview"].BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Converted["_AvatarPreview"].BackgroundTransparency = 0.10000000149011612
Converted["_AvatarPreview"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_AvatarPreview"].BorderSizePixel = 0
Converted["_AvatarPreview"].Position = UDim2.new(1, -20, 0, 20)
Converted["_AvatarPreview"].Size = UDim2.new(1, 0, 0, 0)
Converted["_AvatarPreview"].Name = "AvatarPreview"
Converted["_AvatarPreview"].Parent = Converted["_Item"]
Converted["_UIStroke18"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke18"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke18"].Thickness = 2.299999952316284
Converted["_UIStroke18"].Parent = Converted["_AvatarPreview"]
Converted["_UICorner53"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner53"].Parent = Converted["_AvatarPreview"]
Converted["_PlayEmote"].Name = "PlayEmote"
Converted["_PlayEmote"].Parent = Converted["_AvatarPreview"]
Converted["_WorldModel"].Parent = Converted["_AvatarPreview"]
Converted["_Drag"].Font = Enum.Font.SourceSans
Converted["_Drag"].Text = ""
Converted["_Drag"].TextColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Drag"].TextSize = 14
Converted["_Drag"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Drag"].BackgroundTransparency = 1
Converted["_Drag"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Drag"].BorderSizePixel = 0
Converted["_Drag"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Drag"].Name = "Drag"
Converted["_Drag"].Parent = Converted["_AvatarPreview"]
Converted["_UIFlexItem18"].FlexMode = Enum.UIFlexMode.Custom
Converted["_UIFlexItem18"].GrowRatio = 1
Converted["_UIFlexItem18"].Parent = Converted["_AvatarPreview"]
Converted["_UIListLayout32"].Padding = UDim.new(0, 8)
Converted["_UIListLayout32"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout32"].Parent = Converted["_Item"]
Converted["_Details1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Details1"].BackgroundTransparency = 1
Converted["_Details1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Details1"].BorderSizePixel = 0
Converted["_Details1"].Size = UDim2.new(1, 0, 0, 0)
Converted["_Details1"].Name = "Details"
Converted["_Details1"].Parent = Converted["_Item"]
Converted["_UIListLayout33"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout33"].Parent = Converted["_Details1"]
Converted["_ItemName"].Font = Enum.Font.GothamBold
Converted["_ItemName"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ItemName"].TextSize = 20
Converted["_ItemName"].TextWrapped = true
Converted["_ItemName"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_ItemName"].AutomaticSize = Enum.AutomaticSize.Y
Converted["_ItemName"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ItemName"].BackgroundTransparency = 1
Converted["_ItemName"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ItemName"].BorderSizePixel = 0
Converted["_ItemName"].Size = UDim2.new(1, 0, 0, 20)
Converted["_ItemName"].Name = "ItemName"
Converted["_ItemName"].Parent = Converted["_Details1"]
Converted["_ItemDescription"].Font = Enum.Font.Gotham
Converted["_ItemDescription"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ItemDescription"].TextSize = 16
Converted["_ItemDescription"].TextTransparency = 0.49000000953674316
Converted["_ItemDescription"].TextTruncate = Enum.TextTruncate.AtEnd
Converted["_ItemDescription"].TextWrapped = true
Converted["_ItemDescription"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_ItemDescription"].AutomaticSize = Enum.AutomaticSize.Y
Converted["_ItemDescription"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ItemDescription"].BackgroundTransparency = 1
Converted["_ItemDescription"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ItemDescription"].BorderSizePixel = 0
Converted["_ItemDescription"].Size = UDim2.new(1, 0, 0, 20)
Converted["_ItemDescription"].Name = "ItemDescription"
Converted["_ItemDescription"].Parent = Converted["_Details1"]
Converted["_UIFlexItem19"].FlexMode = Enum.UIFlexMode.Custom
Converted["_UIFlexItem19"].GrowRatio = 0.6000000238418579
Converted["_UIFlexItem19"].Parent = Converted["_Details1"]
Converted["_Actions"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Actions"].BackgroundTransparency = 1
Converted["_Actions"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Actions"].BorderSizePixel = 0
Converted["_Actions"].Size = UDim2.new(1, 0, 0, 20)
Converted["_Actions"].SelectionGroup = true
Converted["_Actions"].Name = "Actions"
Converted["_Actions"].Parent = Converted["_ItemDetail"]
Converted["_UIListLayout34"].Padding = UDim.new(0, 6)
Converted["_UIListLayout34"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout34"].HorizontalAlignment = Enum.HorizontalAlignment.Right
Converted["_UIListLayout34"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout34"].Parent = Converted["_Actions"]
Converted["_Favorites1"].Font = Enum.Font.Gotham
Converted["_Favorites1"].Text = "FAVORITE"
Converted["_Favorites1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Favorites1"].TextSize = 12
Converted["_Favorites1"].AutomaticSize = Enum.AutomaticSize.X
Converted["_Favorites1"].BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Converted["_Favorites1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Favorites1"].BorderSizePixel = 0
Converted["_Favorites1"].LayoutOrder = 2
Converted["_Favorites1"].Size = UDim2.new(0, 0, 1, 0)
Converted["_Favorites1"].Name = "Favorites"
Converted["_Favorites1"].Parent = Converted["_Actions"]
Converted["_UICorner54"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner54"].Parent = Converted["_Favorites1"]
Converted["_UIPadding43"].PaddingBottom = UDim.new(0, 9)
Converted["_UIPadding43"].PaddingLeft = UDim.new(0, 9)
Converted["_UIPadding43"].PaddingRight = UDim.new(0, 9)
Converted["_UIPadding43"].PaddingTop = UDim.new(0, 9)
Converted["_UIPadding43"].Parent = Converted["_Favorites1"]
Converted["_UIStroke19"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke19"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke19"].Thickness = 1.600000023841858
Converted["_UIStroke19"].Parent = Converted["_Favorites1"]
Converted["_Play1"].Font = Enum.Font.Gotham
Converted["_Play1"].Text = "PLAY"
Converted["_Play1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Play1"].TextSize = 12
Converted["_Play1"].TextWrapped = true
Converted["_Play1"].AutomaticSize = Enum.AutomaticSize.X
Converted["_Play1"].BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Converted["_Play1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Play1"].BorderSizePixel = 0
Converted["_Play1"].LayoutOrder = 3
Converted["_Play1"].Size = UDim2.new(0, 0, 1, 0)
Converted["_Play1"].Name = "Play"
Converted["_Play1"].Parent = Converted["_Actions"]
Converted["_UICorner55"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner55"].Parent = Converted["_Play1"]
Converted["_UIPadding44"].PaddingBottom = UDim.new(0, 9)
Converted["_UIPadding44"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding44"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding44"].PaddingTop = UDim.new(0, 9)
Converted["_UIPadding44"].Parent = Converted["_Play1"]
Converted["_UIStroke20"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke20"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke20"].Thickness = 1.600000023841858
Converted["_UIStroke20"].Parent = Converted["_Play1"]
Converted["_Spacer1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Spacer1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Spacer1"].BorderSizePixel = 0
Converted["_Spacer1"].LayoutOrder = -99
Converted["_Spacer1"].Name = "Spacer"
Converted["_Spacer1"].Parent = Converted["_Actions"]
Converted["_UIFlexItem20"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem20"].Parent = Converted["_Spacer1"]
Converted["_Close"].Font = Enum.Font.Gotham
Converted["_Close"].Text = "CLOSE"
Converted["_Close"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Close"].TextSize = 12
Converted["_Close"].TextWrapped = true
Converted["_Close"].AutomaticSize = Enum.AutomaticSize.X
Converted["_Close"].BackgroundColor3 = Color3.fromRGB(46, 0, 0)
Converted["_Close"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Close"].BorderSizePixel = 0
Converted["_Close"].LayoutOrder = -100
Converted["_Close"].Size = UDim2.new(0, 0, 1, 0)
Converted["_Close"].Name = "Close"
Converted["_Close"].Parent = Converted["_Actions"]
Converted["_UICorner56"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner56"].Parent = Converted["_Close"]
Converted["_UIPadding45"].PaddingBottom = UDim.new(0, 9)
Converted["_UIPadding45"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding45"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding45"].PaddingTop = UDim.new(0, 9)
Converted["_UIPadding45"].Parent = Converted["_Close"]
Converted["_UIStroke21"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke21"].Color = Color3.fromRGB(179, 0, 0)
Converted["_UIStroke21"].Thickness = 1.600000023841858
Converted["_UIStroke21"].Parent = Converted["_Close"]
Converted["_CopyAnimID"].Font = Enum.Font.Gotham
Converted["_CopyAnimID"].Text = "COPY ANIM. ID"
Converted["_CopyAnimID"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_CopyAnimID"].TextSize = 12
Converted["_CopyAnimID"].TextWrapped = true
Converted["_CopyAnimID"].AutomaticSize = Enum.AutomaticSize.X
Converted["_CopyAnimID"].BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Converted["_CopyAnimID"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_CopyAnimID"].BorderSizePixel = 0
Converted["_CopyAnimID"].Size = UDim2.new(0, 0, 1, 0)
Converted["_CopyAnimID"].Name = "CopyAnimID"
Converted["_CopyAnimID"].Parent = Converted["_Actions"]
Converted["_UICorner57"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner57"].Parent = Converted["_CopyAnimID"]
Converted["_UIPadding46"].PaddingBottom = UDim.new(0, 9)
Converted["_UIPadding46"].PaddingLeft = UDim.new(0, 9)
Converted["_UIPadding46"].PaddingRight = UDim.new(0, 9)
Converted["_UIPadding46"].PaddingTop = UDim.new(0, 9)
Converted["_UIPadding46"].Parent = Converted["_CopyAnimID"]
Converted["_UIStroke22"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke22"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke22"].Thickness = 1.600000023841858
Converted["_UIStroke22"].Parent = Converted["_CopyAnimID"]
Converted["_FloatingButton"].Font = Enum.Font.Gotham
Converted["_FloatingButton"].Text = "FLOATING B."
Converted["_FloatingButton"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_FloatingButton"].TextSize = 12
Converted["_FloatingButton"].TextWrapped = true
Converted["_FloatingButton"].AutomaticSize = Enum.AutomaticSize.X
Converted["_FloatingButton"].BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Converted["_FloatingButton"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_FloatingButton"].BorderSizePixel = 0
Converted["_FloatingButton"].LayoutOrder = 1
Converted["_FloatingButton"].Size = UDim2.new(0, 0, 1, 0)
Converted["_FloatingButton"].Name = "FloatingButton"
Converted["_FloatingButton"].Parent = Converted["_Actions"]
Converted["_UICorner58"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner58"].Parent = Converted["_FloatingButton"]
Converted["_UIPadding47"].PaddingBottom = UDim.new(0, 9)
Converted["_UIPadding47"].PaddingLeft = UDim.new(0, 9)
Converted["_UIPadding47"].PaddingRight = UDim.new(0, 9)
Converted["_UIPadding47"].PaddingTop = UDim.new(0, 9)
Converted["_UIPadding47"].Parent = Converted["_FloatingButton"]
Converted["_UIStroke23"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke23"].Color = Color3.fromRGB(179, 179, 179)
Converted["_UIStroke23"].Thickness = 1.600000023841858
Converted["_UIStroke23"].Parent = Converted["_FloatingButton"]
Converted["_Backdrop"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Backdrop"].BackgroundTransparency = 1
Converted["_Backdrop"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Backdrop"].BorderSizePixel = 0
Converted["_Backdrop"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Backdrop"].ZIndex = 10
Converted["_Backdrop"].Name = "Backdrop"
Converted["_Backdrop"].Parent = Converted["_Menu"]
Converted["_ShamelessCredit"].Font = Enum.Font.Gotham
Converted["_ShamelessCredit"].Text = ""
Converted["_ShamelessCredit"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ShamelessCredit"].TextSize = 14
Converted["_ShamelessCredit"].TextTransparency = 0.7400000095367432
Converted["_ShamelessCredit"].TextWrapped = true
Converted["_ShamelessCredit"].TextXAlignment = Enum.TextXAlignment.Right
Converted["_ShamelessCredit"].AnchorPoint = Vector2.new(1, 0)
Converted["_ShamelessCredit"].AutomaticSize = Enum.AutomaticSize.XY
Converted["_ShamelessCredit"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ShamelessCredit"].BackgroundTransparency = 1
Converted["_ShamelessCredit"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ShamelessCredit"].BorderSizePixel = 0
Converted["_ShamelessCredit"].Position = UDim2.new(1, -10, 0, 10)
Converted["_ShamelessCredit"].Name = "ShamelessCredit"
Converted["_ShamelessCredit"].Parent = Converted["_Menu"]
Converted["_QuickSelectorIcon"].Name = "QuickSelectorIcon"
Converted["_QuickSelectorIcon"].Parent = Converted["_Menu"]
Converted["_Modal"].AutomaticSize = Enum.AutomaticSize.Y
Converted["_Modal"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Modal"].BackgroundTransparency = 1
Converted["_Modal"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Modal"].BorderSizePixel = 0
Converted["_Modal"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Modal"].ZIndex = 10
Converted["_Modal"].Name = "Modal"
Converted["_Modal"].Parent = Converted["_AFEMMax"]
Converted["_Container"].GroupTransparency = 1
Converted["_Container"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Container"].AutomaticSize = Enum.AutomaticSize.Y
Converted["_Container"].BackgroundColor3 = Color3.fromRGB(59, 59, 59)
Converted["_Container"].BackgroundTransparency = 0.25
Converted["_Container"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Container"].BorderSizePixel = 0
Converted["_Container"].Interactable = false
Converted["_Container"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Container"].Size = UDim2.new(0, 300, 0, 200)
Converted["_Container"].Name = "Container"
Converted["_Container"].Parent = Converted["_Modal"]
Converted["_UICorner59"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner59"].Parent = Converted["_Container"]
Converted["_UIStroke24"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke24"].Parent = Converted["_Container"]
Converted["_UIListLayout35"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout35"].Parent = Converted["_Container"]
Converted["_Visual"].AutomaticSize = Enum.AutomaticSize.Y
Converted["_Visual"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Visual"].BackgroundTransparency = 1
Converted["_Visual"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Visual"].BorderSizePixel = 0
Converted["_Visual"].Size = UDim2.new(1, 0, 0, 0)
Converted["_Visual"].Name = "Visual"
Converted["_Visual"].Parent = Converted["_Container"]
Converted["_Desc"].Font = Enum.Font.Gotham
Converted["_Desc"].RichText = true
Converted["_Desc"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Desc"].TextSize = 20
Converted["_Desc"].TextWrapped = true
Converted["_Desc"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_Desc"].TextYAlignment = Enum.TextYAlignment.Top
Converted["_Desc"].AutomaticSize = Enum.AutomaticSize.Y
Converted["_Desc"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Desc"].BackgroundTransparency = 1
Converted["_Desc"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Desc"].BorderSizePixel = 0
Converted["_Desc"].Size = UDim2.new(1, 0, 0, 0)
Converted["_Desc"].Name = "Desc"
Converted["_Desc"].Parent = Converted["_Visual"]
Converted["_UIFlexItem21"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem21"].Parent = Converted["_Desc"]
Converted["_Title1"].Font = Enum.Font.GothamBold
Converted["_Title1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Title1"].TextScaled = true
Converted["_Title1"].TextSize = 14
Converted["_Title1"].TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Title1"].TextWrapped = true
Converted["_Title1"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_Title1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Title1"].BackgroundTransparency = 1
Converted["_Title1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Title1"].BorderSizePixel = 0
Converted["_Title1"].LayoutOrder = -10
Converted["_Title1"].Size = UDim2.new(1, 0, 0, 20)
Converted["_Title1"].Name = "Title"
Converted["_Title1"].Parent = Converted["_Visual"]
Converted["_UIPadding48"].PaddingBottom = UDim.new(0, 16)
Converted["_UIPadding48"].PaddingLeft = UDim.new(0, 16)
Converted["_UIPadding48"].PaddingRight = UDim.new(0, 16)
Converted["_UIPadding48"].PaddingTop = UDim.new(0, 16)
Converted["_UIPadding48"].Parent = Converted["_Visual"]
Converted["_UIListLayout36"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout36"].Parent = Converted["_Visual"]
Converted["_UIFlexItem22"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem22"].Parent = Converted["_Visual"]
Converted["_Buttons1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Buttons1"].BackgroundTransparency = 0.8999999761581421
Converted["_Buttons1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Buttons1"].BorderSizePixel = 0
Converted["_Buttons1"].LayoutOrder = 2
Converted["_Buttons1"].Size = UDim2.new(1, 0, 0, 50)
Converted["_Buttons1"].Name = "Buttons"
Converted["_Buttons1"].Parent = Converted["_Container"]
Converted["_UIListLayout37"].Padding = UDim.new(0, 8)
Converted["_UIListLayout37"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout37"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIListLayout37"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout37"].VerticalAlignment = Enum.VerticalAlignment.Center
Converted["_UIListLayout37"].Parent = Converted["_Buttons1"]
Converted["_Sample1"].Font = Enum.Font.Gotham
Converted["_Sample1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Sample1"].TextScaled = true
Converted["_Sample1"].TextSize = 14
Converted["_Sample1"].TextWrapped = true
Converted["_Sample1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Sample1"].BackgroundTransparency = 0.8999999761581421
Converted["_Sample1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Sample1"].BorderSizePixel = 0
Converted["_Sample1"].Size = UDim2.new(0, 0, 1, 0)
Converted["_Sample1"].Visible = false
Converted["_Sample1"].Name = "Sample"
Converted["_Sample1"].Parent = Converted["_Buttons1"]
Converted["_UICorner60"].Parent = Converted["_Sample1"]
Converted["_UIPadding49"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding49"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding49"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding49"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding49"].Parent = Converted["_Sample1"]
Converted["_UIFlexItem23"].FlexMode = Enum.UIFlexMode.Grow
Converted["_UIFlexItem23"].Parent = Converted["_Sample1"]
Converted["_UIPadding50"].PaddingBottom = UDim.new(0, 8)
Converted["_UIPadding50"].PaddingLeft = UDim.new(0, 8)
Converted["_UIPadding50"].PaddingRight = UDim.new(0, 8)
Converted["_UIPadding50"].PaddingTop = UDim.new(0, 8)
Converted["_UIPadding50"].Parent = Converted["_Buttons1"]
Converted["_UIScale12"].Scale = 1.100000023841858
Converted["_UIScale12"].Parent = Converted["_Container"]
Converted["_Input"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Input"].BackgroundTransparency = 1
Converted["_Input"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Input"].BorderSizePixel = 0
Converted["_Input"].Size = UDim2.new(1, 0, 0, 50)
Converted["_Input"].Visible = false
Converted["_Input"].Name = "Input"
Converted["_Input"].Parent = Converted["_Container"]
Converted["_TextBox"].ClearTextOnFocus = false
Converted["_TextBox"].Font = Enum.Font.Gotham
Converted["_TextBox"].PlaceholderText = "Input..."
Converted["_TextBox"].Text = ""
Converted["_TextBox"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextBox"].TextScaled = true
Converted["_TextBox"].TextSize = 14
Converted["_TextBox"].TextWrapped = true
Converted["_TextBox"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextBox"].BackgroundColor3 = Color3.fromRGB(46, 46, 46)
Converted["_TextBox"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextBox"].BorderSizePixel = 0
Converted["_TextBox"].Size = UDim2.new(1, 0, 1, 0)
Converted["_TextBox"].Parent = Converted["_Input"]
Converted["_UICorner61"].Parent = Converted["_TextBox"]
Converted["_UIPadding51"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding51"].PaddingLeft = UDim.new(0, 16)
Converted["_UIPadding51"].PaddingRight = UDim.new(0, 16)
Converted["_UIPadding51"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding51"].Parent = Converted["_TextBox"]
Converted["_UIStroke25"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke25"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke25"].Thickness = 0.800000011920929
Converted["_UIStroke25"].Parent = Converted["_TextBox"]
Converted["_UIPadding52"].PaddingBottom = UDim.new(0, 8)
Converted["_UIPadding52"].PaddingLeft = UDim.new(0, 8)
Converted["_UIPadding52"].PaddingRight = UDim.new(0, 8)
Converted["_UIPadding52"].PaddingTop = UDim.new(0, 8)
Converted["_UIPadding52"].Parent = Converted["_Input"]
Converted["_GrabArea"].Font = Enum.Font.SourceSans
Converted["_GrabArea"].Text = ""
Converted["_GrabArea"].TextColor3 = Color3.fromRGB(0, 0, 0)
Converted["_GrabArea"].TextSize = 14
Converted["_GrabArea"].AnchorPoint = Vector2.new(0.5, 0)
Converted["_GrabArea"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_GrabArea"].BackgroundTransparency = 1
Converted["_GrabArea"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_GrabArea"].BorderSizePixel = 0
Converted["_GrabArea"].Position = UDim2.new(0.5, 0, 0, 0)
Converted["_GrabArea"].Size = UDim2.new(0, 200, 0, 65)
Converted["_GrabArea"].Name = "GrabArea"
Converted["_GrabArea"].Parent = Converted["_AFEMMax"]
Converted["_Open1"].Font = Enum.Font.SourceSans
Converted["_Open1"].Text = ""
Converted["_Open1"].TextColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Open1"].TextSize = 14
Converted["_Open1"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Open1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Open1"].BackgroundTransparency = 1
Converted["_Open1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Open1"].BorderSizePixel = 0
Converted["_Open1"].Interactable = false
Converted["_Open1"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Open1"].Size = UDim2.new(0, 70, 0, 70)
Converted["_Open1"].ZIndex = 99
Converted["_Open1"].Name = "Open"
Converted["_Open1"].Parent = Converted["_AFEMMax"]
Converted["_Notifications"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Notifications"].BackgroundTransparency = 1
Converted["_Notifications"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Notifications"].BorderSizePixel = 0
Converted["_Notifications"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Notifications"].Name = "Notifications"
Converted["_Notifications"].Parent = Converted["_AFEMMax"]
Converted["_UIListLayout38"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout38"].VerticalAlignment = Enum.VerticalAlignment.Bottom
Converted["_UIListLayout38"].Parent = Converted["_Notifications"]
Converted["_NotificationContainer"].AnchorPoint = Vector2.new(0, 1)
Converted["_NotificationContainer"].AutomaticSize = Enum.AutomaticSize.X
Converted["_NotificationContainer"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_NotificationContainer"].BackgroundTransparency = 1
Converted["_NotificationContainer"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_NotificationContainer"].BorderSizePixel = 0
Converted["_NotificationContainer"].Visible = false
Converted["_NotificationContainer"].Name = "NotificationContainer"
Converted["_NotificationContainer"].Parent = Converted["_Notifications"]
Converted["_Frame"].AnchorPoint = Vector2.new(0, 1)
Converted["_Frame"].AutomaticSize = Enum.AutomaticSize.XY
Converted["_Frame"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Frame"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Frame"].BorderSizePixel = 0
Converted["_Frame"].Position = UDim2.new(-1.5, 0, 1, 0)
Converted["_Frame"].Size = UDim2.new(0, 200, 0, 100)
Converted["_Frame"].Parent = Converted["_NotificationContainer"]
Converted["_UICorner62"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner62"].Parent = Converted["_Frame"]
Converted["_UIGradient4"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
}
Converted["_UIGradient4"].Rotation = -90
Converted["_UIGradient4"].Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.45625001192092896),
	NumberSequenceKeypoint.new(1, 1)
}
Converted["_UIGradient4"].Parent = Converted["_Frame"]
Converted["_UIStroke26"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke26"].Thickness = 1.600000023841858
Converted["_UIStroke26"].Parent = Converted["_Frame"]
Converted["_UIPadding53"].PaddingBottom = UDim.new(0, 10)
Converted["_UIPadding53"].PaddingLeft = UDim.new(0, 12)
Converted["_UIPadding53"].PaddingRight = UDim.new(0, 12)
Converted["_UIPadding53"].PaddingTop = UDim.new(0, 10)
Converted["_UIPadding53"].Parent = Converted["_Frame"]
Converted["_UIListLayout39"].Padding = UDim.new(0, 6)
Converted["_UIListLayout39"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout39"].Parent = Converted["_Frame"]
Converted["_Title2"].Font = Enum.Font.GothamBold
Converted["_Title2"].Text = "Notification"
Converted["_Title2"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Title2"].TextSize = 20
Converted["_Title2"].TextWrapped = true
Converted["_Title2"].AutomaticSize = Enum.AutomaticSize.XY
Converted["_Title2"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Title2"].BackgroundTransparency = 1
Converted["_Title2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Title2"].BorderSizePixel = 0
Converted["_Title2"].Name = "Title"
Converted["_Title2"].Parent = Converted["_Frame"]
Converted["_Body"].Font = Enum.Font.Gotham
Converted["_Body"].Text = "Notification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification bodyNotification body"
Converted["_Body"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Body"].TextSize = 12
Converted["_Body"].TextWrapped = true
Converted["_Body"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_Body"].AutomaticSize = Enum.AutomaticSize.Y
Converted["_Body"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Body"].BackgroundTransparency = 1
Converted["_Body"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Body"].BorderSizePixel = 0
Converted["_Body"].Size = UDim2.new(0, 250, 0, 0)
Converted["_Body"].Name = "Body"
Converted["_Body"].Parent = Converted["_Frame"]
Converted["_UIPadding54"].Parent = Converted["_NotificationContainer"]
Converted["_UIPadding55"].PaddingBottom = UDim.new(0, 16)
Converted["_UIPadding55"].PaddingLeft = UDim.new(0, 16)
Converted["_UIPadding55"].PaddingRight = UDim.new(0, 16)
Converted["_UIPadding55"].PaddingTop = UDim.new(0, 16)
Converted["_UIPadding55"].Parent = Converted["_Notifications"]
Converted["_FloatingButtons"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_FloatingButtons"].BackgroundTransparency = 1
Converted["_FloatingButtons"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_FloatingButtons"].BorderSizePixel = 0
Converted["_FloatingButtons"].Size = UDim2.new(1, 0, 1, 0)
Converted["_FloatingButtons"].ZIndex = -1
Converted["_FloatingButtons"].Name = "FloatingButtons"
Converted["_FloatingButtons"].Parent = Converted["_AFEMMax"]
Converted["_Sample2"].Font = Enum.Font.Gotham
Converted["_Sample2"].Text = ""
Converted["_Sample2"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Sample2"].TextScaled = true
Converted["_Sample2"].TextSize = 14
Converted["_Sample2"].TextWrapped = true
Converted["_Sample2"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Sample2"].BackgroundTransparency = 0.6499999761581421
Converted["_Sample2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Sample2"].BorderSizePixel = 0
Converted["_Sample2"].Size = UDim2.new(0, 200, 0, 50)
Converted["_Sample2"].Visible = false
Converted["_Sample2"].Name = "Sample"
Converted["_Sample2"].Parent = Converted["_FloatingButtons"]
Converted["_UICorner63"].CornerRadius = UDim.new(0, 10)
Converted["_UICorner63"].Parent = Converted["_Sample2"]
Converted["_UIPadding56"].PaddingBottom = UDim.new(0, 3)
Converted["_UIPadding56"].PaddingLeft = UDim.new(0, 3)
Converted["_UIPadding56"].PaddingRight = UDim.new(0, 3)
Converted["_UIPadding56"].PaddingTop = UDim.new(0, 3)
Converted["_UIPadding56"].Parent = Converted["_Sample2"]
Converted["_UIStroke27"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke27"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke27"].Thickness = 2
Converted["_UIStroke27"].Parent = Converted["_Sample2"]
Converted["_ImageLabel"].Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Converted["_ImageLabel"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ImageLabel"].BackgroundTransparency = 1
Converted["_ImageLabel"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ImageLabel"].BorderSizePixel = 0
Converted["_ImageLabel"].Size = UDim2.new(1, 0, 1, 0)
Converted["_ImageLabel"].Parent = Converted["_Sample2"]
Converted["_UIPadding57"].PaddingBottom = UDim.new(0, 32)
Converted["_UIPadding57"].PaddingLeft = UDim.new(0, 32)
Converted["_UIPadding57"].PaddingRight = UDim.new(0, 32)
Converted["_UIPadding57"].PaddingTop = UDim.new(0, 32)
Converted["_UIPadding57"].Parent = Converted["_FloatingButtons"]
Converted["_Update"].Name = "Update"
Converted["_Update"].Parent = Converted["_FloatingButtons"]
Converted["_UIGridLayout2"].CellPadding = UDim2.new(0, 8, 0, 8)
Converted["_UIGridLayout2"].CellSize = UDim2.new(0, 40, 0, 40)
Converted["_UIGridLayout2"].FillDirectionMaxCells = 5
Converted["_UIGridLayout2"].HorizontalAlignment = Enum.HorizontalAlignment.Right
Converted["_UIGridLayout2"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIGridLayout2"].Parent = Converted["_FloatingButtons"]
Converted["_QuickSelectorFrame"].GroupTransparency = 1
Converted["_QuickSelectorFrame"].AnchorPoint = Vector2.new(0.5, 0)
Converted["_QuickSelectorFrame"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_QuickSelectorFrame"].BackgroundTransparency = 0.5
Converted["_QuickSelectorFrame"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_QuickSelectorFrame"].BorderSizePixel = 0
Converted["_QuickSelectorFrame"].Interactable = false
Converted["_QuickSelectorFrame"].Position = UDim2.new(0.5, 0, 0, -160)
Converted["_QuickSelectorFrame"].Size = UDim2.new(1, 0, 0, 150)
Converted["_QuickSelectorFrame"].Name = "QuickSelectorFrame"
Converted["_QuickSelectorFrame"].Parent = Converted["_AFEMMax"]
Converted["_UIStroke28"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke28"].Thickness = 2.700000047683716
Converted["_UIStroke28"].Parent = Converted["_QuickSelectorFrame"]
Converted["_UIPadding58"].PaddingBottom = UDim.new(0, 16)
Converted["_UIPadding58"].PaddingLeft = UDim.new(0, 8)
Converted["_UIPadding58"].PaddingRight = UDim.new(0, 8)
Converted["_UIPadding58"].PaddingTop = UDim.new(0, 16)
Converted["_UIPadding58"].Parent = Converted["_QuickSelectorFrame"]
Converted["_ScrollingFrame"].AutomaticCanvasSize = Enum.AutomaticSize.X
Converted["_ScrollingFrame"].CanvasSize = UDim2.new(0, 0, 0, 0)
Converted["_ScrollingFrame"].ScrollBarThickness = 0
Converted["_ScrollingFrame"].Active = true
Converted["_ScrollingFrame"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_ScrollingFrame"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ScrollingFrame"].BackgroundTransparency = 1
Converted["_ScrollingFrame"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ScrollingFrame"].BorderSizePixel = 0
Converted["_ScrollingFrame"].ClipsDescendants = false
Converted["_ScrollingFrame"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_ScrollingFrame"].Size = UDim2.new(1, 0, 1, 0)
Converted["_ScrollingFrame"].Parent = Converted["_QuickSelectorFrame"]
Converted["_UIListLayout40"].Padding = UDim.new(0, 16)
Converted["_UIListLayout40"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout40"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIListLayout40"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout40"].VerticalAlignment = Enum.VerticalAlignment.Center
Converted["_UIListLayout40"].Parent = Converted["_ScrollingFrame"]
Converted["_Sample3"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Sample3"].BackgroundTransparency = 0.699999988079071
Converted["_Sample3"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Sample3"].BorderSizePixel = 0
Converted["_Sample3"].Size = UDim2.new(0, 100, 1, 0)
Converted["_Sample3"].Visible = false
Converted["_Sample3"].Name = "Sample"
Converted["_Sample3"].Parent = Converted["_ScrollingFrame"]
Converted["_UIAspectRatioConstraint6"].AspectType = Enum.AspectType.ScaleWithParentSize
Converted["_UIAspectRatioConstraint6"].DominantAxis = Enum.DominantAxis.Height
Converted["_UIAspectRatioConstraint6"].Parent = Converted["_Sample3"]
Converted["_UICorner64"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner64"].Parent = Converted["_Sample3"]
Converted["_UIStroke29"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke29"].Thickness = 2.700000047683716
Converted["_UIStroke29"].Parent = Converted["_Sample3"]
Converted["_UIPadding59"].PaddingBottom = UDim.new(0, 8)
Converted["_UIPadding59"].PaddingLeft = UDim.new(0, 8)
Converted["_UIPadding59"].PaddingRight = UDim.new(0, 8)
Converted["_UIPadding59"].PaddingTop = UDim.new(0, 8)
Converted["_UIPadding59"].Parent = Converted["_Sample3"]
Converted["_Thumbnail1"].Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Converted["_Thumbnail1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Thumbnail1"].BackgroundTransparency = 1
Converted["_Thumbnail1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Thumbnail1"].BorderSizePixel = 0
Converted["_Thumbnail1"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Thumbnail1"].Name = "Thumbnail"
Converted["_Thumbnail1"].Parent = Converted["_Sample3"]
Converted["_UIScale13"].Parent = Converted["_Sample3"]
Converted["_Tooltip"].GroupTransparency = 1
Converted["_Tooltip"].AnchorPoint = Vector2.new(0.5, 0.7799999713897705)
Converted["_Tooltip"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Tooltip"].BackgroundTransparency = 1
Converted["_Tooltip"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Tooltip"].BorderSizePixel = 0
Converted["_Tooltip"].Size = UDim2.new(0, 150, 0, 102)
Converted["_Tooltip"].Name = "Tooltip"
Converted["_Tooltip"].Parent = Converted["_AFEMMax"]
Converted["_Highlight"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Highlight"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Highlight"].BackgroundTransparency = 1
Converted["_Highlight"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Highlight"].BorderSizePixel = 0
Converted["_Highlight"].Position = UDim2.new(0.5, 0, 0.810000002, 0)
Converted["_Highlight"].Size = UDim2.new(0, 50, 0, 50)
Converted["_Highlight"].Name = "Highlight"
Converted["_Highlight"].Parent = Converted["_Tooltip"]
Converted["_UIStroke30"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke30"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke30"].Thickness = 2
Converted["_UIStroke30"].Parent = Converted["_Highlight"]
Converted["_UICorner65"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner65"].Parent = Converted["_Highlight"]
Converted["_UIPadding60"].PaddingBottom = UDim.new(0, 2)
Converted["_UIPadding60"].Parent = Converted["_Tooltip"]
Converted["_Text"].AnchorPoint = Vector2.new(0.5, 0)
Converted["_Text"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Text"].BackgroundTransparency = 0.6499999761581421
Converted["_Text"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Text"].BorderSizePixel = 0
Converted["_Text"].Position = UDim2.new(0.5, 0, 0, 5)
Converted["_Text"].Size = UDim2.new(1, -20, 0, 50)
Converted["_Text"].Name = "Text"
Converted["_Text"].Parent = Converted["_Tooltip"]
Converted["_UICorner66"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner66"].Parent = Converted["_Text"]
Converted["_UIStroke31"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke31"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke31"].Parent = Converted["_Text"]
Converted["_TextLabel13"].Font = Enum.Font.Gotham
Converted["_TextLabel13"].RichText = true
Converted["_TextLabel13"].Text = "Text"
Converted["_TextLabel13"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel13"].TextScaled = true
Converted["_TextLabel13"].TextSize = 14
Converted["_TextLabel13"].TextWrapped = true
Converted["_TextLabel13"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel13"].BackgroundTransparency = 1
Converted["_TextLabel13"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel13"].BorderSizePixel = 0
Converted["_TextLabel13"].Size = UDim2.new(1, 0, 1, 0)
Converted["_TextLabel13"].Parent = Converted["_Text"]
Converted["_UIPadding61"].PaddingBottom = UDim.new(0, 8)
Converted["_UIPadding61"].PaddingLeft = UDim.new(0, 8)
Converted["_UIPadding61"].PaddingRight = UDim.new(0, 8)
Converted["_UIPadding61"].PaddingTop = UDim.new(0, 8)
Converted["_UIPadding61"].Parent = Converted["_Text"]
Converted["_UIScale14"].Scale = 1.2000000476837158
Converted["_UIScale14"].Parent = Converted["_Tooltip"]

-- Module Scripts:
local module_scripts = {}
do -- Module: StarterGui.AFEMMax.FUNCTIONS
    local script = Instance.new("ModuleScript")
    script.Name = "FUNCTIONS"
    script.Parent = Converted["_AFEMMax"]
    local function module_script()
		local FunctionsModule = {}

		repeat task.wait() until getgenv().AFEMLibraries and getgenv().AFEMLibraries.MKE
		local TweenService = game:GetService("TweenService")
		local PointSave = getgenv().AFEMLibraries.PSV
		local Draggable = getgenv().AFEMLibraries.DGB
		local SpringTween = getgenv().AFEMLibraries.SBT
		local ClickAndHold = getgenv().AFEMLibraries.CAH
		local MarketplaceEngine = getgenv().AFEMLibraries.MKE
		local AIEngine = getgenv().AFEMLibraries.AIG
		local ParticleEffects = getgenv().AFEMLibraries.PRF

		local PointSaveAFEM = PointSave.new("AFEMMaxConf")
		local MainEquippedPack = nil
		local CategoryEquippedPacks = {}

		local UseScale = true
		if PointSaveAFEM:get("settings_perfAvoidScale") == "1" then
			UseScale = false
		end

		local PickerProvider = "floating"
		local HttpService = game:GetService("HttpService")

		function FunctionsModule.PlayAnimation(animationId)
			local animation = Instance.new("Animation")
			animation.Name = "AFEMInvokedEmote"
			animation.AnimationId = animationId

			local animator = game.Players.LocalPlayer.Character.Humanoid:FindFirstChild("Animator")
			local animate = game.Players.LocalPlayer.Character:FindFirstChild("Animate")
			animate.PlayEmote:Invoke(animation)
		end

		function FunctionsModule.PullList()
			local http = game:GetService("HttpService")

			local emoteList
			local packList

			local success, result = pcall(function()
				print("[AFEM] - Pulling emotes from GitHub...")
				emoteList = http:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Joystickplays/AFEM/refs/heads/main/emotes.json"))
			end)
			if not success then
				print("[AFEM] - Getting from website failed. Using fallback...")
				emoteList = http:JSONDecode('[{"id":14353423348,"animationid":"http://www.roblox.com/asset/?id=14352343065","name":"BabyQueen-BouncyTwirl"},{"id":14353421343,"animationid":"http://www.roblox.com/asset/?id=14352340648","name":"BabyQueen-FaceFrame"},{"id":16553249658,"animationid":"http://www.roblox.com/asset/?id=16553163212","name":"MaeStephens-PianoHands"}]')
			end
			print("[AFEM] - Emote list listed.")

			success, result = pcall(function()
				print("[AFEM] - Pulling animation packs from GitHub...")
				packList = http:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Joystickplays/AFEM/refs/heads/main/animationpacks.json"))
			end)
			if not success then
				print("[AFEM] - Getting from website failed. Using fallback...")
				packList = http:JSONDecode('[{"_comment":"All animation IDs has been pulled independently by the YARHM Team. If you are gonna use this for your own emotes menu, please credit us. We will be updating this list periodically and automatically."},{"Animations":{"idle":{"Animation2":"http://www.roblox.com/asset/?id=10921248831","Animation1":"http://www.roblox.com/asset/?id=10921248039"},"climb":{"ClimbAnim":"http://www.roblox.com/asset/?id=10921247141"},"run":{"RunAnim":"http://www.roblox.com/asset/?id=10921250460"},"swim":{"Swim":"http://www.roblox.com/asset/?id=10921253142"},"swimidle":{"SwimIdle":"http://www.roblox.com/asset/?id=10921253767"},"jump":{"JumpAnim":"http://www.roblox.com/asset/?id=10921252123"},"fall":{"FallAnim":"http://www.roblox.com/asset/?id=10921251156"},"pose":{"RobotPose":"http://www.roblox.com/asset/?id=10921249579"},"walk":{"WalkAnim":"http://www.roblox.com/asset/?id=10921255446"}},"BundleId":82,"Name":"Robot ","ProductId":8429510719773869}]')
			end
			print("[AFEM] - Animation packs listed.")

			print("[AFEM] - Finding added custom emotes...")
			if PointSaveAFEM:get("ExtraEmotes") then
				local extraEmotes = http:JSONDecode(PointSaveAFEM:get("ExtraEmotes"), "[]")
				table.move(extraEmotes, 1, #extraEmotes, #emoteList + 1, emoteList)
			end

			getgenv().AFEMListing = {}
			getgenv().AFEMListing.Emotes = emoteList
			getgenv().AFEMListing.AnimationPacks = packList
		end

		local ItemSelect = script.Parent.Menu.Area.ItemSelect
		local EmotesCurrentPage = 1
		local EmoteSearchQuery = ""
		local AnimPacksCurrentPage = 1
		local ItemsPerPage = 21

		local function GetPagination(list, perPage, currentPage)
			local totalItems = #list
			local totalPages = math.ceil(totalItems / perPage)
			return {
				totalPages = totalPages,
				currentPage = currentPage
			}
		end

		function FunctionsModule.GetEmotePagination()
			repeat task.wait() until getgenv().AFEMListing
			local emoteList = getgenv().AFEMListing and getgenv().AFEMListing.Emotes or {}
			return GetPagination(emoteList, ItemsPerPage, EmotesCurrentPage)
		end

		function FunctionsModule.GetAnimPackPagination()
			repeat task.wait() until getgenv().AFEMListing
			local animPackList = getgenv().AFEMListing and getgenv().AFEMListing.AnimationPacks or {}
			return GetPagination(animPackList, ItemsPerPage, AnimPacksCurrentPage)
		end

		local function LevenshteinDistance(str1, str2)
			local len1 = #str1
			local len2 = #str2
			local matrix = {}
			for i = 0, len1 do matrix[i] = {}; matrix[i][0] = i end
			for j = 0, len2 do matrix[0][j] = j end

			for i = 1, len1 do
				for j = 1, len2 do
					local cost = (str1:sub(i, i) == str2:sub(j, j)) and 0 or 1
					matrix[i][j] = math.min(
						matrix[i - 1][j] + 1,
						matrix[i][j - 1] + 1,
						matrix[i - 1][j - 1] + cost
					)
				end
			end
			return matrix[len1][len2]
		end

		local function GetInitials(str)
			local initials = ""
			for word in str:gmatch("%w+") do
				initials = initials .. word:sub(1, 1)
			end
			return initials
		end

		local function SplitWords(str)
			local words = {}
			for word in str:gmatch("%w+") do
				table.insert(words, word)
			end
			return words
		end

		function FunctionsModule.FuzzySearch(query, items, minConfidence)
			query = query:lower()
			minConfidence = minConfidence or 0.5
			local results = {}

			for _, item in ipairs(items) do
				local normalized = item:lower()
				local words = SplitWords(normalized)
				local initials = GetInitials(normalized)
				local start = normalized:find(query, 1, true)

				local relevant = start and normalized:sub(start, start + #query - 1) or normalized
				local distance = LevenshteinDistance(query, relevant)
				local maxLen = math.max(#query, #relevant)
				local confidence = 1 - (distance / maxLen)

				if normalized == query then
					confidence = confidence + 0.5
				elseif normalized:sub(1, #query) == query then
					confidence = confidence + 0.25
				elseif start then
					confidence = confidence + 0.15
				end

				if initials == query then
					confidence = confidence + 0.5
				elseif initials:sub(1, #query) == query then
					confidence = confidence + 0.2
				end

				for _, word in ipairs(words) do
					if word:sub(1, #query) == query then
						confidence = confidence + 0.1
						break
					end
				end

				if confidence >= minConfidence then
					table.insert(results, {
						item = item,
						confidence = math.min(confidence, 1),
						isExact = normalized == query
					})
				end
			end

			table.sort(results, function(a, b)
				if a.isExact ~= b.isExact then
					return a.isExact
				elseif a.confidence ~= b.confidence then
					return a.confidence > b.confidence
				else
					return a.item < b.item
				end
			end)

			local sortedItems = {}
			for _, result in ipairs(results) do
				table.insert(sortedItems, { item = result.item, confidence = result.confidence })
			end
			return sortedItems
		end

		function FunctionsModule.SearchEmotes(query, minConfidence)
			local emoteList = getgenv().AFEMListing and getgenv().AFEMListing.Emotes or {}
			local names = {}
			for _, emote in ipairs(emoteList) do
				if not emote["_comment"] then
					table.insert(names, emote.name)
				end
			end
			local results = FunctionsModule.FuzzySearch(query, names, minConfidence)
			local filtered = {}
			for _, result in ipairs(results) do
				for _, emote in ipairs(emoteList) do
					if emote.name == result.item then
						table.insert(filtered, emote)
						break
					end
				end
			end
			return filtered
		end

		local function CreatePaginatedListing(list, area, page, perPage, searchQuery, buttonSetup)
			local filteredList = list
			if searchQuery and #searchQuery > 0 then
				local names = {}
				for _, item in ipairs(list) do
					if not item["_comment"] then
						table.insert(names, item.name)
					end
				end
				local results = FunctionsModule.FuzzySearch(searchQuery, names)
				local temp = {}
				for _, result in ipairs(results) do
					for _, item in ipairs(list) do
						if item.name == result.item then
							table.insert(temp, item)
							break
						end
					end
				end
				filteredList = temp
			end
			local totalItems = #filteredList
			local totalPages = math.ceil(totalItems / perPage)
			if page < 1 then page = 1 end
			if page > totalPages then page = totalPages end

			for _, v in ipairs(area:GetChildren()) do
				if v:IsA("Frame") or v.Name == "NextPageButton" or v.Name == "PrevPageButton" then
					v:Destroy()
				end
			end

			local startIdx = (page - 1) * perPage + 1
			local endIdx = math.min(page * perPage, totalItems)

			for i = startIdx, endIdx do
				local item = filteredList[i]
				if item and not item["_comment"] then
					buttonSetup(item, area, i)
				end
			end
		end

		local function ClearEmotesPaginationPages(amountOfPages)
			amountOfPages = amountOfPages or FunctionsModule.GetEmotePagination().totalPages
			local paginationBar = ItemSelect.Emotes.PaginationBar
			for _, v in ipairs(paginationBar:GetChildren()) do
				if v:IsA("Frame") and v.Name:sub(1, 4) == "Page" then
					local pageNum = tonumber(v.Name:sub(5))
					if pageNum and pageNum > amountOfPages then
						v:Destroy()
					end
				end
			end
		end

		local ItemDetailFrame = script.Parent.Menu.ItemDetail
		local IDFPosTween = SpringTween.new(ItemDetailFrame, "Position", 0.5, 26, 100)
		local IDFAPointTween = SpringTween.new(ItemDetailFrame, "AnchorPoint", 0.5, 26, 100)
		local IDFSizeTween = SpringTween.new(ItemDetailFrame, "Size", 1, 18, 100)

		local LastOrigin = Instance.new("TextButton")
		local EmoteDetailPageConnections = {
			favorite = nil,
			play = nil
		}

		function FunctionsModule.EmoteDetailPage(emote, origin, alternateAnimID, playFunc)
			ItemDetailFrame.Item.Details.ItemName.Text = emote["name"]
			ItemDetailFrame.Item.Details.ItemDescription.Text = emote["description"] or ""
			ItemDetailFrame.Item.AvatarPreview.PlayEmote:Fire(emote["animationid"] or alternateAnimID)

			LastOrigin = origin
			script.Parent.Menu.Area.Interactable = false

			IDFAPointTween:Start(); IDFPosTween:Start(); IDFSizeTween:Start()
			IDFAPointTween:SetOffset(Vector2.zero)
			IDFPosTween:SetOffset(UDim2.fromOffset(origin.AbsolutePosition.X, origin.AbsolutePosition.Y + game:GetService("GuiService"):GetGuiInset().Y))
			IDFSizeTween:SetOffset(UDim2.fromOffset(origin.AbsoluteSize.X, origin.AbsoluteSize.Y))

			IDFAPointTween:SetGoal(Vector2.zero)
			IDFPosTween:SetGoal(UDim2.fromOffset(origin.AbsolutePosition.X, origin.AbsolutePosition.Y + game:GetService("GuiService"):GetGuiInset().Y))
			IDFSizeTween:SetGoal(UDim2.fromOffset(origin.AbsoluteSize.X, origin.AbsoluteSize.Y))

			task.spawn(function()
				origin.Position = UDim2.new(0.5, 0, 1.6, 0)
			end)

			ItemDetailFrame.Visible = true

			IDFAPointTween:SetGoal(Vector2.new(0.5, 0.5))
			IDFPosTween:SetGoal(UDim2.fromScale(0.5, 0.5))
			IDFSizeTween:SetGoal(UDim2.fromOffset(400, 350))

			if UseScale then
				TweenService:Create(script.Parent.Menu.Area.UIScale, TweenInfo.new(0.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Scale = 0.95
				}):Play()
			else
				TweenService:Create(script.Parent.Menu.Area, TweenInfo.new(0.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Position = UDim2.fromScale(0.5, 0.65)
				}):Play()
			end
			TweenService:Create(script.Parent.Menu.Backdrop, TweenInfo.new(0.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.5
			}):Play()

			ItemDetailFrame.Actions.Close.MouseButton1Click:Connect(function()
				FunctionsModule.CloseEmoteDetailPage()
			end)

			local favoritesData = {}
			if PointSaveAFEM:get("favoriteEmoteEntries") then
				favoritesData = HttpService:JSONDecode(PointSaveAFEM:get("favoriteEmoteEntries"))
			end

			local function FindEmote(data, emoteToFind)
				for idx, emote in ipairs(data) do
					if emote.name == emoteToFind.name then
						return idx
					end
				end
				return nil
			end

			if FindEmote(favoritesData, emote) then
				ItemDetailFrame.Actions.Favorites.Text = "FAVORITED"
			else
				ItemDetailFrame.Actions.Favorites.Text = "FAVORITE"
			end

			EmoteDetailPageConnections.copyAnimId = ItemDetailFrame.Actions.CopyAnimID.MouseButton1Click:Connect(function()
				local success = pcall(function() setclipboard(emote["animationid"] or alternateAnimID) end)
				if not success then warn(emote["animationid"]) end
				FunctionsModule.Notification("Animation ID copied", "The animation ID has been copied to your clipboard!")
			end)

			EmoteDetailPageConnections.floatingButton = ItemDetailFrame.Actions.FloatingButton.MouseButton1Click:Connect(function()
				local emoteClone = emote
				emoteClone["animationid"] = emote["animationid"] or alternateAnimID
				if PickerProvider == "floating" then
					FunctionsModule.CreateFloatingButton(emoteClone, true)
				elseif PickerProvider == "quicks" then
					FunctionsModule.CreateQuickSelectorEntry(emoteClone, true)
				end
			end)

			EmoteDetailPageConnections.favorite = ItemDetailFrame.Actions.Favorites.MouseButton1Click:Connect(function()
				local favoritesData = {}
				if PointSaveAFEM:get("favoriteEmoteEntries") then
					favoritesData = HttpService:JSONDecode(PointSaveAFEM:get("favoriteEmoteEntries"))
				end

				local emoteClone = emote
				emoteClone["animationid"] = emote["animationid"] or alternateAnimID

				local inserting = true
				if not FindEmote(favoritesData, emoteClone) then
					table.insert(favoritesData, emoteClone)
					local mouseLoc = game:GetService("UserInputService"):GetMouseLocation()
					ParticleEffects.new(script.Parent, {
						Origin = UDim2.new(0, mouseLoc.X, 0, mouseLoc.Y),
						Text = "⭐",
						Amount = 10,
						Velocity = Vector2.new(0, -200),
						VelocitySpread = 200,
						Gravity = Vector2.new(0, 400)
					})
				else
					inserting = false
					table.remove(favoritesData, FindEmote(favoritesData, emoteClone))
				end

				if inserting then
					ItemDetailFrame.Actions.Favorites.Text = "FAVORITED"
				else
					ItemDetailFrame.Actions.Favorites.Text = "FAVORITE"
				end

				PointSaveAFEM:set("favoriteEmoteEntries", HttpService:JSONEncode(favoritesData))
				FunctionsModule.RefreshEmotes(nil, nil, nil, nil, nil, true)
			end)

			EmoteDetailPageConnections.play = ItemDetailFrame.Actions.Play.MouseButton1Click:Connect(function()
				playFunc()
				FunctionsModule.Notification("Playing", "Played animation in the background.")
			end)
		end

		function FunctionsModule.CloseEmoteDetailPage()
			IDFPosTween:SetGoal(UDim2.fromScale(0.5, 2))
			task.wait(0.1)

			ItemDetailFrame.Visible = false

			TweenService:Create(LastOrigin, TweenInfo.new(0.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Position = UDim2.fromScale(0.5, 0.5)
			}):Play()

			script.Parent.Menu.Area.Interactable = true
			if UseScale then
				TweenService:Create(script.Parent.Menu.Area.UIScale, TweenInfo.new(0.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Scale = 1
				}):Play()
			else
				TweenService:Create(script.Parent.Menu.Area, TweenInfo.new(0.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Position = UDim2.fromScale(0.5, 0.55)
				}):Play()
			end
			TweenService:Create(script.Parent.Menu.Backdrop, TweenInfo.new(0.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				BackgroundTransparency = 1
			}):Play()

			IDFAPointTween:Stop(); IDFPosTween:Stop(); IDFSizeTween:Stop()

			if EmoteDetailPageConnections.play then
				EmoteDetailPageConnections.play:Disconnect()
				EmoteDetailPageConnections.play = nil
			end
			if EmoteDetailPageConnections.floatingButton then
				EmoteDetailPageConnections.floatingButton:Disconnect()
				EmoteDetailPageConnections.floatingButton = nil
			end
			if EmoteDetailPageConnections.copyAnimId then
				EmoteDetailPageConnections.copyAnimId:Disconnect()
				EmoteDetailPageConnections.copyAnimId = nil
			end
			if EmoteDetailPageConnections.favorite then
				EmoteDetailPageConnections.favorite:Disconnect()
				EmoteDetailPageConnections.favorite = nil
			end
		end

		local function GetAnimationPackFromBundleId(bundleId)
			if not bundleId then return nil end
			repeat task.wait() until getgenv().AFEMListing
			local animPackList = getgenv().AFEMListing and getgenv().AFEMListing.AnimationPacks or {}
			for _, pack in ipairs(animPackList) do
				if pack["BundleId"] == bundleId then
					return pack
				end
			end
			return nil
		end

		function FunctionsModule.GetPackFromID(bundleId)
			return GetAnimationPackFromBundleId(bundleId)
		end

		local function GetAnimatorScript()
			local character = game.Players.LocalPlayer.Character
			if not character then character = game.Players.LocalPlayer.CharacterAdded:Wait() end
			local humanoid = character:WaitForChild("Humanoid", 10)
			if not humanoid then warn("[AFEM] - No humanoid in character."); return end
			if humanoid.RigType.Name ~= "R15" then
				warn("[AFEM] - Your character is not R15")
				FunctionsModule.Notification("Your character needs to be R15.")
				return
			end
			local animateScript = character:FindFirstChild("Animate")
			if not animateScript then warn("[AFEM] - Your character does not have the Animate script!"); return end
			return animateScript
		end

		function FunctionsModule.LoadPack(save)
			if MainEquippedPack then
				FunctionsModule.ApplyPack(MainEquippedPack, false, save)
			end

			local animateScript = GetAnimatorScript()
			if not animateScript then return end

			for _, animObj in ipairs(animateScript:GetChildren()) do
				local categoryName = animObj.Name
				local savedOverride = PointSaveAFEM:get("AnimationPack_" .. categoryName)
				if savedOverride then
					FunctionsModule.ApplySingularAnimPack(savedOverride, categoryName, save)
				end
			end
		end

		function FunctionsModule.ApplyPack(bundleId, new, save)
			MainEquippedPack = bundleId
			local animPack = GetAnimationPackFromBundleId(tonumber(bundleId))
			if not animPack then
				warn("[AFEM] - Can't find this animation pack.")
				return
			end

			local animateScript = GetAnimatorScript()
			if not animateScript then return end

			for _, animObj in ipairs(animateScript:GetChildren()) do
				if animPack["Animations"][animObj.Name] then
					if new then
						PointSaveAFEM:remove("AnimationPack_" .. animObj.Name)
						CategoryEquippedPacks[animObj.Name] = nil
					end
					for _, animAsset in ipairs(animObj:GetChildren()) do
						if animPack["Animations"][animObj.Name][animAsset.Name] then
							animAsset.AnimationId = animPack["Animations"][animObj.Name][animAsset.Name]
						end
					end
				end
			end

			print("[AFEM] - Animation pack applied!")
			if save then
				local success, error = pcall(function()
					PointSaveAFEM:set("AnimationPackGLOBAL", tostring(bundleId))
					print("[AFEM] - Current main pack persistently saved")
				end)
				if not success then
					warn("[AFEM] - Failed to save persistent main pack, not supported?")
					warn(error)
				end
			end
		end

		function FunctionsModule.ApplySingularAnimPack(bundleId, category, save)
			local isAnimationAsset = false
			if not tonumber(bundleId) then isAnimationAsset = true end
			CategoryEquippedPacks[category] = bundleId
			local animPack
			if not isAnimationAsset then
				animPack = GetAnimationPackFromBundleId(tonumber(bundleId))
			end
			if not animPack and not isAnimationAsset then
				warn("[AFEM] - Can't find this animation pack.")
				return
			end

			if isAnimationAsset then
				animPack = bundleId
			end

			local animateScript = GetAnimatorScript()
			if not animateScript then return end

			if not isAnimationAsset then
				for _, animObj in ipairs(animateScript:GetChildren()) do
					if animPack["Animations"][animObj.Name] and animObj.Name == category then
						for _, animAsset in ipairs(animObj:GetChildren()) do
							if animPack["Animations"][animObj.Name][animAsset.Name] then
								animAsset.AnimationId = animPack["Animations"][animObj.Name][animAsset.Name]
							end
						end
					end
				end
			else
				for _, animObj in ipairs(animateScript:GetChildren()) do
					if animObj.Name == category then
						for _, animAsset in ipairs(animObj:GetChildren()) do
							animAsset.AnimationId = animPack
						end
					end
				end
			end

			print("[AFEM] - Animation pack (single category) applied!")
			if save then
				local success, error = pcall(function()
					PointSaveAFEM:set("AnimationPack_" .. category, tostring(bundleId))
					print("[AFEM] - Single category pack persistently saved")
				end)
				if not success then
					warn("[AFEM] - Failed to save persistent category pack, not supported?")
					warn(error)
				end
			end
		end

		game.Players.LocalPlayer.CharacterAdded:Connect(function()
			FunctionsModule.LoadPack()
		end)

		function FunctionsModule.ShowTooltip(target, text)
			local tooltipClone = script.Parent.Tooltip:Clone()
			local targetAbsPos = target.AbsolutePosition
			local targetAbsSize = target.AbsoluteSize
			local topBarOffset = game:GetService("GuiService"):GetGuiInset()

			tooltipClone.Text.TextLabel.Text = text
			tooltipClone.Highlight.Size = UDim2.fromOffset(targetAbsSize.X + 10, targetAbsSize.Y + 10)
			tooltipClone.Position = UDim2.fromOffset(targetAbsPos.X + targetAbsSize.X / 2, (targetAbsPos.Y + targetAbsSize.Y / 2) + topBarOffset.Y)

			tooltipClone.Parent = script.Parent

			TweenService:Create(tooltipClone, TweenInfo.new(0.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				GroupTransparency = 0
			}):Play()
			TweenService:Create(tooltipClone.UIScale, TweenInfo.new(0.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Scale = 1
			}):Play()

			task.spawn(function()
				tooltipClone.Highlight.MouseEnter:Wait()
				task.wait(1)
				TweenService:Create(tooltipClone, TweenInfo.new(0.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					GroupTransparency = 1
				}):Play()
				TweenService:Create(tooltipClone.UIScale, TweenInfo.new(0.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Scale = 0.9
				}):Play()
				task.wait(0.7)
				tooltipClone:Destroy()
			end)
		end

		local SelectedButton = nil

		function FunctionsModule.Modal(title, description, buttons, input, needsResult)
			if not title then title = "Alert" end
			if not description then description = "" end
			if not buttons then buttons = {} end

			local modal = script.Parent.Modal
			modal.Container.Visual.Title.Text = title
			modal.Container.Visual.Desc.Text = description

			for _, already in ipairs(modal.Container.Buttons:GetChildren()) do
				if already:IsA("TextButton") and already.Name ~= "Sample" then
					already:Destroy()
				end
			end

			for _, button in ipairs(buttons) do
				local clone = modal.Container.Buttons.Sample:Clone()
				clone.Text = button
				clone.Name = button
				clone.Parent = modal.Container.Buttons
				clone.Visible = true

				clone.MouseButton1Click:Connect(function()
					if needsResult then SelectedButton = button end
					FunctionsModule.ModalClose()
				end)
			end

			local inputBox = modal.Container.Input
			if input then
				inputBox.Visible = true
				inputBox.TextBox.PlaceholderText = input["placeholder"]
				inputBox.TextBox.Text = input["prefill"]
			else
				inputBox.Visible = false
			end

			local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
			TweenService:Create(modal, tweenInfo, { BackgroundTransparency = 0.7 }):Play()
			TweenService:Create(modal.Container, tweenInfo, { GroupTransparency = 0 }):Play()
			TweenService:Create(modal.Container.UIScale, tweenInfo, { Scale = 1 }):Play()
			TweenService:Create(modal.Container.UIStroke, tweenInfo, { Transparency = 0.8 }):Play()

			modal.Container.Interactable = true
		end

		function FunctionsModule.ModalClose()
			local modal = script.Parent.Modal
			local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
			TweenService:Create(modal, tweenInfo, { BackgroundTransparency = 1 }):Play()
			TweenService:Create(modal.Container, tweenInfo, { GroupTransparency = 1 }):Play()
			TweenService:Create(modal.Container.UIScale, tweenInfo, { Scale = 1.1 }):Play()
			TweenService:Create(modal.Container.UIStroke, tweenInfo, { Transparency = 1 }):Play()
			modal.Container.Interactable = false
		end

		function FunctionsModule.WaitForModal()
			repeat task.wait() until SelectedButton
			FunctionsModule.ModalClose()
			local selected = SelectedButton
			SelectedButton = nil
			return {
				selected = selected,
				input = script.Parent.Modal.Container.Input.TextBox.Text
			}
		end

		function FunctionsModule.Notification(title, body, duration)
			task.spawn(function()
				local notif = script.Parent.Notifications.NotificationContainer:Clone()
				notif.Name = "Notif"
				notif.Frame.Title.Text = title
				notif.Frame.Body.Text = body
				notif.Parent = script.Parent.Notifications
				notif.Visible = true

				task.wait()
				local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
				TweenService:Create(notif, tweenInfo, {
					Size = UDim2.new(0, 0, 0, notif.Frame.AbsoluteSize.Y + 16)
				}):Play()
				TweenService:Create(notif.UIPadding, tweenInfo, { PaddingTop = UDim.new(0, 16) }):Play()
				TweenService:Create(notif.Frame, tweenInfo, { Position = UDim2.new(0, 0, 1, 0) }):Play()

				task.wait(duration or 3)
				TweenService:Create(notif.Frame, tweenInfo, { Position = UDim2.new(-1.5, 0, 1, 0) }):Play()
				task.wait(0.3)
				notif:Destroy()
			end)
		end

		local OnUGC = false
		local MarketplaceEngine = MarketplaceEngine.new()

		function FunctionsModule.SwitchToUGC(enabled)
			OnUGC = enabled
			EmotesCurrentPage = 1

			if enabled then
				TweenService:Create(ItemSelect.Emotes.ActionBar.SwitchTabs.UGC, TweenInfo.new(0.1), {
					BackgroundTransparency = 0,
					TextColor3 = Color3.fromRGB(0, 0, 0)
				}):Play()
				TweenService:Create(ItemSelect.Emotes.ActionBar.SwitchTabs.Roblox, TweenInfo.new(0.1), {
					BackgroundTransparency = 1,
					TextColor3 = Color3.fromRGB(255, 255, 255)
				}):Play()
				MarketplaceEngine = MarketplaceEngine.new()
			else
				TweenService:Create(ItemSelect.Emotes.ActionBar.SwitchTabs.UGC, TweenInfo.new(0.1), {
					BackgroundTransparency = 1,
					TextColor3 = Color3.fromRGB(255, 255, 255)
				}):Play()
				TweenService:Create(ItemSelect.Emotes.ActionBar.SwitchTabs.Roblox, TweenInfo.new(0.1), {
					BackgroundTransparency = 0,
					TextColor3 = Color3.fromRGB(0, 0, 0)
				}):Play()
			end

			FunctionsModule.RefreshEmotes(nil, nil, false, nil, true)
		end

		local FetchPatience = 30
		local FetchAlreadyWaiting = false
		local AlreadyFetching = false
		local FetchQuery = nil

		local ShowingSuggestionBar = false
		local SuggestionBarSuggestions = {}
		local SuggestionBarFrame = script.Parent.Menu.Area.ItemSelect.Emotes.SearchSuggestion

		local function UpdateSuggestionBarVisibility()
			if ShowingSuggestionBar then
				for _, child in ipairs(SuggestionBarFrame:GetChildren()) do
					if child.Name == "Chip" then child:Destroy() end
				end

				TweenService:Create(SuggestionBarFrame, TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Size = UDim2.new(1, 0, 0, 25)
				}):Play()

				for idx, suggestion in ipairs(SuggestionBarSuggestions) do
					local chip = SuggestionBarFrame.ChipSample:Clone()
					chip.Visible = true
					chip.Clickable.Label.Text = suggestion
					chip.Name = "Chip"
					chip.Parent = SuggestionBarFrame

					task.spawn(function()
						task.wait(idx * 0.01)
						TweenService:Create(chip.Clickable, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
							Position = UDim2.new(0, 0, 0, 0)
						}):Play()
					end)

					chip.Clickable.MouseButton1Click:Connect(function()
						ItemSelect.Emotes.ActionBar.Search.Text = suggestion
					end)
				end
			else
				TweenService:Create(SuggestionBarFrame, TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Size = UDim2.new(1, 0, 0, 0)
				}):Play()
			end
		end

		local SearchSuggestionsFetching = false

		local function GetSearchSuggestions(query)
			if SearchSuggestionsFetching then return end
			SearchSuggestionsFetching = true

			local suggestions = AIEngine.requestSuggestions(query)
			SearchSuggestionsFetching = false

			if FetchQuery == query then
				SuggestionBarSuggestions = suggestions
				ShowingSuggestionBar = true
				UpdateSuggestionBarVisibility()
			end
		end

		function FunctionsModule.GetEmoteListFromMarketplace(query, nextPage, prevPage, instant)
			FetchQuery = query

			if AlreadyFetching then return 1 end
			if FetchAlreadyWaiting and not instant then
				FetchPatience = 30
				return 1
			end
			FetchAlreadyWaiting = true

			ItemSelect.Emotes.ActionBar.Spinner.Visible = true

			if not instant then
				repeat
					task.wait()
					FetchPatience = FetchPatience - 1
					ItemSelect.Emotes.ActionBar.TextLabel.Text = FetchPatience
				until FetchPatience < 1
			end
			FetchAlreadyWaiting = false
			AlreadyFetching = true

			local emoteList
			if not (nextPage or prevPage) then
				emoteList = MarketplaceEngine:FetchEmotes({ search = FetchQuery })
			elseif nextPage then
				emoteList = MarketplaceEngine:NextFetch()
			elseif prevPage then
				emoteList = MarketplaceEngine:PreviousFetch()
			end

			ShowingSuggestionBar = false
			UpdateSuggestionBarVisibility()

			if #FetchQuery > 3 and not (nextPage or prevPage) then
				task.spawn(function() GetSearchSuggestions(FetchQuery) end)
			end

			ItemSelect.Emotes.ActionBar.Spinner.Visible = false
			FetchPatience = 30
			AlreadyFetching = false

			return {
				listing = emoteList,
				numberOfPages = #MarketplaceEngine.cursorHistory,
				pageIndex = MarketplaceEngine.cursorIndex,
			}
		end

		function FunctionsModule.PickerProvider(floatingButtons, quickSelector)
			if floatingButtons then
				PickerProvider = "floating"
				script.Parent.Menu.ItemDetail.Actions.FloatingButton.Text = "FLOATING B."
				TweenService:Create(script.Parent.FloatingButtons, TweenInfo.new(0.5), {
					Position = UDim2.fromScale(0, 0)
				}):Play()
				return
			else
				TweenService:Create(script.Parent.FloatingButtons, TweenInfo.new(0.5), {
					Position = UDim2.fromScale(0, 1.5)
				}):Play()
			end

			PickerProvider = "quicks"
			script.Parent.Menu.ItemDetail.Actions.FloatingButton.Text = "QUICK S."
			task.wait()
			script.Parent.Menu.QuickSelectorIcon:Fire(quickSelector or false)
		end

		local FloatingButtonStore = {}
		if PointSaveAFEM:get("fbStore") then
			FloatingButtonStore = HttpService:JSONDecode(PointSaveAFEM:get("fbStore"))
		end

		function FunctionsModule.CreateFloatingButton(emote, notify)
			local function SaveStore()
				PointSaveAFEM:set("fbStore", HttpService:JSONEncode(FloatingButtonStore))
			end

			local floatingButtonCont = script.Parent.FloatingButtons

			if floatingButtonCont:FindFirstChild(emote.name) then
				floatingButtonCont:FindFirstChild(emote.name):Destroy()
				FloatingButtonStore[emote.id] = nil
				SaveStore()
				return
			end

			FloatingButtonStore[emote.id] = emote
			SaveStore()

			local floatingB = floatingButtonCont.Sample:Clone()
			floatingB.Name = emote.name
			floatingB.Visible = true
			floatingB.ImageLabel.Image = "rbxthumb://type=Asset&id=" .. emote.id .. "&w=420&h=420"
			floatingB.Parent = floatingButtonCont

			local dragB = Draggable.new(floatingB, floatingB, false, true)

			local function DragEnable()
				dragB:Enable()
				if FloatingButtonStore[emote.id].fBPosition then
					floatingB.Position = UDim2.fromOffset(
						FloatingButtonStore[emote.id].fBPosition.x,
						FloatingButtonStore[emote.id].fBPosition.y
					)
				else
					floatingB.Position = UDim2.fromOffset(50, 50)
				end

				dragB.Dragged = function(position)
					TweenService:Create(floatingB, TweenInfo.new(0.1), { Position = position }):Play()
				end

				dragB.DragEnded = function()
					FloatingButtonStore[emote.id].fBPosition = {
						x = floatingB.Position.X.Offset,
						y = floatingB.Position.Y.Offset
					}
					SaveStore()
				end
			end

			local function DragDisable()
				dragB:Disable()
				task.wait()
				floatingB.Position = UDim2.fromOffset(
					floatingB.AbsolutePosition.X - floatingB.AbsoluteSize.X,
					(floatingB.AbsolutePosition.Y + game:GetService("GuiService"):GetGuiInset().Y) - floatingB.AbsoluteSize.Y
				)
				FloatingButtonStore[emote.id].fBPosition = nil
				SaveStore()
			end

			if PointSaveAFEM:get("settings_fbPositioning") == "Freeform" then
				DragEnable()
			end

			script.Parent.FloatingButtons.Update.Event:Connect(function(freeform)
				if freeform then DragEnable() else DragDisable() end
			end)

			floatingB.Size = UDim2.fromOffset(40, 40)
			task.wait()
			floatingB.Position = UDim2.fromOffset(
				floatingB.AbsolutePosition.X - floatingB.AbsoluteSize.X,
				(floatingB.AbsolutePosition.Y + game:GetService("GuiService"):GetGuiInset().Y) - floatingB.AbsoluteSize.Y
			)

			floatingB.MouseButton1Click:Connect(function()
				FunctionsModule.PlayAnimation(emote.animationid)
			end)

			if notify then
				FunctionsModule.Notification("Created", "Floating button created.")
			end
		end

		local QuickSelectorStore = {}
		if PointSaveAFEM:get("qsStore") then
			QuickSelectorStore = HttpService:JSONDecode(PointSaveAFEM:get("qsStore"))
		end

		function FunctionsModule.CreateQuickSelectorEntry(emote, notify)
			local quickSelectorFrame = script.Parent.QuickSelectorFrame.ScrollingFrame

			local function SaveStore()
				PointSaveAFEM:set("qsStore", HttpService:JSONEncode(QuickSelectorStore))
			end

			if quickSelectorFrame:FindFirstChild(emote.name) then
				quickSelectorFrame:FindFirstChild(emote.name):Destroy()
				QuickSelectorStore[emote.id] = nil
				SaveStore()
				return
			end

			QuickSelectorStore[emote.id] = emote
			SaveStore()

			local quickSEntry = quickSelectorFrame.Sample:Clone()
			quickSEntry.Name = emote.name
			quickSEntry.Visible = true
			quickSEntry.Thumbnail.Image = "rbxthumb://type=Asset&id=" .. emote.id .. "&w=420&h=420"
			quickSEntry.Parent = quickSelectorFrame
			quickSEntry:SetAttribute("animID", emote.animationid)

			if notify then
				FunctionsModule.Notification("Created", "Quick selector entry created.")
			end
		end

		function FunctionsModule.RecreateFloatingButtonsFromStore()
			local store = {}
			if PointSaveAFEM:get("fbStore") then
				store = HttpService:JSONDecode(PointSaveAFEM:get("fbStore"))
			end
			for _, emote in pairs(store) do
				if emote then FunctionsModule.CreateFloatingButton(emote, false) end
			end
		end

		function FunctionsModule.RecreateQuickSelectorsFromStore()
			local store = {}
			if PointSaveAFEM:get("qsStore") then
				store = HttpService:JSONDecode(PointSaveAFEM:get("qsStore"))
			end
			for _, emote in pairs(store) do
				if emote then FunctionsModule.CreateQuickSelectorEntry(emote, false) end
			end
		end

		function FunctionsModule.RefreshEmotes(page, search, navigating, nextPage, instant, onlyFavorites)
			if page then EmotesCurrentPage = page end
			if search then EmoteSearchQuery = search end
			local area = ItemSelect.Emotes.Listing
			repeat task.wait() until getgenv().AFEMListing.Emotes

			local emoteList
			local marketplaceMetadata

			if PointSaveAFEM:get("favoriteEmoteEntries") then
				local favoritesData = HttpService:JSONDecode(PointSaveAFEM:get("favoriteEmoteEntries"))

				for _, child in ipairs(ItemSelect.Emotes.FavoritesSection.Listing:GetChildren()) do
					if child:IsA("Frame") then child:Destroy() end
				end

				for _, emote in ipairs(favoritesData) do
					local buttonClone = ItemSelect.ItemListTemplate:Clone()
					buttonClone.Name = emote["name"] .. "EMOTE"
					buttonClone.Size = UDim2.new(0, 200, 1, 0)
					buttonClone.Visible = true
					buttonClone.Parent = ItemSelect.Emotes.FavoritesSection.Listing
					buttonClone.Clickable.Details.Title.Text = emote["name"]
					buttonClone.Clickable.Thumbnail.Image = "rbxthumb://type=Asset&id=" .. emote["id"] .. "&w=420&h=420"

					if emote["description"] then
						buttonClone.Clickable.Details.Description.Text = emote["description"]
					end

					local function play()
						FunctionsModule.PlayAnimation(emote["animationid"])
					end

					buttonClone.Clickable.MouseButton1Click:Connect(function()
						play()
						script.Parent.Menu.MenuStateChange:Fire(false)
					end)

					buttonClone.Clickable.Details.Buttons.Play.MouseButton1Click:Connect(play)

					if emote["_special"] == "custom" then
						buttonClone.Clickable.UIStroke.CustomEffect.Enabled = true
					end
				end
			end

			if onlyFavorites then return end

			if OnUGC then
				local marketplaceListing
				if not navigating then
					marketplaceListing = FunctionsModule.GetEmoteListFromMarketplace(search ~= "" and search or "", false, false, instant)
				else
					marketplaceListing = FunctionsModule.GetEmoteListFromMarketplace(search ~= "" and search or "", nextPage, not nextPage, instant)
				end
				if marketplaceListing == 1 then return end
				emoteList = marketplaceListing.listing
				marketplaceMetadata = {
					totalPages = marketplaceListing.numberOfPages,
					currentPage = marketplaceListing.pageIndex,
				}
			else
				emoteList = getgenv().AFEMListing.Emotes
			end

			CreatePaginatedListing(emoteList, area, not OnUGC and EmotesCurrentPage or 1, ItemsPerPage, not OnUGC and search or "", function(emote, parent, index)
				local buttonClone = ItemSelect.ItemListTemplate:Clone()
				buttonClone.Name = emote["name"] .. "EMOTE"
				buttonClone.Clickable.Position = UDim2.new(0.5, 0, 1.6, 0)
				buttonClone.Visible = true
				buttonClone.Parent = parent
				buttonClone.Clickable.Details.Title.Text = emote["name"]
				buttonClone.Clickable.Thumbnail.Image = "rbxthumb://type=Asset&id=" .. emote["id"] .. "&w=420&h=420"

				local ugcAnimationId
				local ugcRequestForId = false

				local function RequestAnimationId()
					buttonClone.Clickable.Details.Buttons.Loading.Visible = true
					TweenService:Create(buttonClone.Clickable.Details.Buttons.Loading.Progress, TweenInfo.new(5, Enum.EasingStyle.Linear), {
						Size = UDim2.new(0.6, 0, 1, 0)
					}):Play()

					ugcAnimationId = MarketplaceEngine:GetAnimationId(emote["id"])

					if PointSaveAFEM:get("settings_ugcCacheTracks") == "1" then
						local anim = Instance.new("Animation")
						anim.AnimationId = ugcAnimationId

						local animator = game.Players.LocalPlayer.Character.Humanoid:FindFirstChild("Animator")
						local track = animator:LoadAnimation(anim)
						TweenService:Create(buttonClone.Clickable.Details.Buttons.Loading.Progress, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
							Size = UDim2.new(0.8, 0, 1, 0)
						}):Play()
						repeat task.wait() until track.Length ~= 0
					end

					TweenService:Create(buttonClone.Clickable.Details.Buttons.Loading.Progress, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
						Size = UDim2.new(1, 0, 1, 0)
					}):Play()
					task.wait(0.3)
					buttonClone.Clickable.Details.Buttons.Loading.Visible = false
				end

				task.spawn(function()
					if OnUGC then
						if PointSaveAFEM:get("settings_ugcCacheIds") == "0" then
							repeat task.wait() until ugcRequestForId or not buttonClone
							if not buttonClone then return end
						end
						RequestAnimationId()
					end
				end)

				local function play()
					if OnUGC then
						if not ugcAnimationId then
							ugcRequestForId = true
							repeat task.wait() until ugcAnimationId
						end
						FunctionsModule.PlayAnimation(ugcAnimationId)
						return
					end
					FunctionsModule.PlayAnimation(emote["animationid"])
				end

				local function ContextMenu()
					if OnUGC and not ugcAnimationId then
						ugcRequestForId = true
						repeat task.wait() until ugcAnimationId
					end
					FunctionsModule.EmoteDetailPage(emote, buttonClone.Clickable, (OnUGC and ugcAnimationId) and MarketplaceEngine:GetAnimationId(emote["id"]) or nil, play)
				end

				buttonClone.Clickable.MouseButton1Click:Connect(function()
					play()
					script.Parent.Menu.MenuStateChange:Fire(false)
				end)

				if emote["description"] then
					buttonClone.Clickable.Details.Description.Text = emote["description"]
				end

				buttonClone.Clickable.Details.Buttons.Play.Text = "INFO"
				buttonClone.Clickable.Details.Buttons.Play.Size = UDim2.fromOffset(45, 20)
				buttonClone.Clickable.Details.Buttons.Play.MouseButton1Click:Connect(ContextMenu)

				local holdDetect = ClickAndHold.new(buttonClone.Clickable)
				holdDetect.Holded.Event:Connect(ContextMenu)

				if emote["isOffSale"] then
					buttonClone.Clickable.Details.Buttons.OffSale.Visible = true
					buttonClone.Clickable.OffSaleEffect.Enabled = true
				end

				if emote["_special"] == "custom" or OnUGC then
					buttonClone.Clickable.UIStroke.CustomEffect.Enabled = true
				end

				TweenService:Create(buttonClone.Clickable, TweenInfo.new(.3, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, 0, false, ((index - (ItemsPerPage * (EmotesCurrentPage - 1))) / 50)), {
					Position = UDim2.new(0.5, 0, 0.5, 0)
				}):Play()
			end)

			local paginationInfo
			if OnUGC then
				paginationInfo = {
					totalPages = marketplaceMetadata.totalPages,
					currentPage = marketplaceMetadata.currentPage
				}
			else
				paginationInfo = FunctionsModule.GetEmotePagination()
			end

			local activePage = OnUGC and (paginationInfo.currentPage or 1) or EmotesCurrentPage
			local paginationBar = ItemSelect.Emotes.PaginationBar

			ClearEmotesPaginationPages(paginationInfo.totalPages)

			local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Cubic)

			local function UpdatePageButton(button, isActive)
				TweenService:Create(button.UIScale, tweenInfo, { Scale = isActive and 1 or 0.3 }):Play()
				TweenService:Create(button.Label, tweenInfo, { TextTransparency = isActive and 0 or 1 }):Play()
			end

			local function UpdateNavButton(button, enabled)
				TweenService:Create(button.UIScale, tweenInfo, { Scale = enabled and 1 or 0 }):Play()
			end

			for pageNum = 1, paginationInfo.totalPages do
				local button = paginationBar:FindFirstChild("Page" .. pageNum)
				if not button then
					button = paginationBar.SamplePage:Clone()
					button.Name = "Page" .. pageNum
					button.Label.Text = pageNum
					button.Parent = paginationBar
					button.Visible = true
				end
				UpdatePageButton(button, activePage == pageNum)
			end

			UpdateNavButton(ItemSelect.Emotes.PaginationBar.Next, activePage < paginationInfo.totalPages)
			UpdateNavButton(ItemSelect.Emotes.PaginationBar.Previous, activePage > 1)
		end

		function FunctionsModule.EmotePagination(next)
			if OnUGC then
				FunctionsModule.RefreshEmotes(nil, EmoteSearchQuery, true, next, true)
				return
			end

			if next then
				EmotesCurrentPage = EmotesCurrentPage + 1
			else
				EmotesCurrentPage = EmotesCurrentPage - 1
			end
			FunctionsModule.RefreshEmotes(EmotesCurrentPage, EmoteSearchQuery, true, next, true)
		end

		function FunctionsModule.RefreshAnimPacks(page, search)
			if page then AnimPacksCurrentPage = page end
			local area = ItemSelect.AnimationPacks.Listing
			repeat task.wait() until getgenv().AFEMListing.AnimationPacks
			local animPackList = getgenv().AFEMListing.AnimationPacks
			local searchQuery = search or ""

			CreatePaginatedListing(animPackList, area, AnimPacksCurrentPage, ItemsPerPage, searchQuery, function(pack, parent)
				local buttonClone = ItemSelect.ItemListTemplate:Clone()
				buttonClone.Name = (pack["Name"] or "Pack") .. "PACK"
				buttonClone.Visible = true
				buttonClone.Parent = parent
				buttonClone.Clickable.Details.Title.Text = (pack["Name"] or "Unnamed Pack") .. "(" .. pack["BundleId"] .. ")"
				buttonClone.Clickable.Details.Buttons.Play.Visible = false

				if pack["CustomImage"] then
					buttonClone.Clickable.Thumbnail.Image = pack["CustomImage"]
				else
					buttonClone.Clickable.Thumbnail.Image = "rbxthumb://type=BundleThumbnail&id=" .. pack["BundleId"] .. "&w=420&h=420"
				end

				buttonClone.Clickable.MouseButton1Click:Connect(function()
					FunctionsModule.ApplyPack(pack["BundleId"], true, true)
					FunctionsModule.Modal("Pack applied", "Animation pack has been applied.", {"Okay"})
					area.Parent.PackEditorUpdate:Fire()
				end)
			end)

			local paginationInfo = FunctionsModule.GetAnimPackPagination()
			local paginationBar = ItemSelect.AnimationPacks.PaginationBar
			local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Cubic)

			local function UpdatePageButton(button, isActive)
				TweenService:Create(button.UIScale, tweenInfo, { Scale = isActive and 1 or 0.3 }):Play()
				TweenService:Create(button.Label, tweenInfo, { TextTransparency = isActive and 0 or 1 }):Play()
			end

			local function UpdateNavButton(button, enabled)
				TweenService:Create(button.UIScale, tweenInfo, { Scale = enabled and 1 or 0 }):Play()
			end

			for pageNum = 1, paginationInfo.totalPages do
				local button = paginationBar:FindFirstChild("Page" .. pageNum)
				if not button then
					button = paginationBar.SamplePage:Clone()
					button.Name = "Page" .. pageNum
					button.Label.Text = pageNum
					button.Parent = paginationBar
					button.Visible = true
				end
				UpdatePageButton(button, page == pageNum)
			end

			UpdateNavButton(ItemSelect.AnimationPacks.PaginationBar.Next, AnimPacksCurrentPage < paginationInfo.totalPages)
			UpdateNavButton(ItemSelect.AnimationPacks.PaginationBar.Previous, AnimPacksCurrentPage > 1)
		end

		return FunctionsModule
	end
	module_scripts[script] = module_script
end

do -- Module: StarterGui.AFEMMax.SBT
	local script = Instance.new("ModuleScript")
	script.Name = "SBT"
	script.Parent = Converted["_AFEMMax"]
	local function module_script()
		local SpringFunctions = {}
		local PI = math.pi
		local sqrt = math.sqrt

		local function OverDamping(mass, damping, stiffness, y0, v0, force)
			local delta = damping * damping - 4 * stiffness / mass
			local d = -1 / 2
			local w1 = damping + sqrt(delta)
			local w2 = damping - sqrt(delta)
			local r1, r2 = d * w1, d * w2
			local c1, c2 = (r2 * y0 - v0) / (r2 - r1), (r1 * y0 - v0) / (r1 - r2)
			local yp = force / stiffness

			return {
				Offset = function(t) return c1 * math.exp(r1 * t) + c2 * math.exp(r2 * t) + yp end,
				Velocity = function(t) return c1 * r1 * math.exp(r1 * t) + c2 * r2 * math.exp(r2 * t) end,
				Acceleration = function(t) return c1 * r1 * r1 * math.exp(r1 * t) + c2 * r2 * r2 * math.exp(r2 * t) end
			}
		end

		local function CriticalDamping(mass, damping, stiffness, y0, v0, force)
			local r = -damping / 2
			local c1, c2 = y0, v0 - r * y0
			local yp = force / stiffness

			return {
				Offset = function(t) return math.exp(r * t) * (c1 + c2 * t) + yp end,
				Velocity = function(t) return math.exp(r * t) * (c2 * r * t + c1 * r + c2) end,
				Acceleration = function(t) return r * math.exp(r * t) * (c2 * r * t + c1 * r + 2 * c2) end
			}
		end

		local function UnderDamping(mass, damping, stiffness, y0, v0, force)
			local delta = damping * damping - 4 * stiffness / mass
			local r = -damping / 2
			local s = sqrt(-delta)
			local c1, c2 = y0, (v0 - (r * y0)) / s
			local yp = force / stiffness

			return {
				Offset = function(t) return math.exp(r * t) * (c1 * math.cos(s * t) + c2 * math.sin(s * t)) + yp end,
				Velocity = function(t)
					return -math.exp(r * t) * ((c1 * s - c2 * r) * math.sin(s * t) + (-c2 * s - c1 * r) * math.cos(s * t))
				end,
				Acceleration = function(t)
					return -math.exp(r * t) * (
						(c2 * s * s + 2 * c1 * r * s - c2 * r * r) * math.sin(s * t) +
						(c1 * s * s - 2 * c2 * r * s - c1 * r * r) * math.cos(s * t)
					)
				end
			}
		end

		local function SolveSpring(spring)
			local y0, v0, f = spring.InitialOffset, spring.InitialVelocity, spring.ExternalForce
			local m, a, k = spring.Mass, spring.Damping, spring.Constant
			local delta = a * a - 4 * k / m

			if delta > 0 then
				return OverDamping(m, a, k, y0, v0, f)
			elseif delta == 0 then
				return CriticalDamping(m, a, k, y0, v0, f)
			else
				return UnderDamping(m, a, k, y0, v0, f)
			end
		end

		local Spring = {}
		Spring.__index = Spring

		function Spring.new(mass, damping, stiffness, y0, v0, goal)
			assert(mass > 0, "Mass must be > 0")
			assert(stiffness > 0, "Stiffness must be > 0")
			y0 = y0 or 0
			v0 = v0 or 0
			goal = goal or 0

			local self = setmetatable({}, Spring)
			self.Mass = mass
			self.Damping = damping
			self.Constant = stiffness
			self.InitialOffset = y0 - goal
			self.InitialVelocity = v0
			self.ExternalForce = goal * stiffness
			self.StartTick = 0
			self:Reset()
			return self
		end

		function Spring:Reset()
			self.F = SolveSpring(self)
			self.StartTick = tick()
		end

		function Spring:SetGoal(goal)
			self.ExternalForce = goal * self.Constant
			self.InitialOffset = self.Offset - goal
			self.InitialVelocity = self.Velocity
			self:Reset()
		end

		function Spring:SetOffset(offset, zeroVelocity)
			self.InitialOffset = offset - self.Goal
			self.InitialVelocity = zeroVelocity and 0 or self.Velocity
			self:Reset()
		end

		function Spring.__index(self, key)
			if key == "Offset" then
				local t = tick() - self.StartTick
				return self.F.Offset(t)
			elseif key == "Velocity" then
				local t = tick() - self.StartTick
				return self.F.Velocity(t)
			elseif key == "Acceleration" then
				local t = tick() - self.StartTick
				return self.F.Acceleration(t)
			elseif key == "Goal" then
				return self.ExternalForce / self.Constant
			else
				return rawget(self, key)
			end
		end

		-- Spring Tween wrapper
		local SpringTween = {}
		SpringTween.__index = SpringTween

		local TypeHandlers = {
			number = function(obj, property, mass, stiffness, damping)
				local spring = Spring.new(mass, stiffness, damping, obj[property], 0, obj[property])
				return {
					springSet = { spring },
					updateFunc = function() obj[property] = spring.Offset end,
					setGoal = function(goal) spring:SetGoal(goal) end,
					setOffset = function(offset) spring:SetOffset(offset) end,
				}
			end,
			UDim2 = function(obj, property, mass, stiffness, damping)
				local sXOff = Spring.new(mass, stiffness, damping, obj[property].X.Offset, 0, obj[property].X.Offset)
				local sXSc = Spring.new(mass, stiffness, damping, obj[property].X.Scale, 0, obj[property].X.Scale)
				local sYOff = Spring.new(mass, stiffness, damping, obj[property].Y.Offset, 0, obj[property].Y.Offset)
				local sYSc = Spring.new(mass, stiffness, damping, obj[property].Y.Scale, 0, obj[property].Y.Scale)
				return {
					springSet = { XOffset = sXOff, XScale = sXSc, YOffset = sYOff, YScale = sYSc },
					updateFunc = function()
						obj[property] = UDim2.new(sXSc.Offset, sXOff.Offset, sYSc.Offset, sYOff.Offset)
					end,
					setGoal = function(goal)
						sXOff:SetGoal(goal.X.Offset); sXSc:SetGoal(goal.X.Scale)
						sYOff:SetGoal(goal.Y.Offset); sYSc:SetGoal(goal.Y.Scale)
					end,
					setOffset = function(offset)
						sXOff:SetOffset(offset.X.Offset); sXSc:SetOffset(offset.X.Scale)
						sYOff:SetOffset(offset.Y.Offset); sYSc:SetOffset(offset.Y.Scale)
					end,
				}
			end,
			UDim = function(obj, property, mass, stiffness, damping)
				local sOff = Spring.new(mass, stiffness, damping, obj[property].Offset, 0, obj[property].Offset)
				local sSc = Spring.new(mass, stiffness, damping, obj[property].Scale, 0, obj[property].Scale)
				return {
					springSet = { Offset = sOff, Scale = sSc },
					updateFunc = function() obj[property] = UDim.new(sSc.Offset, sOff.Offset) end,
					setGoal = function(goal) sOff:SetGoal(goal.Offset); sSc:SetGoal(goal.Scale) end,
					setOffset = function(offset) sOff:SetOffset(offset.Offset); sSc:SetOffset(offset.Scale) end,
				}
			end,
			Vector2 = function(obj, property, mass, stiffness, damping)
				local sX = Spring.new(mass, stiffness, damping, obj[property].X, 0, obj[property].X)
				local sY = Spring.new(mass, stiffness, damping, obj[property].Y, 0, obj[property].Y)
				return {
					springSet = { X = sX, Y = sY },
					updateFunc = function() obj[property] = Vector2.new(sX.Offset, sY.Offset) end,
					setGoal = function(goal) sX:SetGoal(goal.X); sY:SetGoal(goal.Y) end,
					setOffset = function(offset) sX:SetOffset(offset.X); sY:SetOffset(offset.Y) end,
				}
			end,
			Vector3 = function(obj, property, mass, stiffness, damping)
				local sX = Spring.new(mass, stiffness, damping, obj[property].X, 0, obj[property].X)
				local sY = Spring.new(mass, stiffness, damping, obj[property].Y, 0, obj[property].Y)
				local sZ = Spring.new(mass, stiffness, damping, obj[property].Z, 0, obj[property].Z)
				return {
					springSet = { sX, sY, sZ },
					updateFunc = function() obj[property] = Vector3.new(sX.Offset, sY.Offset, sZ.Offset) end,
					setGoal = function(goal) sX:SetGoal(goal.X); sY:SetGoal(goal.Y); sZ:SetGoal(goal.Z) end,
					setOffset = function(offset) sX:SetOffset(offset.X); sY:SetOffset(offset.Y); sZ:SetOffset(offset.Z) end,
				}
			end,
			Color3 = function(obj, property, mass, stiffness, damping)
				local sR = Spring.new(mass, stiffness, damping, obj[property].R, 0, obj[property].R)
				local sG = Spring.new(mass, stiffness, damping, obj[property].G, 0, obj[property].G)
				local sB = Spring.new(mass, stiffness, damping, obj[property].B, 0, obj[property].B)
				return {
					springSet = { sR, sG, sB },
					updateFunc = function()
						obj[property] = Color3.new(
							math.clamp(sR.Offset, 0, 1),
							math.clamp(sG.Offset, 0, 1),
							math.clamp(sB.Offset, 0, 1)
						)
					end,
					setGoal = function(goal) sR:SetGoal(goal.R); sG:SetGoal(goal.G); sB:SetGoal(goal.B) end,
					setOffset = function(offset) sR:SetOffset(offset.R); sG:SetOffset(offset.G); sB:SetOffset(offset.B) end,
				}
			end,
		}

		function SpringTween.new(obj, property, mass, stiffness, damping)
			assert(obj[property], "Property does not exist")
			local handler = TypeHandlers[typeof(obj[property])]
			assert(handler, "Unsupported type: " .. typeof(obj[property]))

			local self = setmetatable({}, SpringTween)
			local data = handler(obj, property, mass, stiffness, damping)
			self.obj = obj
			self.propertyName = property
			self.springSet = data.springSet
			self.updateFunc = data.updateFunc
			self.setGoal = data.setGoal
			self.setOffset = data.setOffset
			self.updater = nil
			return self
		end

		function SpringTween:Start()
			if self.updater then return end
			for _, spring in pairs(self.springSet) do spring:Reset() end
			self.updater = game:GetService("RunService").RenderStepped:Connect(function()
				self.updateFunc()
			end)
		end

		function SpringTween:Stop()
			if self.updater then
				self.updater:Disconnect()
				self.updater = nil
			end
		end

		function SpringTween:SetGoal(goal) self.setGoal(goal) end
		function SpringTween:SetOffset(offset) self.setOffset(offset) end
		function SpringTween:SetParameters(mass, stiffness, damping)
			for _, spring in pairs(self.springSet) do
				spring.Mass = mass
				spring.Constant = stiffness
				spring.Damping = damping
				spring:Reset()
			end
		end

		function SpringTween.OneShot(obj, config, props)
			local self = {
				target = obj,
				config = config,
				props = props,
				springs = {},
				updater = nil,
				Completed = Instance.new("BindableEvent"),
			}
			setmetatable(self, { __index = SpringTween })

			function self:Go()
				for property, goal in pairs(self.props) do
					local spring = SpringTween.new(
						self.target,
						property,
						self.config.mass or 1,
						self.config.stiffness or 100,
						self.config.damping or 20
					)
					spring:SetGoal(goal)
					spring:Start()
					table.insert(self.springs, spring)
				end

				self.updater = game:GetService("RunService").RenderStepped:Connect(function()
					local allDone = true
					for _, spring in ipairs(self.springs) do
						for _, s in pairs(spring.springSet) do
							if math.abs(s.Velocity) > 0.001 then
								allDone = false
								break
							end
						end
						if not allDone then break end
					end
					if allDone then
						for _, spring in ipairs(self.springs) do spring:Stop() end
						self.springs = {}
						self.updater:Disconnect()
						self.updater = nil
						self.Completed:Fire()
					end
				end)
				return self
			end
			return self
		end

		return SpringTween
	end
	module_scripts[script] = module_script
end

do -- Module: StarterGui.AFEMMax.DraggableObject
	local script = Instance.new("ModuleScript")
	script.Name = "DraggableObject"
	script.Parent = Converted["_AFEMMax"]
	local function module_script()
		local Draggable = {}
		Draggable.__index = Draggable

		local UserInputService = game:GetService("UserInputService")
		local TweenService = game:GetService("TweenService")

		function Draggable.new(object, toMove, smooth, callbackOnly)
			local self = setmetatable({}, Draggable)
			self.Object = object
			self.ToMove = toMove or object
			self.Smooth = smooth ~= false
			self.CallbackOnly = callbackOnly or false
			self.DragStarted = nil
			self.DragEnded = nil
			self.Dragged = nil
			self.Dragging = false
			self.LastPosition = nil
			self.Velocity = Vector2.new(0, 0)
			self.Connections = {}
			return self
		end

		function Draggable:Enable()
			local self = self
			local object = self.Object
			local toMove = self.ToMove
			local isDragging = false
			local dragStartPos = nil
			local startPosition = nil
			local inputObject = nil

			local function IsOffScreen(position, size, parent)
				local parentSize = parent and parent.AbsoluteSize or Vector2.new(0, 0)
				local x = position.X.Scale * parentSize.X + position.X.Offset
				local y = position.Y.Scale * parentSize.Y + position.Y.Offset
				local w = size.X.Scale * parentSize.X + size.X.Offset
				local h = size.Y.Scale * parentSize.Y + size.Y.Offset
				return x + w <= 0 or x >= parentSize.X or y + h <= 0 or y >= parentSize.Y
			end

			local function GetScreenGuiParent(obj)
				local parent = obj.Parent
				while parent do
					if parent:IsA("ScreenGui") then return parent end
					parent = parent.Parent
				end
				return nil
			end

			local function ClampPosition(position)
				local screenGui = GetScreenGuiParent(object)
				if screenGui and IsOffScreen(position, object.Size, screenGui) then
					return position
				end
				return position
			end

			local function UpdatePosition(mousePos)
				local delta = mousePos - dragStartPos
				local newPos = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
				                         startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
				newPos = ClampPosition(newPos)
				if not self.CallbackOnly then
					if self.Smooth then
						TweenService:Create(toMove, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
							Position = newPos
						}):Play()
					else
						toMove.Position = newPos
					end
				end
				return newPos
			end

			local function OnInputBegan(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					isDragging = false
					local conn
					conn = input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							if self.Dragging then
								self.Dragging = false
								if self.DragEnded then self.DragEnded(self.Velocity) end
							end
							isDragging = false
							conn:Disconnect()
						end
					end)
				end
			end

			local function OnInputChanged(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					inputObject = input
				end
			end

			local function OnInputChangedGlobal(input)
				if not object.Parent then self:Disable() return end
				if isDragging then
					isDragging = false
					if self.DragStarted then self.DragStarted() end
					self.Dragging = true
					dragStartPos = input.Position
					startPosition = toMove.Position
					self.LastPosition = input.Position
				end

				if input == inputObject and self.Dragging then
					local newPos = UpdatePosition(input.Position)
					self.Velocity = input.Position - self.LastPosition
					self.LastPosition = input.Position
					if self.Dragged then self.Dragged(newPos) end
				end
			end

			self.Connections.InputBegan = object.InputBegan:Connect(OnInputBegan)
			self.Connections.InputChanged = object.InputChanged:Connect(OnInputChanged)
			self.Connections.InputChangedGlobal = UserInputService.InputChanged:Connect(OnInputChangedGlobal)
		end

		function Draggable:Disable()
			for _, conn in pairs(self.Connections) do
				if conn then conn:Disconnect() end
			end
			self.Connections = {}
			if self.Dragging then
				self.Dragging = false
				if self.DragEnded then self.DragEnded(self.Velocity) end
			end
		end

		return Draggable
	end
	module_scripts[script] = module_script
end

do -- Module: StarterGui.AFEMMax.PointSave
	local script = Instance.new("ModuleScript")
	script.Name = "PointSave"
	script.Parent = Converted["_AFEMMax"]
	local function module_script()
		local BaseFolder = "PointSaveData"
		local Folders = _G._FOLDERS or {}
		local Files = _G._FILES or {}

		_G._FOLDERS = Folders
		_G._FILES = Files

		local function EnsureFolder(folder)
			if not Folders[folder] then
				Folders[folder] = {}
			end
		end

		local PointSave = {}
		PointSave.__index = PointSave

		function PointSave.new(namespace)
			EnsureFolder(BaseFolder)
			local self = setmetatable({}, PointSave)
			self.namespace = namespace
			self.folderPath = BaseFolder .. "/" .. namespace
			EnsureFolder(self.folderPath)
			return self
		end

		function PointSave:set(key, value)
			local path = self.folderPath .. "/" .. key .. ".txt"
			Files[path] = tostring(value)
		end

		function PointSave:get(key)
			local path = self.folderPath .. "/" .. key .. ".txt"
			return Files[path]
		end

		function PointSave:remove(key)
			local path = self.folderPath .. "/" .. key .. ".txt"
			Files[path] = nil
		end

		function PointSave:clear()
			local folderPath = self.folderPath
			for path, _ in pairs(Files) do
				if path:sub(1, #folderPath + 1) == folderPath .. "/" then
					Files[path] = nil
				end
			end
		end

		function PointSave.deleteNamespace(namespace)
			local folderPath = BaseFolder .. "/" .. namespace
			for path, _ in pairs(Files) do
				if path:sub(1, #folderPath + 1) == folderPath .. "/" then
					Files[path] = nil
				end
			end
			Folders[folderPath] = nil
		end

		function PointSave.listNamespaces()
			EnsureFolder(BaseFolder)
			local namespaces = {}
			for folder, _ in pairs(Folders) do
				if folder:sub(1, #BaseFolder + 1) == BaseFolder .. "/" then
					local ns = folder:sub(#BaseFolder + 2)
					table.insert(namespaces, ns)
				end
			end
			return namespaces
		end

		return PointSave
	end
	module_scripts[script] = module_script
end

do -- Module: StarterGui.AFEMMax.ClickAndHold
	local script = Instance.new("ModuleScript")
	script.Name = "ClickAndHold"
	script.Parent = Converted["_AFEMMax"]
	local function module_script()
		local ClickAndHold = {}
		ClickAndHold.__index = ClickAndHold

		local UserInputService = game:GetService("UserInputService")

		function ClickAndHold.new(button, holdTime)
			local self = setmetatable({}, ClickAndHold)
			self.textButton = button
			self.holdTime = holdTime or 0.5
			self.holdTask = nil
			self.initialPosition = nil
			self.Holded = Instance.new("BindableEvent")

			local function Distance(pos1, pos2)
				return math.sqrt((pos2.X - pos1.X) ^ 2 + (pos2.Y - pos1.Y) ^ 2)
			end

			self.textButton.MouseButton1Down:Connect(function(x, y)
				self.initialPosition = Vector2.new(x, y)
				self.holdTask = task.spawn(function()
					task.wait(self.holdTime)
					if self.holdTask then
						self.Holded:Fire()
					end
				end)
			end)

			UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					if self.holdTask and self.initialPosition then
						local pos = input.Position
						if Distance(self.initialPosition, pos) > 30 then
							coroutine.close(self.holdTask)
							self.holdTask = nil
						end
					end
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					if self.holdTask then
						coroutine.close(self.holdTask)
						self.holdTask = nil
					end
					self.initialPosition = nil
				end
			end)

			return self
		end

		return ClickAndHold
	end
	module_scripts[script] = module_script
end

do -- Module: StarterGui.AFEMMax.MarketplaceEmotes
	local script = Instance.new("ModuleScript")
	script.Name = "MarketplaceEmotes"
	script.Parent = Converted["_AFEMMax"]
	local function module_script()
		local HttpService = game:GetService("HttpService")
		local Marketplace = {}
		Marketplace.__index = Marketplace

		repeat task.wait() until getgenv().AFEMLibraries
		local PointSave = getgenv().AFEMLibraries.PSV.new("AFEMMaxConf")

		local Constants = {
			FIRST_PAGE = "firstPage",
			BASE_ENDPOINT = "https://catalog.roblox.com/v1/search/items/details",
			SEARCH_ENDPOINT = "https://catalog.roblox.com/v1/search/items/details?Category=12&SortType=Relevance&IncludeNotForSale=true&Limit=30&Keyword=%s",
			DEFAULT_ENDPOINT = "https://catalog.roblox.com/v1/search/items/details?Category=12&SortType=Updated&IncludeNotForSale=true&Limit=30",
			DETAILS_ENDPOINT = "https://catalog.roblox.com/v1/catalog/items/%d/details?itemType=Asset",
			GET_ASSET_ENDPOINT = "https://assetdelivery.roblox.com/v1/assetId/%d",
			SUBMIT_TO_BASE = true
		}

		local function FetchJSON(url)
			local success, result = pcall(function() return game:HttpGet(url) end)
			if not success then return { data = {}, nextPageCursor = "" } end
			return HttpService:JSONDecode(result)
		end

		local function ExtractAnimationId(text)
			return string.match(text, "rbxassetid://%d+")
		end

		function Marketplace.new()
			local self = setmetatable({}, Marketplace)
			self:ResetState("")
			return self
		end

		function Marketplace:ResetState(searchQuery)
			self.searchQuery = searchQuery or ""
			self.nextCursor = ""
			self.cursorHistory = { Constants.FIRST_PAGE }
			self.cursorIndex = 1
			self.cache = {}
		end

		function Marketplace:_GetOrAddCursor(cursor)
			cursor = cursor or Constants.FIRST_PAGE
			local index = table.find(self.cursorHistory, cursor)
			if not index then
				table.insert(self.cursorHistory, cursor)
				index = #self.cursorHistory
			end
			return index, cursor
		end

		function Marketplace:_GetCache(key) return self.cache[key] end
		function Marketplace:_SetCache(key, items, nextCursor)
			self.cache[key] = { items = items, nextCursor = nextCursor }
		end

		function Marketplace:FetchEmotes(options)
			options = options or {}
			local search = options.search or self.searchQuery
			local cursor = options.cursor

			if search ~= self.searchQuery then self:ResetState(search) end

			local index, cursorKey = self:_GetOrAddCursor(cursor)
			local cached = self:_GetCache(cursorKey)
			if cached then
				self.cursorIndex = index
				return cached.items, cached.nextCursor
			end

			local url = (search ~= "") and string.format(Constants.SEARCH_ENDPOINT, search) or Constants.DEFAULT_ENDPOINT
			if cursor and cursor ~= "" then url = url .. "&cursor=" .. cursor end

			local data = FetchJSON(url)
			self.nextCursor = data.nextPageCursor or ""
			self.hasMore = self.nextCursor ~= ""
			self.cursorIndex = index

			if index == #self.cursorHistory and self.nextCursor ~= "" then
				table.insert(self.cursorHistory, self.nextCursor)
			end

			self:_SetCache(cursorKey, data.data or {}, self.nextCursor)
			return data.data or {}, self.nextCursor
		end

		function Marketplace:PreviousFetch()
			if self.cursorIndex > 1 then
				self.cursorIndex = self.cursorIndex - 1
				local cursor = self.cursorHistory[self.cursorIndex]
				return self:FetchEmotes({ cursor = cursor })
			end
			return nil, "No previous page"
		end

		function Marketplace:NextFetch()
			if self.cursorIndex < #self.cursorHistory then
				self.cursorIndex = self.cursorIndex + 1
				local cursor = self.cursorHistory[self.cursorIndex]
				return self:FetchEmotes({ cursor = cursor })
			end
			return self:FetchEmotes({ cursor = self.nextCursor })
		end

		function Marketplace:GetEmoteDetails(assetId)
			local url = string.format(Constants.DETAILS_ENDPOINT, assetId)
			return FetchJSON(url)
		end

		function Marketplace:GetAnimationId(assetId, noCache)
			local cacheKey = "UGCEmote_" .. assetId
			local cached = PointSave:get(cacheKey)
			if cached and not noCache then
				task.spawn(function()
					if Constants.SUBMIT_TO_BASE then
						local success, err = pcall(function()
							local details = self:GetEmoteDetails(assetId)
							request({
								Url = "https://yarhm.mhi.im/api/science/submitEmote",
								Method = "POST",
								Headers = { ["Content-Type"] = "application/json" },
								Body = HttpService:JSONEncode({
									assetId = assetId,
									emoteName = details["name"],
									emoteDescription = details["description"],
									emoteCreator = details["creatorName"],
									emotePrice = details["price"],
									emoteAnimationId = cached
								})
							})
						end)
						if not success then warn(err) end
					end
				end)
				return cached
			end

			local animationId
			if noCache then
				local objects = game:GetObjects("rbxassetid://" .. assetId)
				local anim = objects and objects[1]
				if anim and anim:IsA("Animation") then
					animationId = anim.AnimationId
				end
			else
				local data = FetchJSON(string.format(Constants.GET_ASSET_ENDPOINT, assetId))
				if data.location then
					local raw = game:HttpGet(data.location)
					animationId = ExtractAnimationId(raw)
				end
			end

			if animationId then
				PointSave:set(cacheKey, animationId)
				task.spawn(function()
					if Constants.SUBMIT_TO_BASE then
						local success, err = pcall(function()
							local details = self:GetEmoteDetails(assetId)
							request({
								Url = "https://yarhm.mhi.im/api/science/submitEmote",
								Method = "POST",
								Headers = { ["Content-Type"] = "application/json" },
								Body = HttpService:JSONEncode({
									assetId = assetId,
									emoteName = details["name"],
									emoteDescription = details["description"],
									emoteCreator = details["creatorName"],
									emotePrice = details["price"],
									emoteAnimationId = animationId
								})
							})
						end)
						if not success then warn(err) end
					end
				end)
				return animationId
			end

			return nil, "No animation ID found"
		end

		return Marketplace
	end
	module_scripts[script] = module_script
end

do -- Module: StarterGui.AFEMMax.AIEngine
	local script = Instance.new("ModuleScript")
	script.Name = "AIEngine"
	script.Parent = Converted["_AFEMMax"]
	local function module_script()
		local AIEngine = {}
		local HttpService = game:GetService("HttpService")

		AIEngine.endpoint = "https://yarhm.mhi.im/api/science/ai"
		AIEngine.task = "associated"
		AIEngine.active = false

		local function PostRequest(body)
			local success, response = pcall(function()
				return request({
					Url = "https://yarhm.mhi.im/api/science/ai",
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
					Body = HttpService:JSONEncode(body)
				})
			end)
			if not success then return { reply = "broken" } end
			return HttpService:JSONDecode(response["Body"])
		end

		function AIEngine.requestSuggestions(base)
			if AIEngine.active then return 1 end
			AIEngine.active = true
			local suggestions = PostRequest({
				task = AIEngine.task,
				message = base
			})
			AIEngine.active = false
			if suggestions.reply == "broken" or suggestions.reply == "|" then
				return {}
			end
			return string.split(suggestions.reply, "|")
		end

		return AIEngine
	end
	module_scripts[script] = module_script
end

do -- Module: StarterGui.AFEMMax.ParticleEffects
	local script = Instance.new("ModuleScript")
	script.Name = "ParticleEffects"
	script.Parent = Converted["_AFEMMax"]
	local function module_script()
		local ParticleEffect = {}
		ParticleEffect.__index = ParticleEffect

		local RunService = game:GetService("RunService")
		local Defaults = {
			Text = "✨",
			Lifetime = 2,
			Velocity = Vector2.new(0, -100),
			VelocitySpread = 50,
			Gravity = Vector2.new(0, 200),
			Size = UDim2.fromOffset(24, 24),
			ScaleInTime = 0.2,
			FadeOut = true,
			Amount = 1,
			Origin = UDim2.fromScale(0.5, 0.5),
			Rotation = true,
			AngularVelocity = 180,
			Parent = nil
		}

		function ParticleEffect.new(parent, config)
			local particles = {}
			local amount = config.Amount or Defaults.Amount

			for i = 1, amount do
				local self = setmetatable({}, ParticleEffect)
				self.Parent = parent
				self.Text = config.Text or Defaults.Text
				self.Lifetime = config.Lifetime or Defaults.Lifetime
				self.Gravity = config.Gravity or Defaults.Gravity
				self.FadeOut = (config.FadeOut ~= nil) and config.FadeOut or Defaults.FadeOut
				self.DoRotation = (config.Rotation ~= nil) and config.Rotation or Defaults.Rotation
				self.TargetSize = config.Size or Defaults.Size
				self.ScaleInTime = config.ScaleInTime or Defaults.ScaleInTime

				local spread = config.VelocitySpread or Defaults.VelocitySpread
				local velocity = config.Velocity or Defaults.Velocity
				local baseVel = velocity * 0.3
				local randSpread = Vector2.new(math.random(-spread, spread), math.random(-spread, spread))
				self.Velocity = baseVel + randSpread + (velocity * (1 - 0.3))

				if self.DoRotation then
					local angular = config.AngularVelocity or Defaults.AngularVelocity
					self.AngularVelocity = (math.random() * 2 - 1) * angular
					self.Rotation = math.random(0, 359)
				else
					self.AngularVelocity = 0
					self.Rotation = 0
				end

				local label = Instance.new("TextLabel")
				label.BackgroundTransparency = 1
				label.Size = UDim2.new()
				label.AnchorPoint = Vector2.new(0.5, 0.5)
				label.Text = self.Text
				label.TextScaled = true
				label.Font = Enum.Font.SourceSansBold
				label.TextColor3 = Color3.new(1, 1, 1)

				if amount > 1 then
					label.TextTransparency = math.random() * 0.5
					local scale = 0.5 + math.random() * 0.5
					label.Size = UDim2.new(0, (label.Size.X.Offset * scale), 0, (label.Size.Y.Offset * scale))
				end

				label.Position = config.Origin or Defaults.Origin
				label.Rotation = self.Rotation
				label.Parent = parent

				self.Label = label
				self.StartTime = os.clock()
				self.Dead = false
				self.Connection = RunService.RenderStepped:Connect(function(dt) self:Update(dt) end)
				table.insert(particles, self)
			end
			return particles
		end

		function ParticleEffect:Update(dt)
			if self.Dead then return end
			local elapsed = os.clock() - self.StartTime
			if elapsed > self.Lifetime then
				self:Destroy()
				return
			end

			self.Velocity = self.Velocity + self.Gravity * dt
			local pos = self.Label.Position
			pos = UDim2.new(pos.X.Scale, pos.X.Offset + self.Velocity.X * dt,
			                pos.Y.Scale, pos.Y.Offset + self.Velocity.Y * dt)
			self.Label.Position = pos

			if self.AngularVelocity ~= 0 then
				self.Rotation = self.Rotation + self.AngularVelocity * dt
				self.Label.Rotation = self.Rotation
			end

			if self.FadeOut then
				local alpha = 1 - (elapsed / self.Lifetime)
				self.Label.TextTransparency = 1 - alpha
			end

			if self.ScaleInTime > 0 then
				local t = os.clock() - self.StartTime
				if t < self.ScaleInTime then
					local progress = t / self.ScaleInTime
					local w, h = self.TargetSize.X.Offset, self.TargetSize.Y.Offset
					self.Label.Size = UDim2.fromOffset(w * progress, h * progress)
				else
					self.Label.Size = self.TargetSize
				end
			end
		end

		function ParticleEffect:Destroy()
			if self.Dead then return end
			self.Dead = true
			if self.Connection then self.Connection:Disconnect() end
			if self.Label then self.Label:Destroy() end
		end

		return ParticleEffect
	end
	module_scripts[script] = module_script
end

-- Routine Local Scripts:
local function InitRoutine()
	local script = Instance.new("LocalScript")
	script.Name = "Init"
	script.Parent = Converted["_AFEMMax"]
	local req = require
	local require = function(obj)
		local fake = module_scripts[obj]
		if fake then return fake() end
		return req(obj)
	end

	local TweenService = game:GetService("TweenService")
	local CoreGui = game:GetService("CoreGui")

	getgenv().AFEMLibraries = {
		GUI = script.Parent,
		SBT = require(script.Parent.SBT),
		PSV = require(script.Parent.PointSave),
		DGB = require(script.Parent.DraggableObject),
		CAH = require(script.Parent.ClickAndHold),
		AIG = require(script.Parent.AIEngine),
		PRF = require(script.Parent.ParticleEffects)
	}

	task.spawn(function()
		getgenv().AFEMLibraries.MKE = require(script.Parent.MarketplaceEmotes)
	end)

	task.spawn(function()
		getgenv().AFEMLibraries.FNC = require(script.Parent.FUNCTIONS)
	end)

	local PointSaveAFEM = getgenv().AFEMLibraries.PSV.new("AFEMMaxConf")

	local function RandomString()
		local length = math.random(10, 20)
		local chars = {}
		for i = 1, length do
			chars[i] = string.char(math.random(32, 126))
		end
		return table.concat(chars)
	end

	local success, err = pcall(function()
		if get_hidden_gui or gethui then
			local hiddenUI = get_hidden_gui or gethui
			script.Parent.Name = RandomString()
			script.Parent.Parent = hiddenUI()
		elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
			script.Parent.Name = RandomString()
			syn.protect_gui(script.Parent)
			script.Parent.Parent = CoreGui
		elseif CoreGui:FindFirstChild('RobloxGui') then
			script.Parent.Parent = CoreGui.RobloxGui
		end
	end)

	script.Parent.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
	script.Parent.ScreenInsets = Enum.ScreenInsets.None
	script.Parent.ResetOnSpawn = false

	script.Parent.Modal.Container.UIStroke.Transparency = 1
	script.Parent.Modal.Container.UIStroke:SetAttribute("ignore", true)
	script.Parent.Menu.ShamelessCredit.Text = "scripting, design, animation & engine by\nyarhm team!"

	script.Parent.Menu.UIScale.Scale = 0

	if PointSaveAFEM:get("settings_startClosed") == "1" then
		task.spawn(function()
			script.Parent.Menu.UIScale.Scale = 1
			task.wait(0.2)
			script.Parent.Menu.MenuSpringTakeover:Fire()
			task.wait(0.2)
			script.Parent.Menu.MenuStateChange:Fire(false)
		end)
	else
		TweenService:Create(script.Parent.Menu.UIScale, TweenInfo.new(2, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
			Scale = 1
		}):Play()
		task.spawn(function()
			task.wait(2.1)
			script.Parent.Menu.MenuSpringTakeover:Fire()
		end)
	end

	local Functions = getgenv().AFEMLibraries.FNC
	Functions.PullList()
	Functions.RefreshEmotes()
	Functions.RefreshAnimPacks()
	Functions.RecreateFloatingButtonsFromStore()
	Functions.RecreateQuickSelectorsFromStore()

	local function UpdateGridSizing()
		local screenSize = script.Parent.AbsoluteSize
		local cellSize = screenSize.X > 1000 and UDim2.new(0.3, -3, 0, 100) or UDim2.new(0.4, -3, 0, 100)
		script.Parent.Menu.Area.ItemSelect.Emotes.Listing.UIGridLayout.CellSize = cellSize
		script.Parent.Menu.Area.ItemSelect.AnimationPacks.Listing.UIGridLayout.CellSize = cellSize
	end

	UpdateGridSizing()
	script.Parent.Changed:Connect(UpdateGridSizing)

	local equippedPack = nil
	local success, err = pcall(function()
		equippedPack = PointSaveAFEM:get("AnimationPackGLOBAL")
		if equippedPack then
			task.delay(1.5, function()
				repeat task.wait() until game.Players.LocalPlayer.Character
				Functions.LoadPack()
			end)
		end
	end)
	if not success then
		warn("[AFEM] - Reading persistent pack file failed. Not supported?")
		warn(err)
	end

	task.spawn(function()
		task.wait(5)
		if not PointSaveAFEM:get("tooltips_tryUGCemotes") then
			Functions.ShowTooltip(script.Parent.Menu.Area.ItemSelect.Emotes.ActionBar.SwitchTabs.UGC, "Click <b>UGC</b> to try catalog emotes!")
			PointSaveAFEM:set("tooltips_tryUGCemotes", "1")
		end
	end)

	for _, child in ipairs(script.Parent:GetDescendants()) do
		if child:IsA("UIStroke") and not child:GetAttribute("ignore") then
			child.Transparency = 0.5
		end
	end
end

local function HoverEffectRoutine()
	local script = Instance.new("LocalScript")
	script.Name = "HoverEffect"
	script.Parent = Converted["_Naming"]
	local req = require
	local require = function(obj)
		local fake = module_scripts[obj]
		if fake then return fake() end
		return req(obj)
	end

	repeat task.wait() until getgenv().AFEMLibraries
	local SpringTween = getgenv().AFEMLibraries.SBT

	local tween = SpringTween.new(script.Parent.PriorityLine.UIFlexItem, "GrowRatio", 1, 18, 100)
	tween:Start()

	script.Parent.MouseEnter:Connect(function() tween:SetGoal(0.5) end)
	script.Parent.MouseLeave:Connect(function() tween:SetGoal(2) end)
end

local function SwitchSCRRoutine()
	local script = Instance.new("LocalScript")
	script.Name = "SwitchSCR"
	script.Parent = Converted["_CategorySelect"]
	local req = require
	local require = function(obj)
		local fake = module_scripts[obj]
		if fake then return fake() end
		return req(obj)
	end

	repeat task.wait() until getgenv().AFEMLibraries
	local SpringTween = getgenv().AFEMLibraries.SBT

	local pageLayout = script.Parent.Parent.ItemSelect.UIPageLayout
	local springs = {}
	local activelyPressedButton = nil

	for _, button in ipairs(script.Parent:GetChildren()) do
		if not button:IsA("TextButton") then continue end

		local sizeSpring = SpringTween.new(button, "Size", 1, 19, 145)
		local bgSpring = SpringTween.new(button, "BackgroundColor3", 1, 19, 145)
		local iconColorSpring = SpringTween.new(button.Icon, "ImageColor3", 1, 19, 145)
		local scaleSpring = SpringTween.new(button.UIScale, "Scale", 1, 19, 145)
		local cornerSpring = SpringTween.new(button.UICorner, "CornerRadius", 1, 19, 145)

		local label = button:FindFirstChildWhichIsA("TextLabel")
		local labelColorSpring
		if label then
			labelColorSpring = SpringTween.new(label, "TextColor3", 1, 19, 145)
		end

		sizeSpring:Start(); bgSpring:Start(); iconColorSpring:Start()
		scaleSpring:Start(); cornerSpring:Start()
		if labelColorSpring then labelColorSpring:Start() end

		springs[button] = {
			size = sizeSpring,
			bg = bgSpring,
			icon = iconColorSpring,
			scale = scaleSpring,
			corner = cornerSpring,
			label = labelColorSpring,
		}

		button.MouseButton1Click:Connect(function()
			for obj, spr in pairs(springs) do
				if not obj:IsA("TextButton") then continue end
				spr.size:SetGoal(UDim2.fromOffset(50, 50))
				spr.bg:SetGoal(Color3.fromRGB(36, 36, 36))
				spr.icon:SetGoal(Color3.fromRGB(255, 255, 255))
				spr.scale:SetGoal(1)
				spr.corner:SetGoal(UDim.new(0, 32))
				if spr.label then spr.label:SetGoal(Color3.fromRGB(255, 255, 255)) end
				obj:SetAttribute("active", false)
			end

			sizeSpring:SetGoal(UDim2.fromOffset(50, 75))
			bgSpring:SetGoal(Color3.fromRGB(255, 255, 255))
			iconColorSpring:SetGoal(Color3.fromRGB(0, 0, 0))
			scaleSpring:SetGoal(1.2)
			cornerSpring:SetGoal(UDim.new(0, 16))
			button:SetAttribute("active", true)
			if labelColorSpring then labelColorSpring:SetGoal(Color3.fromRGB(0, 0, 0)) end

			pageLayout:JumpTo(pageLayout.Parent:FindFirstChild(button.Name))
		end)

		button.MouseButton1Down:Connect(function()
			sizeSpring:SetGoal(UDim2.fromOffset(50, 90))
			cornerSpring:SetGoal(UDim.new(0, 8))
		end)
	end

	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and activelyPressedButton then
			if activelyPressedButton:GetAttribute("active") then
				springs[activelyPressedButton].size:SetGoal(UDim2.fromOffset(50, 75))
				springs[activelyPressedButton].corner:SetGoal(UDim.new(0, 16))
			else
				springs[activelyPressedButton].size:SetGoal(UDim2.fromOffset(50, 50))
				springs[activelyPressedButton].corner:SetGoal(UDim.new(0, 32))
			end
			activelyPressedButton = nil
		end
	end)
end

local function SpinRoutine()
	local script = Instance.new("LocalScript")
	script.Name = "Spin"
	script.Parent = Converted["_Spinner1"]
	local TweenService = game:GetService("TweenService")

	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1)
	TweenService:Create(script.Parent, tweenInfo, { Rotation = 180 }):Play()
end

local function FavoritesSetupRoutine()
	local script = Instance.new("LocalScript")
	script.Name = "FavoritesSetup"
	script.Parent = Converted["_FavoritesSection"]
	local TweenService = game:GetService("TweenService")

	local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
	local opened = false

	local function Open()
		TweenService:Create(script.Parent, tweenInfo, { Size = UDim2.new(1, -4, 0, 125) }):Play()
		TweenService:Create(script.Parent.UIStroke, tweenInfo, { Thickness = 1.6 }):Play()
	end

	local function Close()
		TweenService:Create(script.Parent, tweenInfo, { Size = UDim2.new(1, -4, 0, 0) }):Play()
		TweenService:Create(script.Parent.UIStroke, tweenInfo, { Thickness = 0 }):Play()
	end

	script.Parent.Parent.ActionBar.Favorites.MouseButton1Click:Connect(function()
		opened = not opened
		if opened then Open() else Close() end
	end)
end

local function PackEditorScrRoutine()
	local script = Instance.new("LocalScript")
	script.Name = "PackEditorScr"
	script.Parent = Converted["_AnimationPacks1"]
	local req = require
	local require = function(obj)
		local fake = module_scripts[obj]
		if fake then return fake() end
		return req(obj)
	end

	repeat task.wait() until getgenv().AFEMLibraries
	local Functions = getgenv().AFEMLibraries.FNC
	local PointSaveAFEM = getgenv().AFEMLibraries.PSV.new("AFEMMaxConf")

	local AnimationCategories = { "Idle", "Walk", "Run", "Jump", "Fall", "Climb", "Swim" }

	local function UpdatePackEditor()
		for _, child in ipairs(script.Parent.PackEditor.Listing:GetChildren()) do
			if child:IsA("Frame") then child:Destroy() end
		end

		for _, category in ipairs(AnimationCategories) do
			local newFrame = script.Parent.Parent.ItemListTemplate:Clone()
			newFrame.Name = category
			newFrame.Clickable.Details.Title.Text = category
			newFrame.Clickable.Details.Buttons.Play.Visible = false
			newFrame.Size = UDim2.new(0, 250, 1, 0)

			local saved = PointSaveAFEM:get("AnimationPack_" .. category:lower())
			if saved then
				newFrame.Clickable.Details.Description.Text = "This category is using a custom animation asset."
			elseif PointSaveAFEM:get("AnimationPackGLOBAL") then
				local pack = Functions.GetPackFromID(tonumber(PointSaveAFEM:get("AnimationPackGLOBAL")))
				if pack then
					newFrame.Clickable.Details.Description.Text = "This category is using " .. pack["Name"] .. "'s " .. category .. "."
					newFrame.Clickable.Thumbnail.Image = "rbxthumb://type=BundleThumbnail&id=" .. pack["BundleId"] .. "&w=420&h=420"
				end
			else
				newFrame.Clickable.Details.Description.Text = "This category is inheriting your Roblox's avatar pack."
			end

			newFrame.Parent = script.Parent.PackEditor.Listing
			newFrame.Visible = true

			newFrame.Clickable.MouseButton1Click:Connect(function()
				local current = PointSaveAFEM:get("AnimationPack_" .. category:lower()) or PointSaveAFEM:get("AnimationPackGLOBAL") or ""

				Functions.Modal(category .. " animation", "Enter the animation asset or pack ID for this category.", {"Set", "Help", "Cancel"}, {
					prefill = current,
					placeholder = "Animation asset or Pack ID"
				}, true)

				local result = Functions.WaitForModal()
				if result.selected == "Set" then
					PointSaveAFEM:set("AnimationPack_" .. category:lower(), result.input)
					task.wait()
					Functions.LoadPack()
					Functions.Notification("Category set", "The animation for this category has been updated.")
					script.Parent.PackEditorUpdate:Fire()
				elseif result.selected == "Help" then
					task.wait(0.1)
					Functions.Modal("Help", "Get the animation asset of an emote with <b>the detail page of an emote entry</b>. The ID of an Animation pack is <b>at the name of the entry</b>.", {"Continue"})
					Functions.WaitForModal()
				end
			end)
		end
	end

	UpdatePackEditor()
	script.Parent.PackEditorUpdate.Event:Connect(UpdatePackEditor)
end

local function SettingsSetupRoutine()
	local script = Instance.new("LocalScript")
	script.Name = "SettingsSetup"
	script.Parent = Converted["_Settings1"]
	local req = require
	local require = function(obj)
		local fake = module_scripts[obj]
		if fake then return fake() end
		return req(obj)
	end

	local TweenService = game:GetService("TweenService")
	local settingsListing = script.Parent.Listing
	local itemSamples = script.Parent.Samples
	local root = script.Parent.Parent.Parent.Parent.Parent

	repeat task.wait() until getgenv().AFEMLibraries.PSV
	local PointSaveAFEM = getgenv().AFEMLibraries.PSV.new("AFEMMaxConf")
	local Functions = getgenv().AFEMLibraries.FNC

	local timeoutFolder = Instance.new("Folder")
	local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

	local typeHandlers = {
		[itemSamples.TextLabel] = function(opts)
			local clone = itemSamples.TextLabel:Clone()
			if opts.type == "subText" then
				clone.Font = Enum.Font.Montserrat
				clone.Size = UDim2.new(1, 0, 0, 10)
			end
			clone.Text = opts.label
			return clone
		end,
		[itemSamples.Toggle] = function(opts)
			local clone = itemSamples.Toggle:Clone()
			clone.Label.Text = opts.label

			local enabled = opts.enabled
			if opts.associatedKey then
				if not PointSaveAFEM:get(opts.associatedKey) then
					PointSaveAFEM:set(opts.associatedKey, enabled and "1" or "0")
				else
					enabled = PointSaveAFEM:get(opts.associatedKey) == "1"
				end
			end

			if enabled then
				clone.ToggleTrack.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
				clone.ToggleTrack.Ball.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
				clone.ToggleTrack.Ball.AnchorPoint = Vector2.new(1, 0)
				clone.ToggleTrack.Ball.Position = UDim2.fromScale(1, 0)
			end

			clone.MouseButton1Click:Connect(function()
				enabled = not enabled
				if opts.associatedKey then PointSaveAFEM:set(opts.associatedKey, enabled and "1" or "0") end

				if enabled then
					TweenService:Create(clone.ToggleTrack, tweenInfo, { BackgroundColor3 = Color3.fromRGB(220, 220, 220) }):Play()
					TweenService:Create(clone.ToggleTrack.Ball, tweenInfo, {
						BackgroundColor3 = Color3.fromRGB(48, 48, 48),
						Position = UDim2.new(1, 0),
						AnchorPoint = Vector2.new(1, 0)
					}):Play()
				else
					TweenService:Create(clone.ToggleTrack, tweenInfo, { BackgroundColor3 = Color3.fromRGB(48, 48, 48) }):Play()
					TweenService:Create(clone.ToggleTrack.Ball, tweenInfo, {
						BackgroundColor3 = Color3.fromRGB(220, 220, 220),
						Position = UDim2.new(0, 0),
						AnchorPoint = Vector2.new(0, 0)
					}):Play()
				end

				if opts.callback then opts.callback(enabled) end
			end)
			return clone
		end,
		[itemSamples.Select] = function(opts)
			local clone = itemSamples.Select:Clone()

			for _, choice in ipairs(opts.selectables) do
				local buttonSelect = itemSamples.SelectButton:Clone()
				buttonSelect.Text = choice
				buttonSelect.Parent = clone

				local shouldHighlight = false
				if opts.associatedKey then
					if PointSaveAFEM:get(opts.associatedKey) == choice then
						shouldHighlight = true
					elseif not PointSaveAFEM:get(opts.associatedKey) and opts.selected == choice then
						shouldHighlight = true
						PointSaveAFEM:set(opts.associatedKey, choice)
					end
				elseif opts.selected == choice then
					shouldHighlight = true
				end

				if shouldHighlight then
					buttonSelect.BackgroundTransparency = 0.9
					if opts.triggerCallback then opts.callback(choice) end
				end

				buttonSelect.MouseButton1Click:Connect(function()
					for _, other in ipairs(clone:GetChildren()) do
						if other:IsA("TextButton") then other.BackgroundTransparency = 1 end
					end
					buttonSelect.BackgroundTransparency = 0.9
					if opts.associatedKey then PointSaveAFEM:set(opts.associatedKey, choice) end
					opts.callback(choice)
				end)
			end
			return clone
		end
	}

	local function AddItem(type, opts)
		local item = itemSamples:FindFirstChild(type)
		if not item then return end
		local handler = typeHandlers[item]
		if handler then
			local result = handler(opts)
			result.Parent = settingsListing
		end
	end

	AddItem("TextLabel", { label = "UGC Emotes" })
	AddItem("Toggle", { label = "Instantly cache UGC emotes animation ID", associatedKey = "settings_ugcCacheIds", enabled = true })
	AddItem("Toggle", { label = "Instantly cache UGC emotes animation track", associatedKey = "settings_ugcCacheTracks" })
	AddItem("TextLabel", { label = "Searching", type = "subText" })
	AddItem("Toggle", { label = "Occasionally generate search suggestions [AI]", associatedKey = "settings_ugcSearchSuggestion", enabled = true })

	AddItem("TextLabel", { label = "" })
	AddItem("TextLabel", { label = "Picker" })
	AddItem("TextLabel", { label = "Picker provider", type = "subText" })
	AddItem("Select", {
		selectables = { "Floating buttons", "Quick selector" },
		selected = "Floating buttons",
		triggerCallback = true,
		associatedKey = "settings_pickerProvider",
		callback = function(selected)
			Functions.PickerProvider(selected == "Floating buttons", selected == "Quick selector")
		end
	})

	AddItem("TextLabel", { label = "" })
	AddItem("TextLabel", { label = "Floating buttons" })
	AddItem("TextLabel", { label = "Floating buttons positioning", type = "subText" })
	AddItem("Select", {
		selectables = { "Autogrid", "Freeform" },
		selected = "Autogrid",
		triggerCallback = true,
		associatedKey = "settings_fbPositioning",
		callback = function(selected)
			local freeform = selected == "Freeform"
			root.FloatingButtons.Update:Fire(freeform)
			if freeform then
				if root.FloatingButtons:FindFirstChild("UIGridLayout") then
					root.FloatingButtons.UIGridLayout.Parent = timeoutFolder
				end
			else
				if timeoutFolder:FindFirstChild("UIGridLayout") then
					timeoutFolder.UIGridLayout.Parent = root.FloatingButtons
				end
			end
		end
	})

	AddItem("TextLabel", { label = "Floating buttons autogrid placement", type = "subText" })
	AddItem("Select", {
		selectables = { "Top right", "Top left", "Bottom right", "Bottom left" },
		selected = "Top right",
		triggerCallback = true,
		associatedKey = "settings_fbPlacement",
		callback = function(selected)
			local layout = root.FloatingButtons:FindFirstChild("UIGridLayout")
			if not layout then return end
			local alignments = {
				["Top right"] = { Vertical = Enum.VerticalAlignment.Top, Horizontal = Enum.HorizontalAlignment.Right },
				["Top left"] = { Vertical = Enum.VerticalAlignment.Top, Horizontal = Enum.HorizontalAlignment.Left },
				["Bottom right"] = { Vertical = Enum.VerticalAlignment.Bottom, Horizontal = Enum.HorizontalAlignment.Right },
				["Bottom left"] = { Vertical = Enum.VerticalAlignment.Bottom, Horizontal = Enum.HorizontalAlignment.Left }
			}
			local al = alignments[selected]
			if al then
				layout.VerticalAlignment = al.Vertical
				layout.HorizontalAlignment = al.Horizontal
			end
		end
	})

	AddItem("TextLabel", { label = "" })
	AddItem("TextLabel", { label = "Performance" })
	AddItem("Toggle", {
		label = "Avoid menu scaling transitions",
		associatedKey = "settings_perfAvoidScale",
		callback = function()
			Functions.Modal("Changed", "<b>Re-execute</b> to see changes take effect.", {"Continue", "Why this toggle?"}, nil, true)
			task.spawn(function()
				local result = Functions.WaitForModal()
				if result.selected == "Why this toggle?" then
					task.wait(0.1)
					Functions.Modal("Why this toggle?", "Transitions are using a spring-driven UIScale. While great for changing forms, they are <b>unoptimized</b> in the Roblox engine. Disabling this can give you roughly <b>50% more performance</b> when you open/close the menu.", {"Continue"})
				end
			end)
		end,
	})
	AddItem("Toggle", {
		label = "Screen blur (might be detected)",
		associatedKey = "settings_perfScreenBlur",
		enabled = true,
		callback = function()
			Functions.Modal("Changed", "<b>Re-execute</b> to see changes take effect.", {"Continue"})
		end,
	})

	AddItem("TextLabel", { label = "" })
	AddItem("TextLabel", { label = "Miscellaneous" })
	AddItem("Toggle", { label = "Start menu closed", associatedKey = "settings_startClosed" })
end

local function PaginationNSearchRoutine()
	local script = Instance.new("LocalScript")
	script.Name = "PaginationNSearch"
	script.Parent = Converted["_ItemSelect"]
	local req = require
	local require = function(obj)
		local fake = module_scripts[obj]
		if fake then return fake() end
		return req(obj)
	end

	repeat task.wait() until getgenv().AFEMLibraries
	local Functions = getgenv().AFEMLibraries.FNC
	local PointSaveAFEM = getgenv().AFEMLibraries.PSV.new("AFEMMaxConf")

	script.Parent.Emotes.PaginationBar.Next.MouseButton1Click:Connect(function()
		Functions.EmotePagination(true)
	end)

	script.Parent.Emotes.PaginationBar.Previous.MouseButton1Click:Connect(function()
		Functions.EmotePagination(false)
	end)

	script.Parent.Emotes.ActionBar.Search.Changed:Connect(function(prop)
		if prop == "Text" then
			Functions.RefreshEmotes(nil, script.Parent.Emotes.ActionBar.Search.Text)
		end
	end)

	local listingFrame = script.Parent.Emotes.Listing
	listingFrame.Changed:Connect(function(prop)
		if prop ~= "CanvasPosition" then return end
		if listingFrame.CanvasPosition.Y >= listingFrame.AbsoluteCanvasSize.Y - listingFrame.AbsoluteWindowSize.Y then
			if not PointSaveAFEM:get("tooltips_howToNext") then
				Functions.ShowTooltip(script.Parent.Emotes.PaginationBar.Next, "Click <b>Next</b> to see more emotes!")
				PointSaveAFEM:set("tooltips_howToNext", "1")
			end
		end
	end)

	script.Parent.Emotes.ActionBar.SwitchTabs.Roblox.MouseButton1Click:Connect(function()
		Functions.SwitchToUGC(false)
	end)

	script.Parent.Emotes.ActionBar.SwitchTabs.UGC.MouseButton1Click:Connect(function()
		Functions.SwitchToUGC(true)
	end)
end

local function DockingRoutine()
	local script = Instance.new("LocalScript")
	script.Name = "Docking"
	script.Parent = Converted["_AnimationController1"]
	local req = require
	local require = function(obj)
		local fake = module_scripts[obj]
		if fake then return fake() end
		return req(obj)
	end

	local TweenService = game:GetService("TweenService")
	local dockable = script.Parent.Dockable
	local dockswitch = script.Parent.DockerSwitch

	repeat task.wait() until getgenv().AFEMLibraries
	local Functions = getgenv().AFEMLibraries.FNC
	local Draggable = getgenv().AFEMLibraries.DGB

	local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

	local handleDrag = Draggable.new(dockable.Handle, dockable, false, true)
	handleDrag:Enable()
	handleDrag.Dragged = function(pos)
		TweenService:Create(dockable, tweenInfo, {
			Position = UDim2.new(0.5, pos.X.Offset, 0.5, pos.Y.Offset)
		}):Play()
	end

	local docked = false
	dockswitch.MouseButton1Click:Connect(function()
		docked = not docked

		if docked then
			dockswitch.Text = "Redock"
			dockable.Parent = script.Parent.Parent.Parent.Parent.Parent
			TweenService:Create(dockable.UICorner, tweenInfo, { CornerRadius = UDim.new(0, 16) }):Play()
			TweenService:Create(dockable.UIPadding, tweenInfo, {
				PaddingTop = UDim.new(0, 16),
				PaddingBottom = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 16),
				PaddingLeft = UDim.new(0, 16)
			}):Play()
			dockable.Handle.Visible = true
			TweenService:Create(dockable, tweenInfo, {
				Size = UDim2.fromOffset(400, 300),
				BackgroundTransparency = 0.5
			}):Play()
			script.Parent.Parent.Parent.Parent.MenuStateChange:Fire(false)
			Functions.Notification("Controller undocked", "Animation controller has been undocked to be outside the menu. Redock inside the menu to bring it back.")
		else
			dockswitch.Text = "Undock"
			dockable.UICorner.CornerRadius = UDim.new(0, 0)
			dockable.UIPadding.PaddingTop = UDim.new()
			dockable.UIPadding.PaddingBottom = UDim.new()
			dockable.UIPadding.PaddingRight = UDim.new()
			dockable.UIPadding.PaddingLeft = UDim.new()
			dockable.Handle.Visible = false
			TweenService:Create(dockable, tweenInfo, {
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, 0, 1, 0)
			}):Play()
			dockable.BackgroundTransparency = 1
			dockable.Parent = script.Parent
		end
	end)
end

local function AnimContSetupRoutine()
	local script = Instance.new("LocalScript")
	script.Name = "AnimContSetup"
	script.Parent = Converted["_Dockable"]
	local req = require
	local require = function(obj)
		local fake = module_scripts[obj]
		if fake then return fake() end
		return req(obj)
	end

	local TweenService = game:GetService("TweenService")
	local controllerListing = script.Parent.Listing
	local itemSamples = script.Parent.Samples

	repeat task.wait() until getgenv().AFEMLibraries.PSV
	local PointSaveAFEM = getgenv().AFEMLibraries.PSV.new("AFEMMaxConf")
	local Functions = getgenv().AFEMLibraries.FNC
	local Draggable = getgenv().AFEMLibraries.DGB

	local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

	local typeHandlers = {
		[itemSamples.TextLabel] = function(opts)
			local clone = itemSamples.TextLabel:Clone()
			if opts.type == "subText" then
				clone.Font = Enum.Font.Montserrat
				clone.Size = UDim2.new(1, 0, 0, 10)
			end
			clone.Text = opts.label
			return clone
		end,
		[itemSamples.Toggle] = function(opts)
			local clone = itemSamples.Toggle:Clone()
			clone.Label.Text = opts.label

			local enabled = opts.enabled
			if enabled then
				clone.ToggleTrack.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
				clone.ToggleTrack.Ball.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
				clone.ToggleTrack.Ball.AnchorPoint = Vector2.new(1, 0)
				clone.ToggleTrack.Ball.Position = UDim2.fromScale(1, 0)
			end

			clone.MouseButton1Click:Connect(function()
				enabled = not enabled
				if enabled then
					TweenService:Create(clone.ToggleTrack, tweenInfo, { BackgroundColor3 = Color3.fromRGB(220, 220, 220) }):Play()
					TweenService:Create(clone.ToggleTrack.Ball, tweenInfo, {
						BackgroundColor3 = Color3.fromRGB(48, 48, 48),
						Position = UDim2.new(1, 0),
						AnchorPoint = Vector2.new(1, 0)
					}):Play()
				else
					TweenService:Create(clone.ToggleTrack, tweenInfo, { BackgroundColor3 = Color3.fromRGB(48, 48, 48) }):Play()
					TweenService:Create(clone.ToggleTrack.Ball, tweenInfo, {
						BackgroundColor3 = Color3.fromRGB(220, 220, 220),
						Position = UDim2.new(0, 0),
						AnchorPoint = Vector2.new(0, 0)
					}):Play()
				end
				opts.callback(enabled)
			end)
			return clone
		end,
		[itemSamples.Select] = function(opts)
			local clone = itemSamples.Select:Clone()
			for _, choice in ipairs(opts.selectables) do
				local buttonSelect = itemSamples.SelectButton:Clone()
				buttonSelect.Text = choice
				buttonSelect.Parent = clone

				local shouldHighlight = opts.selected == choice
				if shouldHighlight then
					buttonSelect.BackgroundTransparency = 0.9
					if opts.triggerCallback then opts.callback(choice) end
				end

				buttonSelect.MouseButton1Click:Connect(function()
					for _, other in ipairs(clone:GetChildren()) do
						if other:IsA("TextButton") then other.BackgroundTransparency = 1 end
					end
					buttonSelect.BackgroundTransparency = 0.9
					opts.callback(choice)
				end)
			end
			return clone
		end
	}

	local function AddItem(type, opts)
		local item = itemSamples:FindFirstChild(type)
		if not item then return end
		local handler = typeHandlers[item]
		if handler then
			local result = handler(opts)
			result.Parent = controllerListing
		end
	end

	local SelectedAnimationTrack = nil
	local TrackTimeConn = nil
	local ReversedTrack = false
	local TrackSpeed = 1
	local TrackEnded = false
	local TrackEndedCon = nil

	local SpeedSettings = { "Paused", "Slower", "Slow", "Normal", "Fast", "Faster" }
	local SpeedConfig = { Paused = 0, Slower = 0.2, Slow = 0.65, Normal = 1, Fast = 1.25, Faster = 1.75 }
	local IntensityConfig = { Minimal = 0.20, Subtle = 0.45, Strong = 0.75, ["Full power"] = 1 }

	local SpeedReverseLookup = {}
	for k, v in pairs(SpeedConfig) do SpeedReverseLookup[v] = k end

	local seekbar = script.Parent.Seekbar

	local function CreateControllerEntries()
		seekbar.Visible = false
		for _, child in ipairs(controllerListing:GetChildren()) do
			if child:IsA("GuiBase2d") then child:Destroy() end
		end
		if TrackTimeConn then TrackTimeConn:Disconnect() end

		if not SelectedAnimationTrack then return end
		local track = SelectedAnimationTrack

		TrackEndedCon = track.Ended:Connect(function()
			TrackEnded = true
			TrackEndedCon:Disconnect()
		end)

		TrackTimeConn = game:GetService("RunService").Heartbeat:Connect(function()
			seekbar.Visible = true
			local progress = track.TimePosition / track.Length
			TweenService:Create(seekbar.Track.Ball, TweenInfo.new(0.05), {
				Position = UDim2.new(progress, 0, 0, 0),
				AnchorPoint = Vector2.new(progress, 0)
			}):Play()
			seekbar.Track.Ball.TimePos.Text = tostring(track.TimePosition):sub(1, 4)
			if TrackEnded or not track.IsPlaying then
				SelectedAnimationTrack = nil
				CreateControllerEntries()
			end
		end)

		AddItem("Toggle", {
			label = "Looping",
			enabled = track.Looped,
			callback = function(tog) track.Looped = tog end
		})

		AddItem("Toggle", {
			label = "Reverse",
			enabled = ReversedTrack,
			callback = function(tog)
				ReversedTrack = tog
				SelectedAnimationTrack:AdjustSpeed(math.abs(TrackSpeed) * (ReversedTrack and -1 or 1))
			end
		})

		AddItem("TextLabel", { label = "Animation speed", type = "subText" })
		AddItem("Select", {
			selectables = SpeedSettings,
			selected = SpeedReverseLookup[math.abs(TrackSpeed)] or "Normal",
			callback = function(selected)
				TrackSpeed = SpeedConfig[selected] * (ReversedTrack and -1 or 1)
				SelectedAnimationTrack:AdjustSpeed(TrackSpeed)
			end
		})

		AddItem("TextLabel", { label = "Animation intensity", type = "subText" })
		AddItem("Select", {
			selectables = { "Minimal", "Subtle", "Strong", "Full power" },
			selected = "Full power",
			callback = function(selected)
				SelectedAnimationTrack:AdjustWeight(IntensityConfig[selected], 0.1)
			end
		})
	end

	local dragSeekbar = Draggable.new(seekbar, seekbar, false, true)
	dragSeekbar:Enable()

	local relativeDrag = Vector2.new()
	local OriginalSpeed = TrackSpeed
	local TimePosStarting = 0

	dragSeekbar.DragStarted = function()
		relativeDrag = game:GetService("UserInputService"):GetMouseLocation()
		OriginalSpeed = TrackSpeed
		SelectedAnimationTrack:AdjustSpeed(0)
		TimePosStarting = SelectedAnimationTrack.TimePosition
		TweenService:Create(seekbar.Track.Ball.UIAspectRatioConstraint, tweenInfo, { AspectRatio = 2 }):Play()
		TweenService:Create(seekbar.Track.Ball.TimePos, tweenInfo, { TextTransparency = 0 }):Play()
	end

	dragSeekbar.Dragged = function()
		local drag = game:GetService("UserInputService"):GetMouseLocation()
		local shift = drag - relativeDrag
		if SelectedAnimationTrack then
			SelectedAnimationTrack.TimePosition = TimePosStarting + shift.X / 150
		end
	end

	dragSeekbar.DragEnded = function()
		SelectedAnimationTrack:AdjustSpeed(OriginalSpeed)
		TweenService:Create(seekbar.Track.Ball.UIAspectRatioConstraint, tweenInfo, { AspectRatio = 1 }):Play()
		TweenService:Create(seekbar.Track.Ball.TimePos, tweenInfo, { TextTransparency = 1 }):Play()
	end

	local function RefreshTrackList()
		local animator = game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid"):FindFirstChildWhichIsA("Animator")
		local tracks = animator:GetPlayingAnimationTracks()

		for _, child in ipairs(script.Parent.SelectTrack.Listing:GetChildren()) do
			if child:IsA("TextButton") and child.Visible then child:Destroy() end
		end

		for _, track in ipairs(tracks) do
			if track.Length == 0 then continue end
			local button = script.Parent.SelectTrack.Listing.Sample:Clone()
			button.TrackName.Text = track.Animation.Name
			button.LayoutOrder = track.Priority.Value * -1

			local function SelectFunc()
				SelectedAnimationTrack = track
				ReversedTrack = false
				TrackEnded = false
				TrackSpeed = 1
				CreateControllerEntries()
				TweenService:Create(script.Parent.SelectTrack, tweenInfo, {
					Size = UDim2.new(1, -4, 0, 35)
				}):Play()
			end

			button.MouseButton1Click:Connect(SelectFunc)
			button.Visible = true
			button.Parent = script.Parent.SelectTrack.Listing

			if track.Animation.Name == "AFEMInvokedEmote" and not SelectedAnimationTrack then
				SelectFunc()
			end
		end
	end

	local timeoutClose = nil
	script.Parent.SelectTrack.TextLabel.MouseEnter:Connect(function()
		TweenService:Create(script.Parent.SelectTrack, tweenInfo, {
			Size = UDim2.new(1, -4, 0, 125)
		}):Play()
		if timeoutClose then coroutine.close(timeoutClose); timeoutClose = nil end
		RefreshTrackList()
	end)

	script.Parent.SelectTrack.TextLabel.MouseLeave:Connect(function()
		timeoutClose = task.spawn(function()
			task.wait(4)
			TweenService:Create(script.Parent.SelectTrack, tweenInfo, {
				Size = UDim2.new(1, -4, 0, 35)
			}):Play()
		end)
	end)

	local refreshCounter = 10
	game:GetService("RunService").Heartbeat:Connect(function()
		refreshCounter = refreshCounter - 1
		if refreshCounter < 0 then
			refreshCounter = 10
			RefreshTrackList()
		end
	end)
end

local function MenuDisplacementRoutine()
	local script = Instance.new("LocalScript")
	script.Name = "MenuDisplacement"
	script.Parent = Converted["_Menu"]
	local req = require
	local require = function(obj)
		local fake = module_scripts[obj]
		if fake then return fake() end
		return req(obj)
	end

	local TweenService = game:GetService("TweenService")

	repeat task.wait() until getgenv().AFEMLibraries
	local SpringTween = getgenv().AFEMLibraries.SBT
	local Draggable = getgenv().AFEMLibraries.DGB
	local ClickAndHold = getgenv().AFEMLibraries.CAH
	local Functions = getgenv().AFEMLibraries.FNC
	local PointSaveAFEM = getgenv().AFEMLibraries.PSV.new("AFEMMaxConf")

	local blurObj = nil
	if PointSaveAFEM:get("settings_perfScreenBlur") == "1" then
		blurObj = Instance.new("BlurEffect")
		blurObj.Size = 0
		blurObj.Parent = game:GetService("Lighting")
	end

	local UseScale = true
	if PointSaveAFEM:get("settings_perfAvoidScale") == "1" then
		UseScale = false
	end

	local posTuneM, posTuneD, posTuneS = table.unpack(SpringTween.fromDurationAndBounce(0.3, 0))
	local sclTuneM, sclTuneD, sclTuneS = table.unpack(SpringTween.fromDurationAndBounce(0.5, 0.08))

	script.Parent.MenuSpringTakeover.Event:Wait()
	local menuTweenPos = SpringTween.new(script.Parent, "Position", posTuneM, posTuneD, posTuneS)
	local menuTweenSiz = SpringTween.new(script.Parent, "Size", 1, 19, 65)
	local menuTweenScl = SpringTween.new(script.Parent.UIScale, "Scale", sclTuneM, sclTuneD, sclTuneS)

	local blurSpring = nil
	if blurObj then
		blurSpring = SpringTween.new(blurObj, "Size", 1, 19, 65)
	end

	menuTweenPos:Start(); menuTweenSiz:Start()
	if UseScale then menuTweenScl:Start() end
	if blurSpring then blurSpring:Start(); blurSpring:SetGoal(50) end

	local quickSelectorFrame = script.Parent.Parent.QuickSelectorFrame
	local quickSelectorDrag = PointSaveAFEM:get("settings_pickerProvider") == "Quick selector" and true or false

	script.Parent.QuickSelectorIcon.Event:Connect(function(state)
		quickSelectorDrag = state
	end)

	local function SoftClamp(t, c) return (t^2)/(t+c) end

	local toHideOnClose = {
		script.Parent.Branding,
		script.Parent.Tip,
		script.Parent.ShamelessCredit
	}

	local closePos = UDim2.new(0, script.Parent.Parent.AbsoluteSize.X * 0.8, 0, script.Parent.Parent.AbsoluteSize.Y * 0.2)

	local function CloseMenu(velocity)
		if script.Parent.ItemDetail.Visible then return false end
		if velocity and velocity > 0 then
			menuTweenPos:SetGoal(UDim2.new(0.5, closePos.X.Offset / 2, 0.5, velocity * 5))
		end

		task.spawn(function()
			if velocity and velocity > 0 then task.wait(0.05) end
			menuTweenPos:SetGoal(closePos)
		end)
		menuTweenSiz:SetGoal(UDim2.new(0, 500, 0, 500))
		if UseScale then menuTweenScl:SetGoal(0.1) else script.Parent.UIScale.Scale = 0.1 end

		if blurSpring then blurSpring:SetGoal(-20) end

		local posTuneM, posTuneD, posTuneS = table.unpack(SpringTween.fromDurationAndBounce(0.18, 0.3))
		local sclTuneM, sclTuneD, sclTuneS = table.unpack(SpringTween.fromDurationAndBounce(0.2, 0.63))
		menuTweenPos:SetParameters(posTuneM, posTuneS, posTuneD)
		menuTweenScl:SetParameters(sclTuneM, sclTuneS, sclTuneD)

		script.Parent.Parent.GrabArea.Interactable = false
		script.Parent.Parent.Open.Interactable = true

		script.Parent.CanvasGroup.Interactable = true
		TweenService:Create(script.Parent.CanvasGroup, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			GroupTransparency = 0
		}):Play()
		TweenService:Create(script.Parent.CanvasGroup.UICorner, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			CornerRadius = UDim.new(1, 0)
		}):Play()
		TweenService:Create(script.Parent.UICorner, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			CornerRadius = UDim.new(1, 0)
		}):Play()

		task.spawn(function()
			task.wait(0.05)
			for _, v in pairs(toHideOnClose) do v.Visible = false end
		end)

		TweenService:Create(script.Parent.Bar.Tip, TweenInfo.new(.5), {
			TextTransparency = 1,
			BackgroundTransparency = 1
		}):Play()

		return true
	end

	local function OpenMenu()
		menuTweenPos:SetGoal(UDim2.new(0.5, 0, 0.5, 0))
		menuTweenSiz:SetGoal(UDim2.new(1, 0, 1, 0))
		if UseScale then menuTweenScl:SetGoal(1) else script.Parent.UIScale.Scale = 1 end

		local posTuneM, posTuneD, posTuneS = table.unpack(SpringTween.fromDurationAndBounce(0.3, 0))
		local sclTuneM, sclTuneD, sclTuneS = table.unpack(SpringTween.fromDurationAndBounce(0.24, 0.5))
		menuTweenPos:SetParameters(posTuneM, posTuneS, posTuneD)
		menuTweenScl:SetParameters(sclTuneM, sclTuneS, sclTuneD)

		script.Parent.Parent.GrabArea.Interactable = true
		script.Parent.Parent.Open.Interactable = false

		if blurSpring then blurSpring:SetGoal(50) end

		script.Parent.CanvasGroup.Interactable = false
		TweenService:Create(script.Parent.CanvasGroup, TweenInfo.new(.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			GroupTransparency = 1
		}):Play()
		TweenService:Create(script.Parent.CanvasGroup.UICorner, TweenInfo.new(.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			CornerRadius = UDim.new(0, 0)
		}):Play()
		TweenService:Create(script.Parent.UICorner, TweenInfo.new(.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			CornerRadius = UDim.new(0, 0)
		}):Play()

		for _, v in pairs(toHideOnClose) do v.Visible = true end
	end

	local grabDrag = Draggable.new(script.Parent.Parent.GrabArea, script.Parent, false, true)
	grabDrag:Enable()

	local lastDragPos = UDim2.new()
	local lastDragVel = 0

	grabDrag.Dragged = function(pos)
		local down = pos.Y.Offset
		lastDragVel = down - lastDragPos.Y.Offset
		lastDragPos = pos

		TweenService:Create(script.Parent.UICorner, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			CornerRadius = UDim.new(0, math.clamp(down / 0.8, 0, 32))
		}):Play()

		if blurSpring then blurSpring:SetGoal(50 - (down * 0.1)) end

		if UseScale then
			menuTweenScl:SetGoal(math.clamp(1 - down / 700, 0.8, 1))
		end
		menuTweenPos:SetGoal(UDim2.new(0.5, 0, 0.5, SoftClamp(down, 200)))
	end

	grabDrag.DragEnded = function()
		if lastDragPos.Y.Offset > 100 or lastDragVel > 5 then
			if not CloseMenu(lastDragVel) then
				if UseScale then menuTweenScl:SetGoal(1) end
				menuTweenPos:SetGoal(UDim2.new(0.5, 0, 0.5, 0))
				if blurSpring then blurSpring:SetGoal(50) end
				TweenService:Create(script.Parent.UICorner, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					CornerRadius = UDim.new(0, 0)
				}):Play()
			end
		else
			if UseScale then menuTweenScl:SetGoal(1) end
			menuTweenPos:SetGoal(UDim2.new(0.5, 0, 0.5, 0))
			if blurSpring then blurSpring:SetGoal(50) end
			TweenService:Create(script.Parent.UICorner, TweenInfo.new(.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				CornerRadius = UDim.new(0, 0)
			}):Play()
		end
	end

	script.Parent.Parent.GrabArea.MouseButton1Click:Connect(CloseMenu)

	local closeDrag = Draggable.new(script.Parent.Parent.Open, script.Parent, false, true)
	closeDrag:Enable()
	local shouldOpen = true

	local closeHeld = ClickAndHold.new(script.Parent.Parent.Open)
	local relativePoint = UDim2.new()
	local cursorObject = nil
	local quickSelectorFrameOpen = false
	local quickSelectorFocusingEmote = nil
	local quickSelectorFrameCloseQuick = false
	local brokenFree = false

	closeHeld.Holded.Event:Connect(function()
		if not quickSelectorDrag then return end
		brokenFree = true
		menuTweenScl:SetGoal(0.15)
		task.wait(0.1)
		menuTweenScl:SetGoal(0.1)
	end)

	local alreadyDragging = false

	closeDrag.DragStarted = function()
		if quickSelectorDrag and not alreadyDragging then
			alreadyDragging = true
			local screenWidth = script.Parent.Parent.AbsoluteSize.X
			local inputAreaWidth = screenWidth / 2.5
			relativePoint = game:GetService("UserInputService"):GetMouseLocation()
			local minInputX = relativePoint.X - (inputAreaWidth / 2)

			cursorObject = Instance.new("Frame")
			cursorObject.BackgroundTransparency = 1
			cursorObject.Size = UDim2.fromOffset(20, 20)
			cursorObject.AnchorPoint = Vector2.new(0.5, 0.5)
			cursorObject.Position = UDim2.fromScale(0.5, 0.1)

			local round = Instance.new("UICorner")
			round.CornerRadius = UDim.new(1, 0)
			round.Parent = cursorObject

			cursorObject.Parent = script.Parent.Parent

			TweenService:Create(cursorObject, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.2,
				Size = UDim2.fromOffset(40, 40)
			}):Play()

			quickSelectorFrame.Position = UDim2.new(0.5, 0, 0, -160)

			if quickSelectorFrame.ScrollingFrame.AbsoluteCanvasSize.X > quickSelectorFrame.ScrollingFrame.AbsoluteSize.X then
				quickSelectorFrame.ScrollingFrame.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			else
				quickSelectorFrame.ScrollingFrame.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			end
		end
	end

	local function TweenScale(scaleObj, target, duration)
		if scaleObj then
			TweenService:Create(scaleObj, TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Scale = target
			}):Play()
		end
	end

	local function ResetFrameScales(container)
		for _, frame in ipairs(container:GetChildren()) do
			if frame:IsA("Frame") then
				local scale = frame:FindFirstChildOfClass("UIScale")
				TweenScale(scale, 1)
			end
		end
	end

	local function FadeOutCursor(cursor, size, duration, onComplete)
		local fade = TweenService:Create(cursor, TweenInfo.new(duration, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(size, size)
		})
		fade.Completed:Connect(function()
			cursor:Destroy()
			if onComplete then onComplete() end
		end)
		fade:Play()
	end

	closeDrag.Dragged = function(pos)
		shouldOpen = false

		if quickSelectorDrag and cursorObject and not brokenFree then
			local currentMousePos = Vector2.new(pos.X.Offset, pos.Y.Offset)
			local mouseProgressX = (currentMousePos.X - minInputX) / inputAreaWidth
			local newCursorScaleX = math.clamp(mouseProgressX, 0, 1)
			local relativeDelta = currentMousePos - relativePoint

			TweenService:Create(cursorObject, TweenInfo.new(0.1), {
				Position = UDim2.new(newCursorScaleX, 0, 0.1, relativeDelta.Y)
			}):Play()

			if quickSelectorFrame.ScrollingFrame.AbsoluteCanvasSize.X > quickSelectorFrame.ScrollingFrame.AbsoluteSize.X then
				TweenService:Create(quickSelectorFrame.ScrollingFrame, TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					CanvasPosition = Vector2.new((quickSelectorFrame.ScrollingFrame.AbsoluteCanvasSize.X - quickSelectorFrame.ScrollingFrame.AbsoluteWindowSize.X) * newCursorScaleX, 0)
				}):Play()
			end

			quickSelectorFocusingEmote = nil
			for _, frame in ipairs(quickSelectorFrame.ScrollingFrame:GetChildren()) do
				if frame:IsA("Frame") then
					local absPos, absSize = frame.AbsolutePosition, frame.AbsoluteSize
					local cursorCenter = cursorObject.AbsolutePosition + (cursorObject.AbsoluteSize / 2)
					if cursorCenter.X >= absPos.X and cursorCenter.X <= absPos.X + absSize.X
						and cursorCenter.Y >= absPos.Y and cursorCenter.Y <= absPos.Y + absSize.Y then
						TweenScale(frame:FindFirstChildOfClass("UIScale"), 1.1, 0.15)
						quickSelectorFocusingEmote = frame
					else
						TweenScale(frame:FindFirstChildOfClass("UIScale"), 1, 0.15)
					end
				end
			end

			quickSelectorFrameCloseQuick = quickSelectorFocusingEmote ~= nil

			if not quickSelectorFrameOpen and not brokenFree then
				quickSelectorFrameOpen = true
				quickSelectorFrameCloseQuick = false

				TweenService:Create(quickSelectorFrame, TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Position = UDim2.new(0.5, 0, 0, 0),
					GroupTransparency = 0
				}):Play()
				TweenService:Create(quickSelectorFrame.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Transparency = 0.5
				}):Play()

				ResetFrameScales(quickSelectorFrame.ScrollingFrame)
			end

			if relativeDelta.Magnitude > 400 then
				brokenFree = true
			end

		else
			if cursorObject then
				task.spawn(function()
					FadeOutCursor(cursorObject, 20, 0.3)
					if quickSelectorFrameOpen then
						quickSelectorFrameOpen = false
						TweenService:Create(quickSelectorFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
							Position = UDim2.new(0.5, 0, 0, -75),
							GroupTransparency = 1
						}):Play()
						TweenService:Create(quickSelectorFrame.UIStroke, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
							Transparency = 1
						}):Play()
						ResetFrameScales(quickSelectorFrame.ScrollingFrame)
					end
				end)
			end

			closePos = pos
			script.Parent.Parent.Open.Position = pos
			menuTweenPos:SetGoal(pos)
		end
	end

	closeDrag.DragEnded = function()
		brokenFree = false
		alreadyDragging = false
		task.spawn(function()
			task.wait(0.1)
			shouldOpen = true
		end)

		if cursorObject then
			task.spawn(function()
				FadeOutCursor(cursorObject, 20, 0.1)

				quickSelectorFrameOpen = false
				local duration = quickSelectorFrameCloseQuick and 0.2 or 0.8

				TweenService:Create(quickSelectorFrame, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Position = UDim2.new(0.5, 0, 0, -75),
					GroupTransparency = 1
				}):Play()
				TweenService:Create(quickSelectorFrame.UIStroke, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Transparency = 1
				}):Play()

				ResetFrameScales(quickSelectorFrame.ScrollingFrame)

				if quickSelectorFocusingEmote then
					local animId = quickSelectorFocusingEmote:GetAttribute("animID")
					if animId then Functions.PlayAnimation(animId) end
					quickSelectorFocusingEmote = nil
				end
			end)
		end
	end

	script.Parent.Parent.Open.MouseButton1Click:Connect(function()
		if shouldOpen then OpenMenu() end
	end)

	script.Parent.MenuStateChange.Event:Connect(function(state)
		if state then OpenMenu() else CloseMenu() end
	end)

	script.Parent.Parent.Open.Position = closePos
end

local function PreviewRoutine()
	local script = Instance.new("LocalScript")
	script.Name = "Preview"
	script.Parent = Converted["_AvatarPreview"]
	local req = require
	local require = function(obj)
		local fake = module_scripts[obj]
		if fake then return fake() end
		return req(obj)
	end

	local viewportFrame = script.Parent
	local players = game:GetService("Players")
	local localPlayer = players.LocalPlayer
	local TweenService = game:GetService("TweenService")

	repeat task.wait() until getgenv().AFEMLibraries
	local Draggable = getgenv().AFEMLibraries.DGB

	local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
	character:WaitForChild("HumanoidRootPart")
	character.Archivable = true

	local clone = character:Clone()
	for _, obj in ipairs(clone:GetDescendants()) do
		if obj:IsA("Script") or obj:IsA("LocalScript") then obj:Destroy() end
	end
	clone.Parent = viewportFrame.WorldModel

	local camera = Instance.new("Camera")
	camera.Parent = viewportFrame.WorldModel
	viewportFrame.CurrentCamera = camera

	clone:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))

	local cameraPos = Vector3.new(0, 0, -7)
	local cameraRot = CFrame.Angles(0, math.rad(180), 0)
	local initialCameraCFrame = CFrame.new(cameraPos) * cameraRot
	camera.CFrame = initialCameraCFrame

	script.Parent.PlayEmote.Event:Connect(function(id, attention)
		local animator = clone.Humanoid:FindFirstChildOfClass("Animator")
		if animator then
			for _, track in animator:GetPlayingAnimationTracks() do track:Stop() end
			local animation = Instance.new("Animation")
			animation.AnimationId = id
			local track = animator:LoadAnimation(animation)
			track:Play()

			if attention then
				TweenService:Create(script.Parent.UIScale, TweenInfo.new(0.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
					Scale = 1.2
				}):Play()
				task.wait(0.1)
				TweenService:Create(script.Parent.UIScale, TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
					Scale = 1
				}):Play()
			end
		end
	end)

	local rotCam = Draggable.new(script.Parent.Drag, script.Parent, false, true)
	rotCam:Enable()

	rotCam.Dragged = function(drag)
		local rotationY = math.rad(drag.X.Offset * -1)
		local rotation = CFrame.Angles(0, rotationY, 0)
		camera.CFrame = rotation * initialCameraCFrame
	end

	rotCam.DragEnded = function()
		initialCameraCFrame = camera.CFrame
	end

	task.wait(1)
	script.Parent.PlayEmote:Fire("rbxassetid://132861892011980")
end

-- Start all routines
coroutine.wrap(InitRoutine)()
coroutine.wrap(HoverEffectRoutine)()
coroutine.wrap(SwitchSCRRoutine)()
coroutine.wrap(SpinRoutine)()
coroutine.wrap(FavoritesSetupRoutine)()
coroutine.wrap(PackEditorScrRoutine)()
coroutine.wrap(SettingsSetupRoutine)()
coroutine.wrap(PaginationNSearchRoutine)()
coroutine.wrap(DockingRoutine)()
coroutine.wrap(AnimContSetupRoutine)()
coroutine.wrap(MenuDisplacementRoutine)()
coroutine.wrap(PreviewRoutine)()