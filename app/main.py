from flask import Flask, jsonify
import os
import socket

app = Flask(__name__)

APP_VERSION = "1.0.0"


@app.route("/health")
def health():
    return jsonify(status="ok"), 200


@app.route("/")
def index():
    return jsonify(
        message="Hello from the DevOps demo app!",
        version=APP_VERSION,
        hostname=socket.gethostname(),
        env=os.getenv("APP_ENV", "local"),
    )


@app.route("/api/tasks", methods=["GET"])
def list_tasks():
    tasks = [
        {"id": 1, "title": "Learn Docker", "done": False},
        {"id": 2, "title": "Set up CI/CD", "done": False},
        {"id": 3, "title": "Provision infra with Terraform", "done": False},
    ]
    return jsonify(tasks=tasks)


if __name__ == "__main__":
    port = int(os.getenv("PORT", 5000))
    app.run(host="0.0.0.0", port=port)