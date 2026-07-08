#!/usr/bin/env python3
from flask import Flask, jsonify

from api.config import API_VERSION, PRODUCT_NAME, READ_ONLY_MODE
from api.middleware.security import register_security
from api.routes.status import status_bp
from api.routes.pools import pools_bp
from api.routes.graph import graph_bp
from api.routes.services import services_bp
from api.routes.readiness import readiness_bp
from api.routes.license import license_bp
from api.routes.install import install_bp


def create_app():
    app = Flask(__name__)
    register_security(app)

    app.register_blueprint(status_bp)
    app.register_blueprint(pools_bp)
    app.register_blueprint(graph_bp)
    app.register_blueprint(services_bp)
    app.register_blueprint(readiness_bp)
    app.register_blueprint(license_bp)
    app.register_blueprint(install_bp)

    @app.errorhandler(404)
    def not_found(error):
        return jsonify({
            "success": False,
            "error": "Not Found",
            "message": "Endpoint not found."
        }), 404

    @app.errorhandler(500)
    def server_error(error):
        return jsonify({
            "success": False,
            "error": "Internal Server Error",
            "message": "Unexpected API failure."
        }), 500

    @app.get("/")
    def root():
        return jsonify({
            "product": PRODUCT_NAME,
            "apiVersion": API_VERSION,
            "status": "running",
            "readOnlyMode": READ_ONLY_MODE,
            "endpoints": [
                "/api/v1/status",
                "/api/v1/health",
                "/api/v1/deps",
                "/api/v1/install-plan",
                "/api/v1/pools",
                "/api/v1/graph",
                "/api/v1/services",
                "/api/v1/services/<service_name>",
                "/api/v1/readiness",
                "/api/v1/version",
                "/api/v1/live",
                "/api/v1/license","/api/v1/install",
                "/api/v1/install/status",
                "/api/v1/install/plan"
            ]
        })

    @app.get("/api/v1/live")
    def live():
        return jsonify({
            "product": PRODUCT_NAME,
            "apiVersion": API_VERSION,
            "live": True
        })

    @app.get("/api/v1/version")
    def version():
        return jsonify({
            "product": "Seymour MiningCore",
            "api": API_VERSION,
            "versionCommand": "smc version"
        })

    return app


app = create_app()


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=8560)
