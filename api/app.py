#!/usr/bin/env python3
from flask import Flask, jsonify

from api.routes.status import status_bp
from api.routes.pools import pools_bp
from api.routes.graph import graph_bp
from api.routes.services import services_bp
from api.routes.readiness import readiness_bp


def create_app():
    app = Flask(__name__)

    app.register_blueprint(status_bp)
    app.register_blueprint(pools_bp)
    app.register_blueprint(graph_bp)
    app.register_blueprint(services_bp)
    app.register_blueprint(readiness_bp)

    @app.get("/")
    def root():
        return jsonify({
            "product": "Seymour MiningCore API",
            "apiVersion": "v1",
            "status": "running",
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
                "/api/v1/version"
            ]
        })

    @app.get("/api/v1/version")
    def version():
        return jsonify({
            "product": "Seymour MiningCore",
            "api": "v1",
            "versionCommand": "smc version"
        })

    return app


app = create_app()


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=8560)
