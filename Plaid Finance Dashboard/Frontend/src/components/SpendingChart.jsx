import { useMemo } from 'react'
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
  Legend,
} from 'recharts'

function monthKeyFromDate(date) {
  const y = date.getFullYear()
  const m = date.getMonth() + 1
  return `${y}-${m.toString().padStart(2, '0')}` // "2025-11"
}

const COLORS = ['#4f46e5', '#06b6d4', '#22c55e', '#f59e0b', '#ec4899', '#8b5cf6', '#14b8a6']

export function SpendingCharts({ transactions }) {
  const { monthlyData, categoryData } = useMemo(() => {
    if (!transactions || transactions.length === 0) {
      return { monthlyData: [], categoryData: [] }
    }

    // Normalize transactions
    const parsed = transactions.map((tx) => {
      const d = new Date(`${tx.date}T00:00:00`)
      return {
        date: d,
        amount: typeof tx.amount === 'number' ? tx.amount : 0,
        category:
  		Array.isArray(tx.category) && tx.category.length > 0
    		? tx.category[0]
    		: tx.personal_finance_category?.primary
   		? tx.personal_finance_category.primary
    		: 'Other',

        monthKey: monthKeyFromDate(d),
      }
    })

    // Group by month
    const monthTotals = new Map()
    for (const p of parsed) {
      monthTotals.set(p.monthKey, (monthTotals.get(p.monthKey) || 0) + p.amount)
    }

    // Take last ~6 months
    const monthlyData = Array.from(monthTotals.entries())
      .sort(([a], [b]) => (a < b ? -1 : 1)) // sort ascending
      .slice(-6)
      .map(([month, total]) => ({
        month,
        total: Number(total.toFixed(2)),
      }))

    // Category totals (over entire sample window)
    const catTotals = new Map()
    for (const p of parsed) {
      catTotals.set(p.category, (catTotals.get(p.category) || 0) + p.amount)
    }

    const categoryData = Array.from(catTotals.entries())
      .map(([name, value]) => ({
        name,
        value: Number(value.toFixed(2)),
      }))
      .sort((a, b) => b.value - a.value)
      .slice(0, 8) // top 8 categories

    return { monthlyData, categoryData }
  }, [transactions])

  if (!transactions || transactions.length === 0) return null

  const hasMonthly = monthlyData.length > 0
  const hasCategories = categoryData.length > 0

  if (!hasMonthly && !hasCategories) return null

  return (
    <div className="card">
      <div className="card-header-row">
        <div>
          <p className="card-eyebrow">VISUALS</p>
          <div className="card-title">Spending charts</div>
          <p className="card-description">
            High-level trends and category breakdown based on your Plaid transaction history.
          </p>
        </div>
      </div>

      <div className="cards-grid">
        {/* Line chart: monthly totals */}
        {hasMonthly && (
          <div style={{ minHeight: 220 }}>
            <p className="card-description" style={{ marginBottom: 4 }}>
              Monthly spend (last {monthlyData.length} months)
            </p>
            <div style={{ width: '100%', height: 200 }}>
              <ResponsiveContainer>
                <LineChart data={monthlyData} margin={{ top: 10, right: 10, left: 0, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} />
                  <XAxis dataKey="month" fontSize={11} />
                  <YAxis fontSize={11} />
                  <Tooltip
                    formatter={(value) => [`$${Number(value).toFixed(2)}`, 'Total spent']}
                    labelFormatter={(label) => `Month: ${label}`}
                  />
                  <Line
                    type="monotone"
                    dataKey="total"
                    stroke="#4f46e5"
                    strokeWidth={2}
                    dot={{ r: 3 }}
                    activeDot={{ r: 5 }}
                  />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </div>
        )}

        {/* Pie chart: categories */}
        {hasCategories && (
          <div style={{ minHeight: 220 }}>
            <p className="card-description" style={{ marginBottom: 4 }}>
              Spend by category
            </p>
            <div style={{ width: '100%', height: 200 }}>
              <ResponsiveContainer>
                <PieChart>
                  <Pie
                    data={categoryData}
                    dataKey="value"
                    nameKey="name"
                    cx="50%"
                    cy="50%"
                    outerRadius={70}
                  >
                    {categoryData.map((entry, index) => (
                      <Cell
                        key={`cell-${entry.name}`}
                        fill={COLORS[index % COLORS.length]}
                      />
                    ))}
                  </Pie>
                  <Tooltip
                    formatter={(value, name) => [`$${Number(value).toFixed(2)}`, name]}
                  />
                  <Legend
                    layout="vertical"
                    align="right"
                    verticalAlign="middle"
                    wrapperStyle={{ fontSize: '0.7rem' }}
                  />
                </PieChart>
              </ResponsiveContainer>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
