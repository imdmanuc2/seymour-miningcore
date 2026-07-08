from flask import Blueprint, jsonify
from api.utils.smc_runner import run_smc

setup_bp = Blueprint("setup", __name__)


@setup_bp.get("/api/v1/setup")
def setup():
    data, code = run_smc("setup", "status")
    return jsonify(data), code


@setup_bp.get("/api/v1/setup/status")
def setup_status():
    data, code = run_smc("setup", "status")
    return jsonify(data), code
