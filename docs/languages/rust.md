---
outline: deep
---

# Rust Development Guide

Complete guide for Rust development with cargo, clippy, and modern tooling.

## 📚 Table of Contents

- [Setup](#-setup)
- [Rust Basics](#-rust-basics)
- [Cargo Projects](#-cargo-projects)
- [Web Development](#-web-development)
- [CLI Tools](#-cli-tools)
- [Testing](#-testing)
- [Common Workflows](#-common-workflows)
- [Best Practices](#-best-practices)

## 🚀 Setup

### Prerequisites

```bash
# Install Rust via rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Follow prompts, then reload
source $HOME/.cargo/env

# Verify installation
rustc --version
cargo --version
```

### Development Tools

```bash
# Rust analyzer (Language Server)
rustup component add rust-analyzer

# Code formatting
rustup component add rustfmt

# Linting
rustup component add clippy

# Additional tools
cargo install cargo-edit      # cargo add/rm/upgrade
cargo install cargo-watch     # Watch for changes
cargo install cargo-expand    # Expand macros
```

### Coc Extension

```vim
:CocInstall coc-rust-analyzer
```

### Vimx Language Setup

```bash
# Quick add with defaults
vimx lang add rust

# Interactive scaffold (pick extensions, comment style)
vimx lang scaffold rust
```

This creates:
- `langs/rust.vim` — Indentation, keymaps
- `ftdetect/rust.vim` — Detects `.rs` files
- `syntax/rust.vim` — Syntax highlighting

## 📝 Rust Basics

### Features

- Auto-completion
- Type inference display
- Go to definition
- Find references
- Inline hints (types, lifetimes)
- Code actions (implement traits, generate methods)
- Error diagnostics

### Key Mappings

| Shortcut      | Action                        |
| ------------- | ----------------------------- |
| `<leader>rr`  | Cargo run                     |
| `<leader>rb`  | Cargo build                   |
| `<leader>rt`  | Cargo test                    |
| `<leader>rc`  | Cargo check (fast diagnostics)|
| `<leader>cl`  | Cargo clippy                  |
| `<leader>rf`  | Format with rustfmt          |
| `gd`          | Go to definition              |
| `gr`          | Find references               |
| `<leader>rn`  | Rename symbol                 |
| `K`           | Show documentation            |
| `<leader>ca`  | Code actions                  |
| `J`           | Join arguments (rust-analyzer)|

### Hello World

```rust
// src/main.rs
fn main() {
    println!("Hello, world!");
}
```

Run:

```bash
cargo run
# Or in Vim
<leader>rr
```

### Variables and Mutability

```rust
fn main() {
    // Immutable by default
    let x = 5;
    // x = 6; // Error!

    // Mutable
    let mut y = 5;
    y = 6; // OK

    // Type annotation
    let z: i32 = 42;

    // Shadowing
    let x = x + 1;  // OK, new binding
    let x = x * 2;  // OK, shadowing again

    // Constants
    const MAX_POINTS: u32 = 100_000;

    println!("x={}, y={}, z={}", x, y, z);
}
```

### Functions

```rust
// Basic function
fn add(a: i32, b: i32) -> i32 {
    a + b  // No semicolon = return value
}

// With early return
fn divide(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        return Err("Division by zero".to_string());
    }
    Ok(a / b)
}

// Closures
let multiply = |a: i32, b: i32| -> i32 { a * b };
let result = multiply(5, 3);

// Higher-order functions
let numbers = vec![1, 2, 3, 4, 5];
let doubled: Vec<i32> = numbers.iter().map(|x| x * 2).collect();
let sum: i32 = numbers.iter().sum();

fn main() {
    println!("add(2, 3) = {}", add(2, 3));

    match divide(10.0, 3.0) {
        Ok(result) => println!("Result: {:.2}", result),
        Err(e) => println!("Error: {}", e),
    }

    println!("Doubled: {:?}", doubled);
    println!("Sum: {}", sum);
}
```

### Structs

```rust
// Basic struct
struct User {
    name: String,
    email: String,
    age: u32,
    active: bool,
}

// Method implementation
impl User {
    // Constructor
    fn new(name: String, email: String, age: u32) -> Self {
        User {
            name,
            email,
            age,
            active: true,
        }
    }

    // Method
    fn introduce(&self) -> String {
        format!("Hi, I'm {} and I'm {} years old", self.name, self.age)
    }

    // Mutable method
    fn deactivate(&mut self) {
        self.active = false;
    }
}

// Tuple struct
struct Color(u8, u8, u8);

// Unit struct
struct Marker;

fn main() {
    let mut user = User::new(
        "Alice".to_string(),
        "alice@example.com".to_string(),
        25,
    );
    println!("{}", user.introduce());
    user.deactivate();
    println!("Active: {}", user.active);

    let red = Color(255, 0, 0);
    println!("Red: ({}, {}, {})", red.0, red.1, red.2);
}
```

### Enums

```rust
// Basic enum
enum Direction {
    North,
    South,
    East,
    West,
}

// Enum with data
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

// Implementation
impl Message {
    fn call(&self) {
        match self {
            Message::Quit => println!("Quit"),
            Message::Move { x, y } => println!("Move to ({}, {})", x, y),
            Message::Write(text) => println!("Write: {}", text),
            Message::ChangeColor(r, g, b) => println!("Color: ({}, {}, {})", r, g, b),
        }
    }
}

// Option enum (built-in)
fn find_user(id: u32) -> Option<String> {
    match id {
        1 => Some("Alice".to_string()),
        2 => Some("Bob".to_string()),
        _ => None,
    }
}

fn main() {
    let msg = Message::Write("Hello".to_string());
    msg.call();

    if let Some(name) = find_user(1) {
        println!("Found: {}", name);
    }
}
```

### Error Handling

```rust
use std::fs;
use std::io;
use std::num::ParseIntError;

// Custom error type
#[derive(Debug)]
enum AppError {
    Io(io::Error),
    Parse(ParseIntError),
    NotFound(String),
}

impl From<io::Error> for AppError {
    fn from(error: io::Error) -> Self {
        AppError::Io(error)
    }
}

impl From<ParseIntError> for AppError {
    fn from(error: ParseIntError) -> Self {
        AppError::Parse(error)
    }
}

// Using Result
fn read_number_from_file(path: &str) -> Result<i32, AppError> {
    let content = fs::read_to_string(path)?;
    let number: i32 = content.trim().parse()?;
    Ok(number)
}

// Using ? operator for error propagation
fn process_file(path: &str) -> Result<(), AppError> {
    let number = read_number_from_file(path)?;
    println!("Read number: {}", number);
    Ok(())
}

fn main() {
    match process_file("number.txt") {
        Ok(()) => println!("Success"),
        Err(e) => println!("Error: {:?}", e),
    }
}
```

### Traits

```rust
// Define trait
trait Summary {
    fn summarize(&self) -> String;

    // Default implementation
    fn preview(&self) -> String {
        format!("{}...", &self.summarize()[..20])
    }
}

// Implement trait for struct
struct Article {
    title: String,
    author: String,
    content: String,
}

impl Summary for Article {
    fn summarize(&self) -> String {
        format!("{}, by {}", self.title, self.author)
    }
}

struct Tweet {
    username: String,
    content: String,
}

impl Summary for Tweet {
    fn summarize(&self) -> String {
        format!("{}: {}", self.username, self.content)
    }
}

// Trait as parameter
fn notify(item: &impl Summary) {
    println!("Breaking news! {}", item.summarize());
}

// Trait bound syntax
fn notify_all<T: Summary>(items: &[T]) {
    for item in items {
        println!("Breaking news! {}", item.summarize());
    }
}

fn main() {
    let article = Article {
        title: "Rust Guide".to_string(),
        author: "Alice".to_string(),
        content: "A comprehensive guide...".to_string(),
    };

    let tweet = Tweet {
        username: "bob".to_string(),
        content: "Learning Rust is fun!".to_string(),
    };

    notify(&article);
    notify(&tweet);
    println!("Preview: {}", article.preview());
}
```

## 📦 Cargo Projects

### Create New Project

```bash
# Binary project
cargo new my-app
cd my-app

# Library project
cargo new my-lib --lib

# Initialize in existing directory
cargo init
```

### Project Structure

```
my-app/
├── Cargo.toml        # Dependencies and metadata
├── Cargo.lock        # Dependency versions (auto-generated)
├── src/
│   ├── main.rs       # Entry point (binary)
│   └── lib.rs        # Library root
├── tests/            # Integration tests
│   └── integration_test.rs
├── benches/          # Benchmarks
│   └── benchmark.rs
└── examples/         # Example code
    └── example.rs
```

### Cargo.toml

```toml
[package]
name = "my-app"
version = "0.1.0"
edition = "2021"
authors = ["Your Name <you@example.com>"]
description = "A short description"

[dependencies]
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
tokio = { version = "1", features = ["full"] }
anyhow = "1.0"
clap = { version = "4.0", features = ["derive"] }

[dev-dependencies]
assert_cmd = "2.0"
predicates = "3.0"

[profile.release]
opt-level = 3
lto = true
```

### Useful Cargo Commands

```bash
# Build
cargo build              # Debug build
cargo build --release    # Release build

# Run
cargo run                # Build and run
cargo run -- --arg val   # Pass arguments

# Check (faster than build)
cargo check

# Test
cargo test               # Run all tests
cargo test -- --nocapture  # Show println! output
cargo test test_name     # Run specific test

# Format and lint
cargo fmt                # Format code
cargo clippy             # Lint code

# Dependencies
cargo add serde          # Add dependency
cargo add serde --features derive  # With features
cargo rm serde           # Remove dependency
cargo update             # Update dependencies

# Watch for changes
cargo watch -x run       # Rebuild on save
cargo watch -x test      # Re-test on save
cargo watch -x check     # Re-check on save
```

## 🌐 Web Development

### Actix Web

```rust
use actix_web::{web, App, HttpServer, HttpResponse, middleware};
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
struct User {
    id: u32,
    name: String,
    email: String,
}

async fn get_users() -> HttpResponse {
    let users = vec![
        User { id: 1, name: "Alice".to_string(), email: "alice@example.com".to_string() },
        User { id: 2, name: "Bob".to_string(), email: "bob@example.com".to_string() },
    ];
    HttpResponse::Ok().json(users)
}

async fn create_user(user: web::Json<User>) -> HttpResponse {
    println!("Created user: {}", user.name);
    HttpResponse::Created().json(user.into_inner())
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .route("/users", web::get().to(get_users))
            .route("/users", web::post().to(create_user))
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}
```

Install:

```bash
cargo add actix-web actix-rt
cargo add serde --features derive
cargo add serde_json
```

### Axum

```rust
use axum::{
    routing::{get, post},
    Json, Router,
    extract::Path,
};
use serde::{Deserialize, Serialize};

#[derive(Serialize)]
struct Message {
    message: String,
}

async fn hello() -> Json<Message> {
    Json(Message {
        message: "Hello, World!".to_string(),
    })
}

async fn get_user(Path(id): Path<u32>) -> Json<Message> {
    Json(Message {
        message: format!("User {}", id),
    })
}

#[tokio::main]
async fn main() {
    let app = Router::new()
        .route("/", get(hello))
        .route("/users/:id", get(get_user));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000")
        .await
        .unwrap();
    axum::serve(listener, app).await.unwrap();
}
```

Install:

```bash
cargo add axum tokio --features full
cargo add serde --features derive
cargo add serde_json
```

## 🔧 CLI Tools

### Clap (Argument Parser)

```rust
use clap::Parser;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Name of the person to greet
    #[arg(short, long)]
    name: String,

    /// Number of times to greet
    #[arg(short, long, default_value_t = 1)]
    count: u8,

    /// Use formal greeting
    #[arg(short, long)]
    formal: bool,
}

fn main() {
    let args = Args::parse();

    for _ in 0..args.count {
        if args.formal {
            println!("Good day, {}!", args.name);
        } else {
            println!("Hey, {}!", args.name);
        }
    }
}
```

Install:

```bash
cargo add clap --features derive
```

### Colored Output

```rust
use colored::*;

fn main() {
    println!("{}", "This is red".red());
    println!("{}", "This is green".green());
    println!("{}", "This is blue".blue().bold());
    println!("{} {} {}", "Error:".red().bold(), "something went wrong", "!");
    println!("{}: {}", "Warning".yellow(), "disk space low");
}
```

Install:

```bash
cargo add colored
```

## 🧪 Testing

### Unit Tests

```rust
// src/lib.rs
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

pub fn divide(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        Err("Division by zero".to_string())
    } else {
        Ok(a / b)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(add(2, 3), 5);
    }

    #[test]
    fn test_add_negative() {
        assert_eq!(add(-1, -2), -3);
    }

    #[test]
    fn test_divide() {
        let result = divide(10.0, 2.0).unwrap();
        assert!((result - 5.0).abs() < f64::EPSILON);
    }

    #[test]
    fn test_divide_by_zero() {
        assert!(divide(10.0, 0.0).is_err());
    }
}
```

Run:

```bash
cargo test
cargo test -- --nocapture  # Show output
cargo test test_add        # Run specific test
# Or in Vim
<leader>rt
```

### Integration Tests

```rust
// tests/api_test.rs
use my_app::add;

#[test]
fn test_add_integration() {
    assert_eq!(add(10, 20), 30);
}
```

### Benchmarks

```rust
// benches/my_benchmark.rs
use criterion::{black_box, criterion_group, criterion_main, Criterion};

fn fibonacci(n: u64) -> u64 {
    match n {
        0 => 1,
        1 => 1,
        n => fibonacci(n - 1) + fibonacci(n - 2),
    }
}

fn criterion_benchmark(c: &mut Criterion) {
    c.bench_function("fib 20", |b| b.iter(|| fibonacci(black_box(20))));
}

criterion_group!(benches, criterion_benchmark);
criterion_main!(benches);
```

Run:

```bash
cargo bench
```

## 🔄 Common Workflows

### Development Workflow

```bash
# 1. Create project
cargo new my-project
cd my-project

# 2. Open in Vim
vim src/main.rs

# 3. Watch for changes
cargo watch -x check

# 4. Run tests on save
cargo watch -x test

# 5. Build release
cargo build --release
```

### Quick Commands in Vim

| Shortcut     | Command              | Description            |
| ------------ | -------------------- | ---------------------- |
| `<leader>rr` | `cargo run`          | Run the project        |
| `<leader>rb` | `cargo build`        | Build the project      |
| `<leader>rt` | `cargo test`         | Run tests              |
| `<leader>rc` | `cargo check`        | Fast type check        |
| `<leader>cl` | `cargo clippy`       | Lint code              |
| `<leader>rf` | `cargo fmt`          | Format code            |
| `<leader>rw` | `cargo watch -x run` | Watch and run          |

### Publishing a Crate

```bash
# Login to crates.io
cargo login your-api-key

# Dry run
cargo publish --dry-run

# Publish
cargo publish
```

## 🎯 Best Practices

### Project Structure

```
my-project/
├── Cargo.toml
├── src/
│   ├── main.rs        # Binary entry point
│   ├── lib.rs         # Library root
│   ├── error.rs       # Custom error types
│   ├── config.rs      # Configuration
│   ├── models/        # Data structures
│   │   ├── mod.rs
│   │   └── user.rs
│   └── handlers/      # Request handlers
│       ├── mod.rs
│       └── users.rs
├── tests/
├── examples/
└── benches/
```

### Error Handling Patterns

```rust
// Use anyhow for applications
use anyhow::{Result, Context};

fn read_config() -> Result<Config> {
    let content = std::fs::read_to_string("config.toml")
        .context("Failed to read config file")?;
    let config: Config = toml::from_str(&content)
        .context("Failed to parse config")?;
    Ok(config)
}

// Use thiserror for libraries
use thiserror::Error;

#[derive(Error, Debug)]
pub enum MyError {
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),

    #[error("Parse error: {0}")]
    Parse(String),

    #[error("Not found: {0}")]
    NotFound(String),
}
```

### Code Style

```rust
// Prefer borrowing over cloning
fn process(data: &str) -> String {  // Good
    data.to_uppercase()
}

// Use meaningful names
fn calculate_total_price(items: &[Item]) -> f64 {  // Good
    items.iter().map(|i| i.price).sum()
}

// Keep functions small and focused
fn parse_input(input: &str) -> Result<Vec<i32>, ParseIntError> {
    input.lines()
        .map(|line| line.trim().parse())
        .collect()
}

// Use iterators over loops
let doubled: Vec<i32> = numbers.iter().map(|x| x * 2).collect();  // Good

// Handle errors explicitly
match file.read_to_string(&mut contents) {
    Ok(_) => println!("Read successfully"),
    Err(e) => eprintln!("Error reading file: {}", e),
}
```

## 📚 Resources

- Rust Book: https://doc.rust-lang.org/book/
- Rust by Example: https://doc.rust-lang.org/rust-by-example/
- Rustlings: https://github.com/rust-lang/rustlings
- Cargo Book: https://doc.rust-lang.org/cargo/
- crates.io: https://crates.io/
- docs.rs: https://docs.rs/

---

[← Languages](/) | [PHP/Laravel Guide →](php-laravel.md)
