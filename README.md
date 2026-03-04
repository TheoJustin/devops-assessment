# Local DevOps Infrastructure & Deployment Pipeline

This repository contains the configuration, infrastructure as code, and CI/CD pipelines for a complete, single-node DevOps environment. It simulates a production-grade distributed system locally using **HashiCorp Nomad**, **Consul**, **Docker**, and a modern **LGTM** observability stack.

---

## 📚 Prerequisites & Concepts to Master

Before executing the deployment phases, ensure a solid understanding of the following core concepts:

### ✅ Containerization (Docker)
* **Build:** `docker build -t sentinel-worker:v1.0 .`
* **Registry:** `docker login`
* **Run:** `docker run -d --name my-running-worker sentinel-worker:v1.0`
* **Logs:** `docker logs -f my-running-worker`
* **Stop:** `docker stop my-running-worker`
* **Destroy:** `docker rm my-running-worker`

### ✅ Orchestration (Nomad)
Similar to Kubernetes but lightweight and versatile. While K8s provides a massive ecosystem, Nomad focuses strictly on **scheduling** tasks (containers, VMs, or binaries), leaving service networking to Consul. It offers a simpler learning curve and is highly efficient.

### ✅ Service Discovery & Networking (Consul)
Acts as a dynamic load balancer/service registry. Unlike traditional static balancers (Nginx, HAProxy, F5), Consul is **self-configuring**. When a new service instance spins up, it automatically registers itself without human intervention.

### ✅ CI/CD (GitHub Actions)
* **Continuous Integration (CI):** The "Quality Control." Automated runners build, test, and lint code. If errors occur, the build fails before reaching production.
* **Continuous Deployment (CD):** The "Delivery." Automates the release, deployment, and updating of images. It simplifies the entire workflow into a single `git push`.

### ✅ Observability (LGTM Stack)

* **Prometheus:** **The "Numbers" (Metrics).** Monitors request counts, CPU/GPU usage, and memory.
* **Loki:** **The "Text" (Logs).** Ingests logs via Promtail to explain the "How" behind an anomaly seen in the metrics.
* **Tempo:** **The "Waterfall" (Traces).** Traces the lifecycle of a request to pinpoint exactly where a process was interrupted or delayed.
* **Grafana:** **The "Dashboard" (Visualization).** Provides a unified UI to visualize metrics and logs, allowing for rapid identification of "red" (failed) states.

---

## 🚀 Execution Roadmap

### Phase 1: Infrastructure Initialization ✅
*Goal: Provision the underlying server and establish the Nomad/Consul control plane.*

- [x] **Provision Environment:** Set up on macOS (local).
- [x] **Install Docker Engine:** Docker Desktop for Mac installed and running.
- [x] **Install Binaries:**
  brew tap hashicorp/tap
  brew install hashicorp/tap/nomad hashicorp/tap/consul
  nomad -version
  consul -version
- [x] Consul Configuration: Created consul.hcl and initialized:
consul agent -config-file=consul.hcl
- [x] Nomad Configuration: Created nomad.hcl (linked to Consul) and initialized:
sudo nomad agent -config=nomad.hcl
- [x] Verify Access: Confirmed UIs at localhost:8500 (Consul) and localhost:4646 (Nomad).


### Phase 2: Application Orchestration (Task 2) ✅
*Goal: Automate the deployment of a containerized backend service.*

* [x] **Repository Setup:** Fork/Clone the provided backend repository to the GitHub account.
* [x] **Job Specification:** Write a `.nomad` job specification file defining the Docker image, CPU/Memory limits, and Consul service registration details.
* [x] **CI/CD Runner:** Set up a GitHub Actions Self-Hosted Runner on the local machine.
* [x] **Pipeline Creation:** Write the `.github/workflows/deploy.yml` pipeline to build the Docker image and trigger the `nomad run` command.
* [x] **Deployment:** Push code to trigger the pipeline and verify the app appears in the Nomad UI.

**📝 Key Learnings & Debugging Notes:**
* **Environment Prerequisites:** Ensure both Nomad and Consul are actively running in the background on the local machine before triggering deployments. *Note: Admin privileges (`sudo`) are often required when starting the Nomad agent.*
* **CI/CD Pipeline Secrets:** GitHub Actions requires repository secrets to be configured (e.g., Docker credentials) so the runner can successfully log in and push images to your registry.
* **Pipeline Troubleshooting:** When debugging failed deployments, the **Actions** tab in the GitHub repository is the best place to trace workflow step errors.
* **Essential Nomad CLI Commands:**
    * Check job status: `nomad job status <job-name>` *(e.g., hubspot-backend)*
    * Check allocation status: `nomad alloc status <alloc-id>`
    * View container logs: `nomad alloc logs <alloc-id>`
    * Check for port mismatch (from Dockerfile.staging to the nomad file)

### Phase 3: The Observability Stack (Task 3) ✅
*Goal: Implement metrics, logging, and visualization for the cluster.*
[x] Write a Nomad job spec for Prometheus. Configure prometheus.yml to use Consul service discovery to automatically find the backend app and the Nomad/Consul agents.
[x] Write a Nomad job spec for Grafana. Log into the UI, connect Prometheus as a data source, and import a Node Exporter dashboard (Template 1860).
[x] Write a Nomad job spec for Loki and Promtail (the agent that ships logs to Loki). Configure it to read the backend Docker container logs.
[x] GitOps Automation: Create a dedicated infrastructure pipeline (observability.yml) to automatically deploy .nomad.hcl files upon push.
**📝 Key Learnings & Mitigation Strategies:**
* **Infrastructure Pipeline vs. App Pipeline:** Observability tools (Layer 1) should be deployed via their own GitOps pipeline triggered exclusively by changes to .nomad.hcl files, separating them from application code (Layer 2) updates.
* **Mac/Docker Networking (host.docker.internal):** Docker on Mac runs in a lightweight VM. For a container (like Prometheus) to reach a service running natively on the Mac (like Consul), you must use the special DNS name host.docker.internal rather than localhost.
* **Nomad Host Volumes:** By default, Nomad disables mounting host directories for security. To allow Promtail to read Docker logs, you must explicitly enable volumes in your Nomad agent config:
`
plugin "docker" {
  config {
    volumes {
      enabled = true
    }
  }
}
`
* **The Root Privileges Trap (sudo):** Running Nomad with sudo forces temporary task directories (in /private/tmp) to be owned by root. Since Docker Desktop on Mac runs as a standard user, it will be denied permission to mount these directories. Mitigation: Run the Nomad agent as a standard user (nomad agent -dev) unless binding to protected ports (<1024).
* **Ghost Processes:** If a sudo Nomad agent is interrupted incorrectly, it may leave a "ghost" process running in the background, locking up port 4647. Mitigation: Use sudo killall nomad to force-terminate lingering instances before restarting the agent.

### Phase 4: Chaos & Resolution (Task 4)
*Goal: Troubleshoot and resolve a simulated production outage.*

- [ ] Deploy the provided "broken" `.nomad` file.
- [ ] Use the Nomad UI, `nomad alloc status`, and the newly set up Loki logs to trace the failure (e.g., Out-of-memory error? Failed Consul health check? Bad Docker image tag?).
- [ ] Apply the fix, redeploy, and document the root cause below.

---

## 🛠️ Troubleshooting Log
*(Document your findings from Phase 4 here)*

* **Issue Identified:** [Add description]
* **Debugging Steps Taken:** [Add steps]
* **Resolution:** [Add fix]