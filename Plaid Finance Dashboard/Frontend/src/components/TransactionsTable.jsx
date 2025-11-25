export function TransactionsTable({ transactions, txLoaded }) {
  if (!txLoaded || !transactions || transactions.length === 0) return null

  return (
    <div className="card">
      <div className="card-header-row">
        <div>
          <p className="card-eyebrow">ACTIVITY</p>
          <div className="card-title">Recent transactions</div>
          <p className="card-description">
            Raw transaction history from your Plaid sandbox institution (last ~year).
          </p>
        </div>
      </div>

      <div className="table-wrapper">
        <table className="table">
          <thead>
            <tr>
              <th>Date</th>
              <th>Name</th>
              <th>Category</th>
              <th className="numeric">Amount</th>
            </tr>
          </thead>
          <tbody>
            {transactions.map((tx) => (
              <tr key={tx.transaction_id}>
                <td>{tx.date}</td>
                <td>{tx.name}</td>
                <td>{tx.category ? tx.category.join(' > ') : '—'}</td>
                <td className="numeric">
                  {tx.amount != null ? `$${tx.amount.toFixed(2)}` : '—'}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}
