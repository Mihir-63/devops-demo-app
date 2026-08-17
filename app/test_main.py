from main import app


def get_client():
    app.testing = True
    return app.test_client()


def test_health():
    client = get_client()
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.get_json()["status"] == "ok"


def test_index():
    client = get_client()
    resp = client.get("/")
    data = resp.get_json()
    assert resp.status_code == 200
    assert "message" in data
    assert "version" in data


def test_tasks():
    client = get_client()
    resp = client.get("/api/tasks")
    data = resp.get_json()
    assert resp.status_code == 200
    assert len(data["tasks"]) == 3