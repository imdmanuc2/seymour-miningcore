from flask import Blueprint, jsonify
from api.utils.smc_runner import run_smc

install_bp = Blueprint("install", __name__)


@install_bp.get("/api/v1/install")
def install():

    plan, _ = run_smc("install", "--plan")
    status, _ = run_smc("install", "--status")

    return jsonify({
        "product": "Seymour MiningCore",
        "apiVersion": "v1",
        "plan": plan,
        "status": status
    })


@install_bp.get("/api/v1/install/plan")
def install_plan():
    data, code = run_smc("install", "--plan")
    return jsonify(data), code


@install_bp.get("/api/v1/install/status")
def install_status():
    data, code = run_smc("install", "--status")
    return jsonify(data), code