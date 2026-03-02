use std::thread;
use std::time::Duration;

fn main() {
    println!("🚀 Sentinel worker container is up and running!");
    loop {
        println!("Processing tasks in isolated environment...");
        thread::sleep(Duration::from_secs(3));
    }
}