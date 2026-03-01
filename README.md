Prerequisites & Concepts to Master
[] Containerization (Docker)
[] Orchestration (Nomad)
[] Service Discovery & Networking (Consul)
[] Continuous Integration / Continuous Deployment (CI/CD)
[] Observability (Prometheus, Grafana, Loki)


Phase 1: Infrastructure Initialization (Task 1)
[ ] Provision your local Linux environment (WSL2/Ubuntu).
[ ] Install Docker Engine.
[ ] Download and install the Nomad and Consul binaries.
[ ] Create a consul.hcl file to start Consul in server/client mode. Start the process.
[ ] Create a nomad.hcl file, configuring it to connect to Consul. Start the process.
[ ] Verify access to localhost:8500 (Consul) and localhost:4646 (Nomad).

Phase 2: Application Orchestration (Task 2)
[ ] Fork/Clone the provided backend repository to your GitHub account.
[ ] Write a .nomad job specification file defining the Docker image, CPU/Memory limits, and Consul service registration details.
[ ] Set up a GitHub Actions Self-Hosted Runner on your local VM.
[ ] Write the .github/workflows/deploy.yml pipeline to build the Docker image and trigger the nomad run command.
[ ] Push code to trigger the pipeline and verify the app appears in the Nomad UI.

Phase 3: The Observability Stack (Task 3)
[ ] Write a Nomad job spec for Prometheus. Configure prometheus.yml to use Consul service discovery to automatically find your backend app and the Nomad/Consul agents.
[ ] Write a Nomad job spec for Grafana. Log into the UI, connect Prometheus as a data source, and import a Node Exporter dashboard.
[ ] Write a Nomad job spec for Loki and Promtail (the agent that ships logs to Loki). Configure it to read your backend Docker container logs.

Phase 4: Chaos & Resolution (Task 4)
[ ] Deploy the provided "broken" .nomad file.
[ ] Use the Nomad UI, nomad alloc status, and your newly set up Loki logs to trace the failure (e.g., Is it an out-of-memory error? A failed Consul health check? A bad Docker image tag?).
[ ] Apply the fix, redeploy, and document the root cause.