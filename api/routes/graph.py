from flask import Blueprint, jsonify
from api.utils.smc_runner import run_smc

graph_bp = Blueprint("graph", __name__)


@graph_bp.get("/api/v1/graph")
def graph():
    data, code = run_smc("graph")
    return jsonify(data), code
