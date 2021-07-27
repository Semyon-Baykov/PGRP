hook.Add("PostGamemodeLoaded", "Aphone_GB", function()
    if GlorifiedBanking then
        local p = FindMetaTable("Player")

        if aphone.Bank then
            print("[APhone] Do you got multiples printers addons ? The last loaded printer will be used for the bank app")
        end

        aphone.Bank = aphone.Bank or {}

        aphone.Bank.clr = Color(5, 116, 179)
        aphone.Bank.logo = Material("glorified_banking/logo_small.png", "smooth 1")
        aphone.Bank.name = "GlorifiedBanking"

        function p:aphone_bankWithdraw(amt)
            if amt < 0 or !self:CanAffordBank(amt) then return end
            self:WithdrawFromBank(amt)
        end

        function p:aphone_bankDeposit(amt)
            if amt < 0 or !aphone.Gamemode.Afford(self, amt) then return end
            self:DepositToBank( amt )
        end

        function p:aphone_bankTransfer(ply2, amt)
            if amt < 0 or !self:CanAffordBank(amt) then return end
            self:TransferBankMoney(ply2, amt)
        end

        function p:aphone_getmoney()
            return self:GetBankBalance()
        end

        function aphone.Bank.FormatMoney(amt)
            return GlorifiedBanking.FormatMoney(amt)
        end
    end
end)