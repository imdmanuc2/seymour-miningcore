from flask import Blueprint, jsonify
from api.utils.smc_runner import run_smc

services_bp = Blueprint("services", __name__)


@services_bp.get("/api/v1/services")
def services():
    miningcore, _ = run_smc("service", "status", "seymour-miningcore")
    api, _ = run_smc("service", "status", "seymour-miningcore-api")

    return jsonify({
        "services": [
            miningcore,
            api
        ]
    }), 200


@services_bp.get("/api/v1/services/<service_name>")
def service_status(service_name):
    data, code = run_smc("service", "status", service_name)
    return jsonify(data), code
