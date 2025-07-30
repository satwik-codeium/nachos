#!/bin/bash

# Setup Java 8 environment for Nachos project
# This script attempts to find and configure Java 8 automatically

echo "Setting up Java 8 environment for Nachos..."

# Function to check if Java version is 8
check_java8() {
    if command -v java >/dev/null 2>&1; then
        java_version=$(java -version 2>&1 | head -n1 | cut -d'"' -f2 | cut -d'.' -f1-2)
        if [[ "$java_version" == "1.8" ]]; then
            return 0
        fi
    fi
    return 1
}

# Try to find Java 8 installation
find_java8() {
    # Common Java 8 installation paths on macOS
    local java8_paths=(
        "/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home"
        "/Library/Java/JavaVirtualMachines/openjdk-8.jdk/Contents/Home"
        "/Library/Java/JavaVirtualMachines/jdk1.8.0_*.jdk/Contents/Home"
        "/usr/libexec/java_home -v 1.8 2>/dev/null"
        "/opt/homebrew/opt/openjdk@8"
        "/usr/local/opt/openjdk@8"
    )
    
    for path in "${java8_paths[@]}"; do
        if [[ "$path" == *"java_home"* ]]; then
            # Use java_home utility
            local java_home_result
            java_home_result=$(/usr/libexec/java_home -v 1.8 2>/dev/null)
            if [[ -n "$java_home_result" && -d "$java_home_result" ]]; then
                echo "$java_home_result"
                return 0
            fi
        elif [[ "$path" == *"*"* ]]; then
            # Handle wildcard paths
            for expanded_path in $path; do
                if [[ -d "$expanded_path" ]]; then
                    echo "$expanded_path"
                    return 0
                fi
            done
        elif [[ -d "$path" ]]; then
            echo "$path"
            return 0
        fi
    done
    
    return 1
}

# Check if Java 8 is already active
if check_java8; then
    echo "✓ Java 8 is already active"
    java -version
else
    echo "Looking for Java 8 installation..."
    
    # Try to find Java 8
    JAVA8_HOME=$(find_java8)
    
    if [[ -n "$JAVA8_HOME" ]]; then
        export JAVA_HOME="$JAVA8_HOME"
        export PATH="$JAVA_HOME/bin:$PATH"
        
        echo "✓ Found Java 8 at: $JAVA_HOME"
        echo "Java environment configured for Nachos:"
        echo "JAVA_HOME: $JAVA_HOME"
        java -version
    else
        echo "❌ Java 8 not found. Please install Java 8:"
        echo "  - Via Homebrew: brew install openjdk@8"
        echo "  - Via AdoptOpenJDK: https://adoptopenjdk.net/"
        echo "  - Via Oracle: https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html"
        exit 1
    fi
fi

echo ""
echo "To make this permanent, add these lines to your ~/.bashrc or ~/.zshrc:"
echo "export JAVA_HOME=$JAVA_HOME"
echo "export PATH=\$JAVA_HOME/bin:\$PATH"
echo ""
echo "Or source this script in each session:"
echo "source setup-java8.sh"
