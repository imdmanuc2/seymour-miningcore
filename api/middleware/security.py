import time
import uuid
from flask import g, request, jsonify
from api.config import API_TOKEN


def register_security(app):
    @app.before_request
    def before_request():
        g.request_id = str(uuid.uuid4())
        g.start_time = time.time()

    @app.after_request
    def after_request(response):
        duration_ms = round((time.time() - g.start_time) * 1000, 2)

        response.headers["X-Request-ID"] = g.request_id
        response.headers["X-Response-Time-ms"] = str(duration_ms)
        response.headers["X-Content-Type-Options"] = "nosniff"
        response.headers["X-Frame-Options"] = "DENY"
        response.headers["Referrer-Policy"] = "no-referrer"

        return response


def require_api_token():
    if not API_TOKEN:
        return None

    auth_header = request.headers.get("Authorization", "")

    if auth_header != f"Bearer {API_TOKEN}":
        return jsonify({
            "success": False,
            "error": "Unauthorized",
            "message": "Valid API token required."
        }), 401

    return None
