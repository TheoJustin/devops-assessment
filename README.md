# Local DevOps Infrastructure & Deployment Pipeline

This repository contains the configuration, infrastructure as code, and CI/CD pipelines for a complete, single-node DevOps environment. It simulates a production-grade distributed system locally using HashiCorp Nomad, Consul, Docker, and a modern observability stack.

## 📚 Prerequisites & Concepts to Master
Before executing the deployment phases, ensure a solid understanding of the following core concepts:

- [ ] **Containerization (Docker)**
      
- [ ] **Orchestration (Nomad)**
      
- [ ] **Service Discovery & Networking (Consul)**
      
- [ ] **Continuous Integration / Continuous Deployment (CI/CD)**
      
- [ ] **Observability (Prometheus, Grafana, Loki)**
      

---

## 🚀 Execution Roadmap

### Phase 1: Infrastructure Initialization (Task 1)
*Goal: Provision the underlying server and establish the Nomad/Consul control plane.*

- [ ] Provision the local Linux environment (WSL2/Ubuntu or Multipass/macOS).
- [ ] Install Docker Engine.
- [ ] Download and install the Nomad and Consul binaries.
- [ ] Create a `consul.hcl` file to start Consul in server/client mode, and start the process.
- [ ] Create a `nomad.hcl` file, configuring it to connect to Consul, and start the process.
- [ ] Verify access to `localhost:8500` (Consul) and `localhost:4646` (Nomad).

### Phase 2: Application Orchestration (Task 2)
*Goal: Automate the deployment of a containerized backend service.*

- [ ] Fork/Clone the provided backend repository to the GitHub account.
- [ ] Write a `.nomad` job specification file defining the Docker image, CPU/Memory limits, and Consul service registration details.
- [ ] Set up a GitHub Actions Self-Hosted Runner on the local VM.
- [ ] Write the `.github/workflows/deploy.yml` pipeline to build the Docker image and trigger the `nomad run` command.
- [ ] Push code to trigger the pipeline and verify the app appears in the Nomad UI.

### Phase 3: The Observability Stack (Task 3)
*Goal: Implement metrics, logging, and visualization for the cluster.*

- [ ] Write a Nomad job spec for **Prometheus**. Configure `prometheus.yml` to use Consul service discovery to automatically find the backend app and the Nomad/Consul agents.
- [ ] Write a Nomad job spec for **Grafana**. Log into the UI, connect Prometheus as a data source, and import a Node Exporter dashboard.
- [ ] Write a Nomad job spec for **Loki** and **Promtail** (the agent that ships logs to Loki). Configure it to read the backend Docker container logs.

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