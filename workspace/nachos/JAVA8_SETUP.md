# Java 8 Setup Guide for Nachos

This guide explains how to set up and use Java 8 with the Nachos operating system project.

## Prerequisites

You need Java 8 (JDK 1.8) installed on your system. The project has been updated to specifically target Java 8 compilation.

### Installing Java 8 on macOS

Choose one of the following methods:

1. **Via Homebrew (Recommended):**
   ```bash
   brew install openjdk@8
   ```

2. **Via AdoptOpenJDK:**
   - Download from: https://adoptopenjdk.net/
   - Select OpenJDK 8 (LTS) and your platform

3. **Via Oracle:**
   - Download from: https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html

## Quick Start

1. **Set up Java 8 environment:**
   ```bash
   ./setup-java8.sh
   ```

2. **Build a project (e.g., project 1):**
   ```bash
   ./build.sh 1
   ```

3. **Run Nachos:**
   ```bash
   cd proj1
   java nachos.machine.Machine -d ma
   ```

## Detailed Usage

### Environment Setup

The `setup-java8.sh` script automatically detects and configures Java 8:

```bash
# Run the setup script
./setup-java8.sh

# Or source it to set environment variables in current shell
source setup-java8.sh
```

The script will:
- Automatically detect Java 8 installations in common locations
- Set `JAVA_HOME` and update `PATH`
- Verify the Java version
- Provide instructions for permanent setup

### Building Projects

Use the enhanced build script to compile specific projects:

```bash
# Build project 1 (default)
./build.sh

# Build a specific project
./build.sh 1    # Project 1
./build.sh 2    # Project 2
./build.sh 3    # Project 3
./build.sh 4    # Project 4

# Build all projects
./build.sh all

# Show help
./build.sh --help
```

### Manual Building

If you prefer to build manually:

```bash
# Set up Java 8 environment
source setup-java8.sh

# Navigate to project directory
cd proj1

# Clean and build
make clean
make
```

### Running Nachos

After building, run Nachos from the project directory:

```bash
cd proj1
java nachos.machine.Machine [options]
```

Common options:
- `-d ma` - Enable machine debug output
- `-d t` - Enable thread debug output  
- `-d i` - Enable interrupt debug output
- `-x file` - Execute user program 'file'
- `-h` - Show help

## Project Structure

The Nachos project is organized into phases:

- **proj1/**: Threads and synchronization
- **proj2/**: User programs and system calls
- **proj3/**: Virtual memory
- **proj4/**: File systems and networking

Each project builds on the previous one and includes specific components.

## Compilation Details

The build system has been updated for Java 8:

- **Source/Target**: Set to Java 8 (`-source 8 -target 8`)
- **Debugging**: Debug information included (`-g`)
- **Documentation**: Updated to use Java 8 API documentation

## Troubleshooting

### Java 8 Not Found
If the setup script can't find Java 8:

1. Verify Java 8 is installed:
   ```bash
   java -version
   ```

2. Check installation paths:
   ```bash
   /usr/libexec/java_home -V
   ```

3. Manually set JAVA_HOME:
   ```bash
   export JAVA_HOME=/path/to/java8
   export PATH=$JAVA_HOME/bin:$PATH
   ```

### Compilation Errors
If you encounter compilation errors:

1. Ensure Java 8 is active:
   ```bash
   java -version
   javac -version
   ```

2. Clean and rebuild:
   ```bash
   make clean
   make
   ```

### Runtime Issues
If Nachos fails to run:

1. Check classpath and working directory
2. Verify all required classes are compiled
3. Check for security manager issues (normal for Nachos)

## Making Java 8 Permanent

To avoid running the setup script each time, add these lines to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH
```

Replace the path with your actual Java 8 installation path.

## Version Information

- **Java Version**: 8 (1.8.x)
- **Nachos Version**: 4.0 Java
- **Build System**: GNU Make
- **Platform**: macOS (adaptable to Linux/Windows)

For more information about Nachos, see the main README file.
