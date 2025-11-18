# Docker instructions for Emotion-based-art-generator

## Files added
- `Dockerfile` — production-ready image for the Flask backend (uses Gunicorn).
- `docker-compose.yml` — builds the image, mounts `./instance` so the SQLite DB persists, and exposes port 5000.
- `.dockerignore` — reduces build context and keeps the image smaller.

## Where to place these files
Yes — put `Dockerfile`, `docker-compose.yml`, and `.dockerignore` at the **project root** (the same folder that contains `app.py` and `requirements.txt`). That allows Docker to see all files it needs during build while excluding ignored files.

## Build & run
From the project root (where these files are placed), run:

```bash
docker-compose up --build
```

The backend will be available at `http://localhost:5000`.

## Notes & tips
- The image will be large if `requirements.txt` includes `torch` and `transformers`. If you don't need GPU support, prefer CPU-only torch wheels to reduce size.
- For GPU support, you'll need a CUDA base image and to run `docker run --gpus all ...` (ask me and I'll make a GPU Dockerfile).
- The SQLite DB `instance/users.db` is mounted so it will persist on the host.
- If you want the final image smaller, I can provide a multi-stage build or pin specific wheels; tell me if you want that.
