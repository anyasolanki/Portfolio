### Plaid Finance Dashboard (Plaid sandbox · Node/Express · Postgres · React)
- A full-stack personal finance dashboard that connects to Plaid’s sandbox, stores account + transaction data in Postgres, and visualizes balances, spending insights, budgets, and charts in a clean modern UI.
- Live demo: https://plaid-finance-dashboard.vercel.app/
- Backend: Node/Express on Render
- Database: Neon Postgres
- Plaid environment: Sandbox
- Fake Credentials:
  - Phone Number: 415-555-0011
  - Code: 123456
  - username: user_good
  - password: pass_good
 
### Features
- Plaid Link Integration
  - Connect a sandbox bank account and securely exchange tokens via your backend.
- Accounts Overview
  - View account balances, subtypes, and availability.
- Transaction History
  - Full transaction table populated directly from Plaid’s /transactions endpoint.
- Spending & Budget Summary
  - Auto-generated summaries for the last 30 days + category-level budget estimates.
- Analytics & Charts
  - Monthly spending line chart + category pie chart with Plaid’s finance categories.
- Clean Dashboard UI
  - Centered cards, gradient background, polished modern layout.

### Tech Stack
- Layer	Technologies
  - Frontend	React, Vite, CSS
  - Backend	Node.js, Express
  - Database	Postgres (Neon)
  - Integrations	Plaid API (sandbox)
  - Deployment	Render (backend), Netlify/Vercel (frontend)
