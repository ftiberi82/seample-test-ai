# Dockerfile
FROM 10.40.3.46:5000/ubuntu:1.0
RUN echo "hello world"
CMD ["bash", "-c", "echo container ready"]
