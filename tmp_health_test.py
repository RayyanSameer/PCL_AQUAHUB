import importlib
m = importlib.import_module("backend.app")
app = m.app
with app.test_client() as c:
    r = c.get("/api/health")
    print("status", r.status_code)
    print("json", r.get_json())
