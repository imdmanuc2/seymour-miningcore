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
            "/api/v1/install-plan"
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


@app.get("/api/v1/services")
def services():
    miningcore, code1 = run_smc("service", "status", "seymour-miningcore")
    api, code2 = run_smc("service", "status", "seymour-miningcore-api")

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
