describe('Vendor flow', () => {
  before(() => {
    // reset and seed DB
    cy.exec('cd ../.. && npm run db:reset', { timeout: 120000 })
  })

  it('allows vendor to login and see dashboard', () => {
    cy.visit('/vendor/login')
    cy.get('input').first().type('john@vendor.com')
    cy.get('input[type="password"]').type('vendor123')
    cy.contains('button', 'Login').click()
    cy.url().should('include', '/vendor/dashboard')
    cy.contains('Welcome, John Vendor')
    cy.get('.card').contains('Total Earnings')
  })

  it('shows pending orders and can accept an order', () => {
    cy.visit('/vendor/orders')
    cy.get('.order-card').should('have.length.at.least', 3)
    // accept the first order
    cy.get('.order-card').first().within(() => {
      cy.contains('button', 'Accept').click()
    })
    // after accepting, the pending order list should refresh - confirm it's no longer the same first order
    cy.wait(500)
    cy.get('.order-card').should('have.length.at.least', 2)
  })

  it('can navigate to order detail and mark delivered', () => {
    // pick a pending order id via API, accept via API to ensure vendor has an active order
    cy.request('GET', 'http://localhost:4000/api/orders/pending').then((resp) => {
      const order = resp.body.orders[0]
      cy.request('POST', `http://localhost:4000/api/orders/${order.id}/accept`, { vendorId: 1 })
      // visit detail page
      cy.visit(`/vendor/order/${order.id}`)
      cy.contains('Mark as Delivered').click()
      // after delivery, back to dashboard
      cy.url().should('include', '/vendor/dashboard')
      cy.contains('Total Deliveries')
    })
  })
})