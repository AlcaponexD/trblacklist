local TRBlacklist = {}

-- Exemplo de salvamento de variáveis em SavedVariables
TRBlacklistSavedVariables = {}

function TRBlacklist:AddPlayerToBlacklist(playerName)
    table.insert(self, playerName)
    table.insert(TRBlacklistSavedVariables, playerName)

    print(playerName .. " adicionado à lista negra.")
end

function TRBlacklist:PrintBlacklist()
    print("Lista Negra:")
    for chave, valor in pairs(TRBlacklistSavedVariables) do
        print("Nome-Realm:", valor)
    end
end

SLASH_TRBLACKLIST1 = "/trb"
SlashCmdList["TRBLACKLIST"] = function(msg)
    local command, playerName = strsplit(" ", msg, 2)

    if command == "add" and playerName then
        TRBlacklist:AddPlayerToBlacklist(playerName)
    elseif command == "list" then
        TRBlacklist:PrintBlacklist()
    else
        print("Comandos disponíveis:")
        print("/trb add <nome_do_jogador>")
        print("/trb list")
    end
end
local label_report_player = ""

StaticPopupDialogs["REPORT_POPUP"] = {
    text = label_report_player,
    button1 = "Sim",
    button2 = "Não",
    OnAccept = function()
        -- Lógica a ser executada quando o jogador clica em "Sim"
        print("Ação realizada quando o jogador clicou em 'Sim'")
    end,
    OnCancel = function()
        -- Lógica a ser executada quando o jogador clica em "Não"
        print("Ação realizada quando o jogador clicou em 'Não'")
    end,
    timeout = 0, -- Tempo limite (0 para desativar o tempo limite)
    whileDead = true,
    hideOnEscape = true
}

-- Função para mostrar o popup
local function ShowReportPopup(data)
    StaticPopup_Show("REPORT_POPUP", data)
end

-- Função de callback para eventos de chat
local function OnChatEvent(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
    -- Verifique se o evento é relacionado a mudanças no grupo
    if event == "CHAT_MSG_SYSTEM" then
        local playerName, eventText = strsplit(" ", arg1, 2) -- Texto do evento

        -- Verifique se o evento é uma mensagem de saída do grupo
        if eventText == "sai do grupo." then
            print(playerName .. " saiu do grupo.")
            -- Adicione aqui a lógica para lidar com a saída do jogador do grupo
            label_report_player = "Deseja reportar o player " .. playerName
            ShowReportPopup()
        end
    end
end

-- Registre a função de callback para o evento de chat
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", OnChatEvent)
