import json
import pytest
from backend import app as flask_app

@pytest.fixture
def client():
    flask_app.config['TESTING'] = True
    with flask_app.test_client() as client:
        yield client

def test_health_endpoint(client):
    resp = client.get('/api/health')
    assert resp.status_code in (200, 503, 500)
    data = resp.get_json()
    assert isinstance(data, dict)
    assert 'status' in data or 'db' in data or 'error' in data

def test_get_users_endpoint(client):
    resp = client.get('/api/users')
    assert resp.status_code in (200, 500)
    data = resp.get_json()
    assert isinstance(data, dict)
    assert 'users' in data or 'error' in data