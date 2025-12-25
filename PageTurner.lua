-- PageTurner.lua
-- Vanilla WoW 1.12.1 compatible
-- Scroll DOWN = Next page
-- Scroll UP   = Previous page
-- BlizzMo-safe (Ctrl+Scroll untouched)

local hookedFrames = {}

-- =========================
-- Utility
-- =========================

local function HookMouseWheel(frame, handler)
    if not frame or hookedFrames[frame] then return end
    if not frame.EnableMouseWheel then return end

    frame:EnableMouseWheel(true)

    local original = frame:GetScript("OnMouseWheel")

    frame:SetScript("OnMouseWheel", function()
        -- Allow BlizzMo scaling
        if IsControlKeyDown() then
            if original then original() end
            return
        end

        -- PageTurner logic
        if handler() then
            return
        end

        -- Fallback
        if original then original() end
    end)

    hookedFrames[frame] = true
end

local function ClickIfEnabled(button)
    if button and button:IsShown() and button:IsEnabled() then
        button:Click()
        return true
    end
end

-- =========================
-- Handlers
-- =========================
-- arg1 < 0  → scroll DOWN  → NEXT page
-- arg1 > 0  → scroll UP    → PREV page

local function MerchantHandler()
    if arg1 < 0 then
        return ClickIfEnabled(MerchantNextPageButton)
    else
        return ClickIfEnabled(MerchantPrevPageButton)
    end
end

local function MailHandler()
    if arg1 < 0 then
        return ClickIfEnabled(InboxNextPageButton)
    else
        return ClickIfEnabled(InboxPrevPageButton)
    end
end

local function GossipHandler()
    if arg1 < 0 then
        return ClickIfEnabled(GossipNextPageButton)
    else
        return ClickIfEnabled(GossipPrevPageButton)
    end
end

local function QuestHandler()
    if arg1 < 0 then
        return ClickIfEnabled(QuestFrameNextButton)
    else
        return ClickIfEnabled(QuestFramePrevButton)
    end
end

local function BookHandler()
    if arg1 < 0 then
        return ClickIfEnabled(BookNextPageButton)
    else
        return ClickIfEnabled(BookPrevPageButton)
    end
end

local function SpellBookHandler()
    if arg1 < 0 then
        return ClickIfEnabled(SpellBookNextPageButton)
    else
        return ClickIfEnabled(SpellBookPrevPageButton)
    end
end

local function ItemTextHandler()
    if arg1 < 0 then
        return ClickIfEnabled(ItemTextNextPageButton)
    else
        return ClickIfEnabled(ItemTextPrevPageButton)
    end
end

-- =========================
-- Hook visible frames
-- =========================

local function TryHookFrames()
    if MerchantFrame and MerchantFrame:IsShown() then
        HookMouseWheel(MerchantFrame, MerchantHandler)
    end

    if MailFrame and MailFrame:IsShown() then
        HookMouseWheel(MailFrame, MailHandler)
    end

    if GossipFrame and GossipFrame:IsShown() then
        HookMouseWheel(GossipFrame, GossipHandler)
    end

    if QuestFrame and QuestFrame:IsShown() then
        HookMouseWheel(QuestFrame, QuestHandler)
    end

    if BookFrame and BookFrame:IsShown() then
        HookMouseWheel(BookFrame, BookHandler)
    end

    -- ✅ Spellbook explicitly enabled
    if SpellBookFrame and SpellBookFrame:IsShown() then
        HookMouseWheel(SpellBookFrame, SpellBookHandler)
    end

    if ItemTextFrame and ItemTextFrame:IsShown() then
        HookMouseWheel(ItemTextFrame, ItemTextHandler)
    end
end

-- =========================
-- Events
-- =========================

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("MERCHANT_SHOW")
f:RegisterEvent("MAIL_SHOW")
f:RegisterEvent("GOSSIP_SHOW")
f:RegisterEvent("QUEST_DETAIL")
f:RegisterEvent("QUEST_PROGRESS")
f:RegisterEvent("QUEST_COMPLETE")
f:RegisterEvent("SPELLS_CHANGED")
f:RegisterEvent("ITEM_TEXT_BEGIN")
f:RegisterEvent("ITEM_TEXT_READY")

f:SetScript("OnEvent", function()
    TryHookFrames()
end)
