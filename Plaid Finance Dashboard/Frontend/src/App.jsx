// src/App.jsx
import React, { useEffect, useState } from "react";
import "./App.css";
import PlaidLinkButton from "./components/PlaidLinkButton";

// 👇 make sure these components exist in src/components/
import { AccountsTable } from "./components/AccountsTable";
import { BudgetSummary } from "./components/BudgetSummary";
import { TransactionsTable } from "./components/TransactionsTable";
import { AnalyticsPanel } from "./components/AnalyticsPanel";
import { SpendingCharts } from "./components/SpendingCharts";

// ✅ Use env var for backend URL (Render in prod, localhost in dev)
const API_BASE =
  import.meta.env.VITE_API_BASE_URL || "http://localhost:5001";

function App() {
  const [backendInfo, setBackendInfo] = useState(null);
  const [linkToken, setLinkToken] = useState(null);
  const [isItemConnected, setIsItemConnected] = useState(false);
  const [isRefreshing, setIsRefreshing] = useState(false);

  const [accounts, setAccounts] = useState([]);
  const [transactions, setTransactions] = useState([]);
  const [txLoaded, setTxLoaded] = useState(false);

  // On mount: check backend + get Plaid link_token
  useEffect(() => {
    checkBackend();
    createLinkToken();
  }, []);

  // ---- Backend health (matches your existing Node backend) ----
  const checkBackend = async () => {
    try {
      const [rootRes, dbRes] = await Promise.all([
        fetch(`${API_BASE}/`),
        fetch(`${API_BASE}/api/test-db`),
      ]);

      const rootText = await rootRes.text().catch(() => null);
      const dbJson = await dbRes.json().catch(() => null);

      let dbTime = null;
      if (Array.isArray(dbJson) && dbJson[0]?.now) {
        dbTime = dbJson[0].now;
      } else if (dbJson?.time) {
        dbTime = dbJson.time;
      }

      setBackendInfo({
        message: rootText,
        dbTime,
        db_time: dbTime,
      });
    } catch (err) {
      console.error("Error checking backend:", err);
      setBackendInfo(null);
    }
  };

  // ---- Plaid link_token (uses your backend route) ----
  const createLinkToken = async () => {
    try {
      const res = await fetch(`${API_BASE}/api/create-link-token`, {
        method: "POST",
      });
      const data = await res.json();
      if (data.link_token) {
        setLinkToken(data.link_token);
      } else {
        console.error("No link_token in response:", data);
      }
    } catch (err) {
      console.error("Error creating link token:", err);
    }
  };

  // ---- Fetch accounts & transactions from backend ----
  const fetchAccounts = async () => {
    try {
      const res = await fetch(`${API_BASE}/api/accounts`);
      const data = await res.json();
      setAccounts(Array.isArray(data) ? data : []);
    } catch (err) {
      console.error("Error fetching accounts:", err);
    }
  };

  const fetchTransactions = async () => {
    try {
      const res = await fetch(`${API_BASE}/api/transactions`);
      const data = await res.json();
      setTransactions(Array.isArray(data) ? data : []);
      setTxLoaded(true);
    } catch (err) {
      console.error("Error fetching transactions:", err);
      setTxLoaded(true);
    }
  };

  // ---- Called by PlaidLinkButton on success ----
  // Exchanges public_token via /api/exchange-public-token
  const handleLinkSuccess = async (public_token, metadata) => {
    try {
      await fetch(`${API_BASE}/api/exchange-public-token`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ public_token }),
      });

      setIsItemConnected(true);

      // Once connected, load data
      await Promise.all([fetchAccounts(), fetchTransactions(), checkBackend()]);
    } catch (err) {
      console.error("Error setting access token:", err);
    }
  };

  // ---- Refresh button: re-fetch transactions ----
  const handleRefreshClick = async () => {
    if (!isItemConnected) return;

    try {
      setIsRefreshing(true);
      await fetchTransactions();
      await checkBackend();
    } catch (err) {
      console.error("Error refreshing data:", err);
    } finally {
      setIsRefreshing(false);
    }
  };

  const dbTime = backendInfo?.db_time || backendInfo?.dbTime;
  const backendMessage =
    backendInfo?.message || (backendInfo ? "Backend API is running ✅" : null);

  return (
    <div className="App">
      <header className="app-header">
        <h1 className="app-title">Plaid Finance Dashboard</h1>
        <p className="app-subtitle">
          Full-stack demo: Plaid sandbox · Node/Express · Postgres · React.
        </p>
      </header>

      <main className="content-column">
        {/* OVERVIEW CARD (unchanged design) */}
        <section className="card">
          <div className="card-header-row">
            <div>
              <p className="card-eyebrow">OVERVIEW</p>
              <h2 className="card-title">Backend &amp; connection status</h2>
              <p className="card-description">
                Health of your API, database, and Plaid connection. All data is
                from the sandbox environment.
              </p>
            </div>

            <span className="pill pill-muted">
              {isItemConnected ? "Connected" : "Not connected"}
            </span>
          </div>

          <div className="card-body-row">
            <div className="card-column">
              <p className="field-label">Backend</p>
              <p className="field-value">
                {backendMessage || "Checking…"}
              </p>
              <p className="field-subvalue">
                {dbTime ? `DB time: ${dbTime}` : null}
              </p>
            </div>

            <div className="card-column">
              <p className="field-label">Actions</p>
              <div className="actions-row">
                <PlaidLinkButton
                  linkToken={linkToken}
                  onSuccess={handleLinkSuccess}
                  disabled={!linkToken || isItemConnected}
                  className="btn-primary"
                >
                  {isItemConnected
                    ? "Bank account connected"
                    : "Connect bank account"}
                </PlaidLinkButton>

                <button
                  className="btn-ghost"
                  onClick={handleRefreshClick}
                  disabled={!isItemConnected || isRefreshing}
                >
                  {isRefreshing ? "Refreshing…" : "Refresh data"}
                </button>
              </div>
            </div>
          </div>
        </section>

        {/* EXTRA CARDS: only show once bank is connected */}
        {isItemConnected && (
          <>
            <AccountsTable accounts={accounts} />
            <BudgetSummary transactions={transactions} txLoaded={txLoaded} />
            <AnalyticsPanel transactions={transactions} />
            <SpendingCharts transactions={transactions} />
            <TransactionsTable
              transactions={transactions}
              txLoaded={txLoaded}
            />
          </>
        )}
      </main>
    </div>
  );
}

export default App;
