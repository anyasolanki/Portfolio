export function AccountsTable({ accounts }) {
  if (!accounts || accounts.length === 0) return null

  return (
    <div className="card">
      <div className="card-header-row">
        <div>
          <p className="card-eyebrow">BALANCES</p>
          <div className="card-title">Linked accounts</div>
          <p className="card-description">
            Accounts and balances pulled from your Plaid sandbox connection.
          </p>
        </div>
      </div>

      <div className="table-wrapper">
        <table className="table">
          <thead>
            <tr>
              <th>Name</th>
              <th>Subtype</th>
              <th className="numeric">Current balance</th>
              <th className="numeric">Available</th>
            </tr>
          </thead>
          <tbody>
            {accounts.map((acct) => (
              <tr key={acct.account_id}>
                <td>{acct.name}</td>
                <td>{acct.subtype || acct.type}</td>
                <td className="numeric">
                  {acct.balances?.current != null ? `$${acct.balances.current.toFixed(2)}` : '—'}
                </td>
                <td className="numeric">
                  {acct.balances?.available != null ? `$${acct.balances.available.toFixed(2)}` : '—'}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}
