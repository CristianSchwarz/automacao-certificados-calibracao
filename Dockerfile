
FROM public.ecr.aws/docker/library/python:3.12-slim

COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:1.1.0 /lambda-adapter /opt/extensions/lambda-adapter

WORKDIR /app

COPY requirements.txt .
RUN python -m pip install --no-cache-dir -r requirements.txt

COPY . .

ENV PORT=8080
ENV AWS_LWA_PORT=8080
ENV PYTHONUNBUFFERED=1

EXPOSE 8080

CMD ["python", "app.py"]
