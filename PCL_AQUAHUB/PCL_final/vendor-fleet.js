// Vendor Fleet Management JS
document.addEventListener('DOMContentLoaded', () => {
  // require vendor login
  const user = getCurrentUser();
  if (!user || user.userType !== 'vendor') {
    window.location.href = 'login.html?type=vendor';
    return;
  }
  document.getElementById('userName').textContent = user.name;
  // vendor_profile_id stored in user.vendorProfileId when logged in via vendor login
  // support both demo and real vendor
  const vendorProfileId = user.vendorProfileId || user.vendor_profile_id || user.userId || user.id;
  window.vendorProfileId = vendorProfileId;
  loadFleet(vendorProfileId);
});

async function loadFleet(vendorId) {
  try {
    const res = await fetch('/api/vendor/' + vendorId + '/fleet');
    const data = await res.json();
    if (res.ok) {
      document.getElementById('truckCount').textContent = data.truck_count;
      document.getElementById('ordersInQueue').textContent = data.orders_in_queue;
      renderTrucks(data.trucks || []);
    } else {
      alert(data.error || 'Failed to load fleet');
    }
  } catch (err) {
    console.error(err);
  }
}

function renderTrucks(trucks) {
  const container = document.getElementById('trucksContainer');
  container.innerHTML = '';
  if (!trucks.length) {
    container.innerHTML = '<p>No trucks added yet. Add your first truck.</p>';
    return;
  }
  trucks.forEach(t => {
    const div = document.createElement('div');
    div.className = 'truck-card';
    div.innerHTML = `
      <h4>${escapeHtml(t.truck_name || 'Unnamed')}</h4>
      <p><strong>Capacity:</strong> ${t.capacity_liters || 0} L</p>
      <p><strong>Dispatched:</strong> ${t.is_dispatched ? 'Yes' : 'No'}</p>
      <p><strong>Earnings:</strong> ₹${t.total_earnings || 0}</p>
      <div class="card-actions">
        <button onclick="editTruck('${t.id}')" class="action-btn">Edit</button>
        <button onclick="deleteTruck('${t.id}')" class="action-btn danger">Delete</button>
      </div>
    `;
    container.appendChild(div);
  });
}

function showAddTruckForm() {
  document.getElementById('truckModalTitle').textContent = 'Add Truck';
  document.getElementById('truckForm').reset();
  document.getElementById('truckId').value = '';
  document.getElementById('truckModal').style.display = 'block';
}

function closeTruckModal() {
  document.getElementById('truckModal').style.display = 'none';
}

async function editTruck(truckId) {
  try {
    const res = await fetch('/api/trucks/' + truckId);
    const data = await res.json();
    if (!res.ok) { alert(data.error || 'Failed'); return; }
    document.getElementById('truckModalTitle').textContent = 'Edit Truck';
    document.getElementById('truckId').value = data.truck.id;
    document.getElementById('truckName').value = data.truck.truck_name;
    document.getElementById('truckCapacity').value = data.truck.capacity_liters;
    document.getElementById('truckDispatched').value = data.truck.is_dispatched ? 'true' : 'false';
    document.getElementById('truckModal').style.display = 'block';
  } catch (err) {
    console.error(err);
  }
}

document.getElementById && document.getElementById('truckForm') && document.getElementById('truckForm').addEventListener('submit', async function (e) {
  e.preventDefault();
  const id = document.getElementById('truckId').value;
  const name = document.getElementById('truckName').value;
  const capacity = parseInt(document.getElementById('truckCapacity').value, 10);
  const isDispatched = document.getElementById('truckDispatched').value === 'true';
  try {
    if (!id) {
      // create
      const res = await fetch('/api/vendor/' + window.vendorProfileId + '/trucks', {
        method: 'POST', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ truck_name: name, capacity_liters: capacity })
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed');
    } else {
      const res = await fetch('/api/trucks/' + id, {
        method: 'PUT', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ truck_name: name, capacity_liters: capacity, is_dispatched: isDispatched })
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed');
    }
    closeTruckModal();
    loadFleet(window.vendorProfileId);
  } catch (err) {
    alert(err.message || 'Error saving truck');
  }
});

async function deleteTruck(truckId) {
  if (!confirm('Delete this truck?')) return;
  try {
    const res = await fetch('/api/trucks/' + truckId, { method: 'DELETE' });
    const data = await res.json();
    if (!res.ok) throw new Error(data.error || 'Failed');
    loadFleet(window.vendorProfileId);
  } catch (err) {
    alert(err.message || 'Error deleting');
  }
}

function escapeHtml(unsafe) {
  return unsafe ? unsafe.replace(/[&<"']/g, function (m) { return ({'&':'&amp;','<':'&lt;','"':'&quot;','\'':'&#39;'}[m]); }) : '';
}