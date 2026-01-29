// Vendor Order Detail JS
function getParam(name) {
  const params = new URLSearchParams(window.location.search);
  return params.get(name);
}

document.addEventListener('DOMContentLoaded', async () => {
  const user = getCurrentUser();
  if (!user || user.userType !== 'vendor') { window.location.href = 'login.html?type=vendor'; return; }
  document.getElementById('userName').textContent = user.name;

  const orderId = getParam('orderId');
  if (!orderId) { alert('Order id missing'); return; }

  try {
    const res = await fetch('/api/orders/' + encodeURIComponent(orderId));
    const data = await res.json();
    if (!res.ok) { alert(data.error || 'Order not found'); return; }
    const o = data.order;
    document.getElementById('orderTitle').textContent = `Order ${o.id}`;
    document.getElementById('orderInfo').innerHTML = `
      <p><b>Client:</b> ${escapeHtml(o.client_name)} - ${escapeHtml(o.client_phone)}</p>
      <p><b>Address:</b> ${escapeHtml(o.delivery_address)}</p>
      <p><b>Type:</b> ${escapeHtml(o.order_type)}</p>
      <p><b>Quantity:</b> ${o.quantity}</p>
      <p><b>Price:</b> ₹${o.price} (You: ₹${o.vendor_earnings})</p>
    `;

    // init map
    if (window.google) {
      const map = new window.google.maps.Map(document.getElementById('map'), { center: { lat: o.delivery_lat || 37.7749, lng: o.delivery_lng || -122.4194 }, zoom: 13 });
      const marker = new window.google.maps.Marker({ position: { lat: o.delivery_lat, lng: o.delivery_lng }, map });
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition((pos) => {
          const origin = { lat: pos.coords.latitude, lng: pos.coords.longitude };
          const directionsService = new window.google.maps.DirectionsService();
          const directionsRenderer = new window.google.maps.DirectionsRenderer();
          directionsRenderer.setMap(map);
          directionsService.route({ origin, destination: { lat: o.delivery_lat, lng: o.delivery_lng }, travelMode: window.google.maps.TravelMode.DRIVING }, (resp, status) => { if (status === 'OK') directionsRenderer.setDirections(resp); });
        });
      }
    }

    document.getElementById('deliverBtn').addEventListener('click', async () => {
      const vendorProfileId = user.vendorProfileId || user.vendor_profile_id || user.userId || user.id;
      const res2 = await fetch('/api/orders/' + orderId + '/assign', { method: 'POST', headers: {'Content-Type':'application/json'}, body: JSON.stringify({ vendor_profile_id: vendorProfileId }) });
      // After assign, call complete
      await fetch('/api/orders/' + orderId + '/complete', { method: 'POST', headers: {'Content-Type':'application/json'}, body: JSON.stringify({ vendor_profile_id: vendorProfileId }) });
      alert('Order marked as delivered');
      window.location.href = 'vendor-dashboard.html';
    });
  } catch (err) { console.error(err); }
});

function escapeHtml(s) { return s ? s.replace(/[&<"']/g, function(m) { return ({'&':'&amp;','<':'&lt;','"':'&quot;','\'':'&#39;'}[m]); }) : ''; }