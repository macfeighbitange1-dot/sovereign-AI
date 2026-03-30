import requests
import json

class SovereignAnalyst:
    def __init__(self, wallet_id, base_url="http://localhost:3000"):
        self.wallet_id = wallet_id
        self.base_url = base_url

    def fetch_financial_data(self):
        # Sensory Input: Get Balance and History from your Ruby Ledger
        balance_res = requests.get(f"{self.base_url}/wallets/{self.wallet_id}/balance").json()
        history_res = requests.get(f"{self.base_url}/wallets/{self.wallet_id}/history").json()
        return balance_res, history_res

    def analyze(self):
        balance_data, history_data = self.fetch_financial_data()
        transactions = history_data['transactions']
        
        # Logic: Calculate Inflow vs Outflow
        total_in = sum(t['amount'] for t in transactions if t['event_type'] == 'MoneyDeposited')
        total_out = sum(t['amount'] for t in transactions if t['event_type'] == 'MoneyWithdrawn')
        
        print(f"--- NAIROBI NODE: SOVEREIGN ANALYSIS FOR WALLET {self.wallet_id} ---")
        print(f"Current Liquidity: {balance_data['balance']} KES")
        print(f"Total Capital Ingress: {total_in} KES")
        print(f"Total Capital Egress: {total_out} KES")
        
        # The "Genius" Insight
        if total_out > (total_in * 0.5):
            print("\n[!] WARNING: Burn rate is high. Egress is >50% of Ingress.")
            print("Recommendation: Freeze non-essential withdrawals to preserve sovereignty.")
        else:
            print("\n[+] STATUS: Healthy Accumulation. Capital position is strong.")

if __name__ == "__main__":
    analyst = SovereignAnalyst(wallet_id="1")
    analyst.analyze()
