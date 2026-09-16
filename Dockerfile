FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

# Add the timeout flags directly inside the Dockerfile
RUN pip install --default-timeout=1000 --no-cache-dir \
    --extra-index-url https://download.pytorch.org/whl/cpu \
    -r requirements.txt

COPY . .

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]