hook.Add("PostGamemodeLoaded", "Aphone_BluesATM", function()
    if BATM then
        local Accounts = CBLib.LoadModule("batm/bm_accounts.lua", false)
        local p = FindMetaTable("Player")

        if aphone.Bank then
            print("[APhone] Do you got multiples printers addons ? The last loaded printer will be used for the bank app")
        end

        aphone.Bank = aphone.Bank or {}

        aphone.Bank.clr = Color(52, 152, 219)
        aphone.Bank.logo = Material("akulla/aphone/atm.png", "smooth 1")

        function p:aphone_bankWithdraw(amt)
            if amt < 0 then return end
            local ply = self

            Accounts.GetCachedPersonalAccount(self:SteamID64(), function(account)
                --Check if they have enough
                if account.balance - amt >= 0 then
                    account:AddBalance(-amt, "Withdrawal from account owner.")
                    aphone.Gamemode.AddMoney(ply, amt)
                    account:SaveAccount()
                    BATM.NetworkAccount(ply, account)
                end
            end)
        end

        function p:aphone_bankDeposit(amt)
            local ply = self
            if amt < 0 or aphone.Gamemode.GetMoney(ply) < amt then return end

            Accounts.GetCachedPersonalAccount(ply:SteamID64(), function(account)
                account:AddBalance(amt, "APhone")
                aphone.Gamemode.AddMoney(ply, -amt)

                account:SaveAccount()
                BATM.NetworkAccount(ply, account)
            end)
        end

        function p:aphone_bankTransfer(target, amt)
            if amt < 0 then return end

            local ply = self

            Accounts.GetCachedPersonalAccount(ply:SteamID64(), function(account)
                if account:GetBalance() - amt >= 0 then
                    Accounts.GetCachedPersonalAccount(target, function(targetAccount, didExist)
                        if !IsValid(ply) then return end --Dont do anything as that player has left now
                        if didExist and account:GetBalance() - amount >= 0 then
                            --Take money
                            account:AddBalance(-amount, "Transfer to '"..target.."'")
                            account:SaveAccount()

                            --Add money
                            targetAccount:AddBalance(amount, "Transfer from '"..ply:SteamID64().."'")
                            targetAccount:SaveAccount()	
    
                            --Update display
                            BATM.NetworkAccount(ply, account)

                            ply.batmtransfercooldown = CurTime() + 1.5

                            --If the player is online who he transfered to, then go ahead and network it to them too
                            if player.GetBySteamID64(target) ~= false then
                                BATM.NetworkAccount(player.GetBySteamID64(target) , targetAccount)
                            end
                        end
                    end)
                end
            end)
        end

        function p:aphone_getmoney()
            return BATM.GetPersonalAccount().balance
        end

        function aphone.Bank.FormatMoney(amt)
            return BATM.Lang["$"] .. CBLib.Helper.CommaFormatNumber(amt)
        end
    end
end)