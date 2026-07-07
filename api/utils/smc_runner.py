import json
import subprocess
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parents[2]
SMC_BIN = ROOT_DIR / "bin" / "smc"


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
