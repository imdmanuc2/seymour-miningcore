from flask import Blueprint, jsonify
from api.utils.smc_runner import run_smc

status_bp = Blueprint("status", __name__)


@status_bp.get("/api/v1/status")
def status():
    data, code = run_smc("status")
    return jsonify(data), code


@status_bp.get("/api/v1/health")
def health():
    data, code = run_smc("health")
    return jsonify(data), code


@status_bp.get("/api/v1/deps")
def deps():
    data, code = run_smc("deps")
    return jsonify(data), code


@status_bp.get("/api/v1/install-plan")
def install_plan():
    data, code = run_smc("install-plan")
    return jsonify(data), code
