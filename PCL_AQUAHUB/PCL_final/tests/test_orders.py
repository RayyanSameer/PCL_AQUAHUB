import json
from backend.app import app


def test_get_order_not_found():
    client = app.test_client()
    resp = client.get('/api/orders/00000000-0000-0000-0000-000000000000')
    assert resp.status_code == 404
    data = json.loads(resp.get_data(as_text=True))
    assert 'error' in data


def test_complete_order_not_found():
    client = app.test_client()
    resp = client.post('/api/orders/00000000-0000-0000-0000-000000000000/complete', json={'vendor_profile_id': '00000000-0000-0000-0000-000000000000'})
    assert resp.status_code == 404
    data = json.loads(resp.get_data(as_text=True))
    assert 'error' in data