// src/components/AnalyticsPanel.jsx
import React from "react";

export function AnalyticsPanel({ transactions }) {
  if (!transactions || transactions.length === 0) {
    return (
      <section className="card">
        <p className="card-eyebrow">INSIGHTS</p>
        <h2 className="card-title">Spending insights</h2>
        <p className="card-description">
          Connect a bank account and refresh data to see spending analytics for
          this month.
        </p>
      </section>
    );
  }

  // Parse dates and normalize
  const now = new Date();
  const currentMonth = now.getMonth();
  const currentYear = now.getFullYear();

  const parsed = transactions
    .map((t) => {
      const d = new Date(t.date);
      if (isNaN(d)) return null;
      return { ...t, _date: d };
    })
    .filter(Boolean);

  const thisMonthTx = parsed.filter(
    (t) =>
      t._date.getMonth() === currentMonth &&
      t._date.getFullYear() === currentYear
  );

  const daysSoFar = now.getDate();
  const daysInMonth = new Date(currentYear, currentMonth + 1, 0).getDate();

  // For Plaid sandbox, amount is usually positive for spending
  const getSpend = (txList) =>
    txList.reduce((sum, t) => sum + (t.amount > 0 ? t.amount : 0), 0);

  const totalSpendMonth = getSpend(thisMonthTx);
  const avgDailySpend =
    daysSoFar > 0 ? totalSpendMonth / daysSoFar : 0;
  const projectedMonthSpend =
    avgDailySpend * daysInMonth;

  // Category breakdown (using first category as primary)
  const categoryMap = {};
  thisMonthTx.forEach((t) => {
    const primary = Array.isArray(t.category) && t.category.length > 0
      ? t.category[0]
      : "Other";
    categoryMap[primary] = (categoryMap[primary] || 0) + (t.amount > 0 ? t.amount : 0);
  });

  const categoryEntries = Object.entries(categoryMap);
  const topCategory =
    categoryEntries.length > 0
      ? categoryEntries.sort((a, b) => b[1] - a[1])[0]
      : null;

  // Largest single transaction
  const largestTx = [...thisMonthTx].sort((a, b) => b.amount - a.amount)[0];

  // Most frequent merchant by count
  const merchantCount = {};
  thisMonthTx.forEach((t) => {
    const name = t.name || "Unknown merchant";
    merchantCount[name] = (merchantCount[name] || 0) + 1;
  });

  const merchantEntries = Object.entries(merchantCount);
  const topMerchant =
    merchantEntries.length > 0
      ? merchantEntries.sort((a, b) => b[1] - a[1])[0]
      : null;

  const formatCurrency = (val) =>
    `$${val.toFixed(2).toLocaleString ? val.toFixed(2).toLocaleString() : val.toFixed(2)}`;

  const monthLabel = now.toLocaleString("default", {
    month: "long",
    year: "numeric",
  });

  return (
    <section className="card">
      <div className="card-eyebrow">Insights</div>
      <h2 className="card-title">Spending insights</h2>
      <p className="card-description" style={{ marginBottom: 14 }}>
        High-level analytics based on your {monthLabel} transactions.
      </p>

      <div className="card-body-row">
        {/* Column 1: Totals & projection */}
        <div className="card-column">
          <p className="field-label">This month’s spending</p>
          <p className="field-value" style={{ fontSize: "20px", fontWeight: 600 }}>
            {formatCurrency(totalSpendMonth)}
          </p>
          <p className="field-subvalue">
            Avg per day: {formatCurrency(avgDailySpend || 0)}
          </p>
          <p className="field-subvalue">
            Projected end-of-month:{" "}
            <strong>{formatCurrency(projectedMonthSpend || 0)}</strong>
          </p>
        </div>

        {/* Column 2: Category */}
        <div className="card-column">
          <p className="field-label">Top category</p>
          {topCategory ? (
            <>
              <p className="field-value">
                {topCategory[0]}
              </p>
              <p className="field-subvalue">
                {formatCurrency(topCategory[1])} spent in {monthLabel}
              </p>
            </>
          ) : (
            <p className="field-subvalue">Not enough data yet.</p>
          )}
        </div>

        {/* Column 3: Merchant / largest tx */}
        <div className="card-column">
          <p className="field-label">Largest transaction</p>
          {largestTx ? (
            <>
              <p className="field-value">
                {formatCurrency(largestTx.amount)} @ {largestTx.name}
              </p>
              <p className="field-subvalue">
                {largestTx._date.toLocaleDateString()}
              </p>
            </>
          ) : (
            <p className="field-subvalue">No transactions this month.</p>
          )}

          {topMerchant && (
            <p className="field-subvalue" style={{ marginTop: 8 }}>
              Most frequent merchant: <strong>{topMerchant[0]}</strong> (
              {topMerchant[1]} tx)
            </p>
          )}
        </div>
      </div>
    </section>
  );
}
