from flask import Blueprint, jsonify
from api.utils.smc_runner import smc_data

readiness_bp = Blueprint("readiness", __name__)


@readiness_bp.get("/api/v1/readiness")
def readiness():
    status_data = smc_data("status")
    health_data = smc_data("health")
    deps_data = smc_data("deps")
    install_plan_data = smc_data("install-plan")
    api_service = smc_data("service", "status", "seymour-miningcore-api")
    graph_data = smc_data("graph")
    license_data = smc_data("license", "validate")
    identity_data = smc_data("identity", "status")
    install_data = smc_data("install", "--status")
    setup_data = smc_data("setup", "status")

    deps_missing = [
        dep for dep in deps_data.get("dependencies", [])
        if dep.get("installed") is False
    ]

    graph_summary = {
        "nodeCount": len(graph_data.get("nodes", [])),
        "edgeCount": len(graph_data.get("edges", [])),
        "source": graph_data.get("source"),
        "graphVersion": graph_data.get("graphVersion")
    }

    return jsonify({
        "product": "Seymour MiningCore",
        "apiVersion": "v1",
        "ready": (
            health_data.get("overall") == "healthy"
            and len(deps_missing) == 0
        ),
        "status": status_data.get("status"),
        "health": health_data,
        "dependencies": deps_data,
        "missingDependencies": deps_missing,
        "installPlan": install_plan_data,
        "apiService": api_service,
        "graphSummary": graph_summary,
        "license": license_data,
        "identity": identity_data,
        "install": install_data,
        "setup": setup_data,
        "summary": status_data.get("summary", {}),
        "system": status_data.get("system", {}),
        "services": status_data.get("services", {}),
        "pools": status_data.get("pools", [])
    })
