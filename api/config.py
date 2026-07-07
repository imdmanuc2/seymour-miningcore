import os

API_VERSION = "v1"
PRODUCT_NAME = "Seymour MiningCore API"

API_TOKEN = os.getenv("SMC_API_TOKEN", "")
READ_ONLY_MODE = os.getenv("SMC_READ_ONLY_MODE", "true").lower() == "true"
