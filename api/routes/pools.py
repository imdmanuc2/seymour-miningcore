from flask import Blueprint, jsonify
from api.utils.smc_runner import run_smc

pools_bp = Blueprint("pools", __name__)


@pools_bp.get("/api/v1/pools")
def pools():
    data, code = run_smc("pool", "list")
    return jsonify(data), code
