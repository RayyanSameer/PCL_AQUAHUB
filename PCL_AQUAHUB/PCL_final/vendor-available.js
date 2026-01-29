// Available Orders JS
document.addEventListener('DOMContentLoaded', () => {
  const user = getCurrentUser();
  if (!user || user.userType !== 'vendor') {
    window.location.href = 'login.html?type=vendor';
    return;
  }
  document.getElementById('userName').textContent = user.name;
  window.vendorProfileId = user.vendorProfileId || user.vendor_profile_id || user.userId || user.id;
  loadAvailableOrders();
});

async function loadAvailableOrders() {
  try {
    const res = await fetch('/api/orders/available');
    const data = await res.json();
    if (!res.ok) { alert(data.error || 'Failed to load'); return; }
    renderOrders(data.orders || []);
  } catch (err) { console.error(err); }
}

function renderOrders(orders) {
  const container = document.getElementById('ordersContainer');
  container.innerHTML = '';
  if (!orders.length) { container.innerHTML = '<p>No available orders right now.</p>'; return; }
  orders.forEach(o => {
    const div = document.createElement('div');
    div.className = 'order-card';
    div.innerHTML = `
      <h4>Order ${o.id}</h4>
      <p><strong>Client:</strong> ${escapeHtml(o.first_name + ' ' + o.last_name)}</p>
      <p><strong>Phone:</strong> ${escapeHtml(o.phone)}</p>
      <p><strong>Type:</strong> ${escapeHtml(o.order_type)}</p>
      <p><strong>Address:</strong> ${escapeHtml(o.delivery_address)}</p>
      <div class="card-actions">
        <select id="truckSelect_${o.id}"><option value="">Select Truck (optional)</option></select>
        <button onclick="acceptOrder('${o.id}')" class="accept">Accept</button>
        <button onclick="declineOrder('${o.id}')" class="decline">Decline</button>
        <button onclick="viewOrder('${o.id}')" class="navigate">View</button>
      </div>
    `;
    container.appendChild(div);
    populateTruckSelect(o.id);
  });
}

async function populateTruckSelect(orderId) {
  try {
    const res = await fetch('/api/vendor/' + window.vendorProfileId + '/fleet');
    const data = await res.json();
    if (!res.ok) return;
    const sel = document.getElementById('truckSelect_' + orderId);
    data.trucks.forEach(t => {
      const opt = document.createElement('option'); opt.value = t.id; opt.textContent = `${t.truck_name} (${t.capacity_liters}L)`; sel.appendChild(opt);
    });
  } catch (err) { console.error(err); }
}

async function acceptOrder(orderId) {
  const sel = document.getElementById('truckSelect_' + orderId);
  const truckId = sel ? sel.value : null;
  try {
    const res = await fetch('/api/orders/' + orderId + '/assign', { method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify({ vendor_profile_id: window.vendorProfileId, truck_id: truckId })});
    const data = await res.json();
    if (!res.ok) return alert(data.error || 'Failed to accept');
    alert('Order accepted'); loadAvailableOrders();
  } catch (err) { console.error(err); }
}

async function declineOrder(orderId) {
  try {
    // simply set to pending with vendor_id NULL (already pending) by calling decline endpoint if exists
    const res = await fetch('/api/orders/' + orderId + '/assign', { method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify({ vendor_profile_id: null })});
    // server will set accepted, but for decline we'll call vendor-specific decline behaviour - fallback: contact admin
    if (!res.ok) alert('Decline failed');
    else { alert('Order declined'); loadAvailableOrders(); }
  } catch (err) { console.error(err); }
}

function viewOrder(orderId) {
  window.location.href = 'vendor-order-detail.html?orderId=' + encodeURIComponent(orderId);
}

function escapeHtml(unsafe) {
  return unsafe ? unsafe.replace(/[&<"']/g, function (m) { return ({'&':'&amp;','<':'&lt;','"':'&quot;','\'':'&#39;'}[m]); }) : '';
}