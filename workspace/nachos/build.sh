#!/bin/bash

# Build script for Nachos with Java 8
# This script ensures Java 8 is used and builds the specified project

set -e  # Exit on any error

# Function to show usage
show_usage() {
    echo "Usage: $0 [project_number]"
    echo "  project_number: 1, 2, 3, or 4 (default: 1)"
    echo ""
    echo "Examples:"
    echo "  $0        # Build project 1"
    echo "  $0 1      # Build project 1"
    echo "  $0 2      # Build project 2"
    echo "  $0 all    # Build all projects"
}

# Parse arguments
PROJECT=${1:-1}

if [[ "$PROJECT" == "-h" || "$PROJECT" == "--help" ]]; then
    show_usage
    exit 0
fi

echo "Building Nachos with Java 8..."

# Source the Java 8 setup script
if [[ -f "setup-java8.sh" ]]; then
    source setup-java8.sh
else
    echo "❌ setup-java8.sh not found. Please run from the nachos directory."
    exit 1
fi

# Verify Java 8 is active
java_version=$(java -version 2>&1 | head -n1 | cut -d'"' -f2 | cut -d'.' -f1-2)
if [[ "$java_version" != "1.8" ]]; then
    echo "❌ Java 8 is not active. Current version: $java_version"
    echo "Please ensure Java 8 is properly installed and configured."
    exit 1
fi

echo "✓ Using Java 8"

# Function to build a specific project
build_project() {
    local proj_num=$1
    local proj_dir="proj${proj_num}"
    
    if [[ ! -d "$proj_dir" ]]; then
        echo "❌ Project directory $proj_dir not found"
        return 1
    fi
    
    echo "Building project $proj_num..."
    cd "$proj_dir"
    
    # Clean previous build
    echo "  Cleaning previous build..."
    make clean 2>/dev/null || true
    
    # Build the project
    echo "  Compiling..."
    make
    
    echo "✓ Project $proj_num built successfully!"
    cd ..
}

# Build projects based on argument
if [[ "$PROJECT" == "all" ]]; then
    echo "Building all projects..."
    for i in {1..4}; do
        if [[ -d "proj$i" ]]; then
            build_project $i
        fi
    done
elif [[ "$PROJECT" =~ ^[1-4]$ ]]; then
    build_project "$PROJECT"
else
    echo "❌ Invalid project number: $PROJECT"
    show_usage
    exit 1
fi

echo ""
echo "✓ Build completed successfully!"
echo ""
echo "To run Nachos, navigate to the project directory and use:"
echo "  cd proj${PROJECT}"
echo "  java nachos.machine.Machine [options]"
echo ""
echo "Common options:"
echo "  -d ma     # Enable machine debug output"
echo "  -d t      # Enable thread debug output"
echo "  -x file   # Execute user program 'file'"
echo ""
echo "For more options, run:"
echo "  java nachos.machine.Machine -h"
