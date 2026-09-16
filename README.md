# Healthcare Clinic Assistant 

A production-ready, full-stack AI Healthcare Clinic Assistant built with **Python 3.11**, **Flask**, **Gunicorn**, **LangChain / LangGraph**, **Pinecone**, and **Groq**. This application functions as an intelligent medical assistant capable of handling patient inquiries, retrieving domain context via vector search, processing clinical media using OpenCV, and running securely inside a lightweight **Docker** container on port `8080`.

It includes a fully automated **GitHub Actions CI/CD pipeline** to validate Python dependencies and build the container image on every push.

## Features

* **AI Chat Assistant**: Powered by **Groq** LLMs and orchestrated using **LangChain** and **LangGraph** for structured conversation flows.

* **Vector Search / RAG**: Uses **Pinecone** vector database for fast and accurate medical retrieval-augmented generation.

* **Computer Vision Processing**: Integrated with **OpenCV** (`opencv-python-headless`) for clinical image and diagnostic media processing.

* **WSGI Production Web Server**: Powered by **Gunicorn** bound to `0.0.0.0:8080`.

* **Containerized Deployment**: Multi-stage **Docker** build using `python:3.11-slim` with optimized network timeouts (`--default-timeout=1000`) and CPU-only PyTorch support (`--extra-index-url https://download.pytorch.org/whl/cpu`).

* **Automated CI/CD**: Integrated **GitHub Actions** workflow (`.github/workflows/ci.yml`) to automatically test dependency resolution and build the Docker container in the cloud.

* **Security & Environment Controls**: Configured `.gitignore` and `.dockerignore` to keep virtual environments (`venv/`) and secrets (`.env`) out of version control.

## 🛠️ Tech Stack

| **Domain** | **Technologies** | 
| **Core & Web Framework** | Python 3.11, Flask | 
| **WSGI Server** | Gunicorn | 
| **AI Framework** | LangChain, LangGraph, Groq API | 
| **Vector Database** | Pinecone | 
| **Computer Vision** | OpenCV (`opencv-python-headless`) | 
| **Containerization** | Docker, Docker Engine | 
| **CI/CD & Source Control** | GitHub Actions, Git, GitHub | 

## 📁 Project Architecture

```
health-project/
├── .github/
│   └── workflows/
│       └── ci.yml             # GitHub Actions CI/CD workflow
├── data/                      # Medical knowledge base datasets
├── src/
│   ├── __init__.py
│   ├── agent.py              # LangGraph orchestration logic
│   ├── helper.py             # Utility functions & data transformers
│   ├── prompt.py             # System prompts & prompt templates
│   └── retriever.py          # Pinecone vector search integration
├── static/                   # CSS, JS, and image assets
├── templates/                # HTML templates for Flask UI
├── .dockerignore             # Exclusions for Docker build context
├── .env                      # Environment variables (IGNORED in Git)
├── .gitignore                # Exclusion rules for Git tracking
├── app.py                    # Flask application entry point
├── Dockerfile                # Container definition (Python 3.11, Port 8080)
├── pyproject.toml            # Project packaging metadata
├── README.md                 # Project documentation
├── requirements.txt          # Managed Python dependencies
├── setup.py                  # Local package installation configuration
└── store_index.py            # Vector embedding generator for Pinecone

```

## 🔑 Environment Variables

Create a `.env` file in the root directory prior to starting the application:

```
# Server Configuration
PORT=8080
FLASK_ENV=development

# LLM Service
GROQ_API_KEY=your_groq_api_key_here

# Vector Database
PINECONE_API_KEY=your_pinecone_api_key_here
PINECONE_INDEX_NAME=healthcare-assistant

```

> **Security Note:** Never push `.env` to GitHub. It is excluded via `.gitignore`.

## 🚀 Quick Start Guide

### Option 1: Local Virtual Environment

1. **Clone the Repository**

   ```
   git clone https://github.com/YOUR_GITHUB_USERNAME/health-project.git
   cd health-project
   
   ```

2. **Create and Activate Python 3.11 Virtual Environment**

   ```
   python3.11 -m venv venv
   source venv/bin/activate
   
   ```

3. **Install Dependencies**

   ```
   pip install --default-timeout=1000 -r requirements.txt
   
   ```

4. **Initialize Pinecone Index**

   ```
   python store_index.py
   
   ```

5. **Run Application**

   ```
   python app.py
   
   ```

   Access the app at `http://localhost:8080`.

### Option 2: Docker Container Deployment 🐳

1. **Build Docker Image**

   ```
   docker build -t health-care-chatbot .
   
   ```

2. **Run Container on Port 8080**

   ```
   docker run -d \
     -p 8080:8080 \
     --env-file .env \
     --name health-app \
     health-care-chatbot
   
   ```

3. **Verify App Health**

   ```
   curl -I http://localhost:8080
   
   ```

   *Expected Response:* `HTTP/1.1 200 OK`

4. **Check Container Logs**

   ```
   docker logs -f health-app
   
   ```

## 🔄 CI/CD Pipeline (GitHub Actions)

This project contains an automated Continuous Integration workflow configured in `.github/workflows/ci.yml`.

### Workflow Stages

1. **Trigger**: Executes on every `push` or `pull_request` to the `main` branch.

2. **Environment Setup**: Provisions an `ubuntu-latest` runner with Python 3.11.

3. **Dependency Validation**: Tests and installs all dependencies listed in `requirements.txt`.

4. **Container Build**: Executes `docker build` to confirm the application container builds successfully without timeouts or missing libraries.

## 📦 Dockerfile Reference

```
FROM python:3.11-slim

WORKDIR /app

# Copy dependency requirements
COPY requirements.txt .

# Install dependencies with extended network timeout and CPU-only PyTorch index
RUN pip install --default-timeout=1000 --no-cache-dir \
    --extra-index-url https://download.pytorch.org/whl/cpu \
    -r requirements.txt

# Copy application source code
COPY . .

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]

```

## 🛠️ Development & Deployment Workflow

To commit changes and trigger the automated CI pipeline:

```
# Check status of untracked files
git status

# Stage updated files
git add .

# Commit changes
git commit -m "Update application feature or configuration"

# Push to main branch (Triggers GitHub Actions CI)
git push origin main

```

## 📄 License

Distributed under the MIT License.