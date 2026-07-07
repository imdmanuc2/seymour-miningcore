cd ~/seymour-miningcore

cat > api/app.py <<'EOF'
#!/usr/bin/env python3
import json
import subprocess
from pathlib import Path
from flask import Flask, jsonify

ROOT_DIR = Path(__file__).resolve().parents[1]
SMC_BIN = ROOT_DIR / "bin" / "smc"

app = Flask(__name__)


def run_smc(*args):
    try:
        result = subprocess.run(
            [str(SMC_BIN), *args],
            cwd=str(ROOT_DIR),
            capture_output=True,
            text=True,
            check=True,
            timeout=15,
        )

        output = result.stdout.strip()

        if not output:
            return {"success": False, "error": "SMC returned empty output"}, 500

        return json.loads(output), 200

    except subprocess.CalledProcessError as exc:
        return {
            "success": False,
            "error": "SMC command failed",
            "command": ["smc", *args],
            "stdout": exc.stdout,
            "stderr": exc.stderr,
            "returncode": exc.returncode,
        }, 500

    except json.JSONDecodeError as exc:
        return {
            "success": False,
            "error": "SMC returned invalid JSON",
            "command": ["smc", *args],
            "details": str(exc),
        }, 500

    except Exception as exc:
        return {
            "success": False,
            "error": "API wrapper failed",
            "command": ["smc", *args],
            "details": str(exc),
        }, 500


def smc_data(*args):
    data, _ = run_smc(*args)
    return data


@app.get("/")
def root():
    return jsonify({
        "product": "Seymour MiningCore API",
        "apiVersion": "v1",
        "status": "running",
        "endpoints": [
            "/api/v1/status",
            "/api/v1/health",
            "/api/v1/pools",
            "/api/v1/graph",
            "/api/v1/version",
            "/api/v1/services",
            "/api/v1/services/<service_name>",
            "/api/v1/deps",
            "/api/v1/install-plan",
            "/api/v1/readiness"
        ]
    })


@app.get("/api/v1/status")
def status():
    data, code = run_smc("status")
    return jsonify(data), code


@app.get("/api/v1/health")
def health():
    data, code = run_smc("health")
    return jsonify(data), code


@app.get("/api/v1/deps")
def deps():
    data, code = run_smc("deps")
    return jsonify(data), code


@app.get("/api/v1/install-plan")
def install_plan():
    data, code = run_smc("install-plan")
    return jsonify(data), code


@app.get("/api/v1/readiness")
def readiness():
    status_data = smc_data("status")
    health_data = smc_data("health")
    deps_data = smc_data("deps")
    install_plan_data = smc_data("install-plan")
    api_service = smc_data("service", "status", "seymour-miningcore-api")
    graph_data = smc_data("graph")

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
        "summary": status_data.get("summary", {}),
        "system": status_data.get("system", {}),
        "services": status_data.get("services", {}),
        "pools": status_data.get("pools", [])
    })


@app.get("/api/v1/services")
def services():
    miningcore, _ = run_smc("service", "status", "seymour-miningcore")
    api, _ = run_smc("service", "status", "seymour-miningcore-api")

    return jsonify({
        "services": [
            miningcore,
            api
        ]
    }), 200


@app.get("/api/v1/services/<service_name>")
def service_status(service_name):
    data, code = run_smc("service", "status", service_name)
    return jsonify(data), code


@app.get("/api/v1/pools")
def pools():
    data, code = run_smc("pool", "list")
    return jsonify(data), code


@app.get("/api/v1/graph")
def graph():
    data, code = run_smc("graph")
    return jsonify(data), code


@app.get("/api/v1/version")
def version():
    return jsonify({
        "product": "Seymour MiningCore",
        "api": "v1",
        "versionCommand": "smc version"
    })


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=8560)
EOF