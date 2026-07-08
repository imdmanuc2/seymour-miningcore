from flask import Blueprint, jsonify
from api.utils.smc_runner import run_smc

license_bp = Blueprint("license", __name__)


@license_bp.get("/api/v1/license")
def license_status():
    data, code = run_smc("license", "status")
    return jsonify(data), code


@license_bp.get("/api/v1/license/validate")
def license_validate():
    data, code = run_smc("license", "validate")
    return jsonify(data), code
