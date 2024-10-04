FROM python:3.12-alpine

# Set the working directory in the container
WORKDIR /app

COPY webapp.py requirements.txt /app

RUN pip install --no-cache-dir -r requirements.txt

# Make port 8001 available to the world outside this container
EXPOSE 8001

CMD ["python3", "/app/webapp.py"]
