# ==========================================
# Stage 1: The Builder
# ==========================================
# We use the official, heavy Rust image strictly for compiling the code.
FROM rust:latest AS builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy our local source code into the builder container
COPY . .

# Compile the Rust binary for release
RUN cargo build --release

# ==========================================
# Stage 2: The Runtime (The final image)
# ==========================================
# We switch to a tiny Debian OS image. It doesn't have Rust installed at all!
FROM debian:bookworm-slim

WORKDIR /app

# Copy ONLY the compiled binary from the 'builder' stage into this tiny image
COPY --from=builder /usr/src/app/target/release/sentinel_worker .

# Command to execute when the container starts
CMD ["./sentinel_worker"]