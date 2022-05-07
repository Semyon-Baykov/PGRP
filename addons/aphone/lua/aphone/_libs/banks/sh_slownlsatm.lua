hook.Add("PostGamemodeLoaded", "Aphone_SlownLSATM", function()
    if SlownLS and SlownLS.ATM then
        local p = FindMetaTable("Player")

        if aphone.Bank then
            print("[APhone] Do you got multiples printers addons ? The last loaded printer will be used for the bank app")
        end

        aphone.Bank = aphone.Bank or {}

        aphone.Bank.clr = Color(231, 76, 60)
        aphone.Bank.logo = Material("akulla/aphone/atm.png", "smooth 1")

        function p:aphone_bankWithdraw(amt)
            if amt < 0 or !SlownLS.ATM:CanAfford(self, amt) then return end

            SlownLS.ATM:Withdraw(self:SteamID64(), amt)
            SlownLS.ATM:AddLog(self, "APhone - -" .. amt)
            aphone.Gamemode.AddMoney(self, amt)
        end

        function p:aphone_bankDeposit(amt)
            if amt < 0 or !aphone.Gamemode.Afford(self, amt) then return end

            SlownLS.ATM:Deposit(self:SteamID64(), amt)
            SlownLS.ATM:AddLog(self, "APhone - +" .. amt)
            aphone.Gamemode.AddMoney(self, -amt)
        end

        function p:aphone_bankTransfer(ply2, amt)
            if amt < 0 or !SlownLS.ATM:CanAfford(self, amt) then return end

            SlownLS.ATM:Withdraw(self:SteamID64(), amt)
            SlownLS.ATM:Deposit(ply2:SteamID64(), amt)
            SlownLS.ATM:AddLog(ply2, "APhone - +" .. amt)
            SlownLS.ATM:AddLog(self, "APhone - -" .. amt)
        end

        function p:aphone_getmoney()
            return SERVER and self:GetBankBalance() or LocalPlayer():SlownLS_ATM_Balance()
        end

        function aphone.Bank.FormatMoney(amt)
            return aphone.Gamemode.Format(amt)
        end
    end
end)