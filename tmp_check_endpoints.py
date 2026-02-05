import importlib
m = importlib.import_module("backend.app")
app = m.app
with app.test_client() as c:
    r1 = c.get("/api/health")
    print("health status", r1.status_code, r1.get_json())
    r2 = c.get("/api/users")
    print("users status", r2.status_code)
    print("users json keys", list(r2.get_json().keys()) if r2.get_json() else None)
