FROM python:3.10

WORKDIR /app

COPY . .

# Avoid buffering (important for Jenkins logs)
ENV PYTHONUNBUFFERED=1

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Ensure Python can find your app
ENV PYTHONPATH=/app

# Run tests in verbose mode
CMD ["pytest", "-v"]
