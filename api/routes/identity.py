from flask import Blueprint, jsonify
from api.utils.smc_runner import run_smc

identity_bp = Blueprint("identity", __name__)


@identity_bp.get("/api/v1/identity")
def identity_show():
    data, code = run_smc("identity", "show")
    return jsonify(data), code


@identity_bp.get("/api/v1/identity/status")
def identity_status():
    data, code = run_smc("identity", "status")
    return jsonify(data), code
