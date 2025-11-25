// src/components/BudgetSummary.jsx
import React, { useMemo } from "react";

export function BudgetSummary({ transactions, txLoaded }) {
  // Loading + empty states
  if (!txLoaded) {
    return (
      <section className="card">
        <p className="card-eyebrow">SPENDING</p>
        <h2 className="card-title">Spending & budgets</h2>
        <p className="card-description">Loading recent spending data…</p>
      </section>
    );
  }

  if (!transactions || transactions.length === 0) {
    return (
      <section className="card">
        <p className="card-eyebrow">SPENDING</p>
        <h2 className="card-title">Spending & budgets</h2>
        <p className="card-description">
          Connect a bank account and refresh data to see your spending breakdown and
          budget suggestions.
        </p>
      </section>
    );
  }

  const now = new Date();
  const THIRTY_DAYS_MS = 30 * 24 * 60 * 60 * 1000;
  const cutoff = now.getTime() - THIRTY_DAYS_MS;

  // Normalize and filter to last 30 days
  const recentTx = useMemo(
    () =>
      transactions
        .map((t) => {
          const d = new Date(t.date);
          if (isNaN(d)) return null;
          return { ...t, _date: d };
        })
        .filter((t) => t && t._date.getTime() >= cutoff),
    [transactions, cutoff]
  );

  const totalSpend = recentTx.reduce(
    (sum, t) => sum + (t.amount > 0 ? t.amount : 0),
    0
  );

  // 🔑 Aggregate by same category used in your visuals:
  // 1. personal_finance_category.primary (Plaid enums like GENERAL_SERVICES)
  // 2. fallback to category[0]
  // 3. else "Other"
  const categoryTotals = {};
  recentTx.forEach((t) => {
    const primary =
      t.personal_finance_category?.primary ||
      (Array.isArray(t.category) && t.category.length > 0
        ? t.category[0]
        : "Other");

    const amt = t.amount > 0 ? t.amount : 0;

    if (!categoryTotals[primary]) categoryTotals[primary] = 0;
    categoryTotals[primary] += amt;
  });

  const sortedCategories = Object.entries(categoryTotals).sort(
    (a, b) => b[1] - a[1]
  );

  const topCategory = sortedCategories[0] || null;

  // Build a small list for display (top 4 categories)
  const displayCategories = sortedCategories.slice(0, 4);

  // Simple "suggested budget" logic:
  const budgetRows = displayCategories.map(([cat, spent]) => {
    const suggested =
      Math.max(100, Math.ceil((spent * 1.25) / 25) * 25);
    const diff = suggested - spent;
    const isUnder = diff >= 0;

    return {
      category: cat,
      spent,
      budget: suggested,
      diff,
      isUnder,
    };
  });

  const formatMoney = (val) =>
    `$${val.toFixed(2).toLocaleString
      ? val.toFixed(2).toLocaleString()
      : val.toFixed(2)}`;

  return (
    <section className="card">
      <p className="card-eyebrow">SPENDING</p>
      <h2 className="card-title">Spending & budget summary</h2>
      <p className="card-description">
        Based on your last 30 days of transactions. Budgets below are simple
        suggested targets derived from your recent spending patterns.
      </p>

      {/* Top-level summary */}
      <div className="card-body-row" style={{ marginTop: 12 }}>
        <div className="card-column">
          <p className="field-label">Total spending (last 30 days)</p>
          <p className="field-value" style={{ fontSize: "20px", fontWeight: 600 }}>
            {formatMoney(totalSpend)}
          </p>
        </div>

        <div className="card-column">
          <p className="field-label">Top category</p>
          {topCategory ? (
            <>
              <p className="field-value">{topCategory[0]}</p>
              <p className="field-subvalue">
                {formatMoney(topCategory[1])} in the last 30 days
              </p>
            </>
          ) : (
            <p className="field-subvalue">Not enough data yet.</p>
          )}
        </div>
      </div>

      {/* Budget comparison table */}
      <div style={{ marginTop: 18 }}>
        <p className="field-label" style={{ marginBottom: 8 }}>
          Category budgets vs. actual
        </p>

        <table className="table">
          <thead>
            <tr>
              <th>Category</th>
              <th>Suggested budget</th>
              <th>Actual spend</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {budgetRows.map((row) => (
              <tr key={row.category}>
                <td>{row.category}</td>
                <td>{formatMoney(row.budget)}</td>
                <td>{formatMoney(row.spent)}</td>
                <td>
                  <span
                    style={{
                      padding: "2px 10px",
                      borderRadius: 999,
                      fontSize: 12,
                      fontWeight: 500,
                      backgroundColor: row.isUnder ? "#ecfdf5" : "#fef2f2",
                      color: row.isUnder ? "#059669" : "#dc2626",
                    }}
                  >
                    {row.isUnder
                      ? `Under by ${formatMoney(row.diff)}`
                      : `Over by ${formatMoney(Math.abs(row.diff))}`}
                  </span>
                </td>
              </tr>
            ))}
            {budgetRows.length === 0 && (
              <tr>
                <td colSpan={4} style={{ fontSize: 13, color: "#6b7280" }}>
                  Not enough categorized spending data to build budgets yet.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </section>
  );
}
