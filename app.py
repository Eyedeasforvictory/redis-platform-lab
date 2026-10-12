from fastapi import FastAPI, HTTPException
import os
import redis
from redis.exceptions import RedisError

app = FastAPI(title="Redis Platform API")

client = redis.Redis(
    host=os.getenv("REDIS_HOST", "localhost"),
    port=int(os.getenv("REDIS_PORT", "6379")),
    password=os.getenv("REDIS_PASSWORD") or None,
    decode_responses=True,
    socket_connect_timeout=2,
)

@app.get("/")
def root():
    return {"message": "FastAPI is working"}

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/ready")
def ready():
    try:
        client.ping()
        return {"status": "ready", "redis": "connected"}
    except RedisError:
        raise HTTPException(status_code=503, detail="Redis unavailable")

@app.post("/cache")
def store_value(key: str, value: str):
    try:
        client.set(key, value)
        return {"message": f"Stored key '{key}'"}
    except RedisError:
        raise HTTPException(status_code=503, detail="Redis unavailable")

@app.get("/cache")
def get_value(key: str):
    try:
        value = client.get(key)
    except RedisError:
        raise HTTPException(status_code=503, detail="Redis unavailable")

    if value is None:
        raise HTTPException(status_code=404, detail="Key not found")

    return {"key": key, "value": value}
