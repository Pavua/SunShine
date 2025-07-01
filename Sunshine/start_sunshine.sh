#!/bin/bash

# Sunshine Startup Script for macOS
echo "🌞 Starting Sunshine..."

# Kill any existing Sunshine processes
killall sunshine 2>/dev/null

# Start Sunshine
echo "Starting Sunshine server..."
./build_xcode/Debug/sunshine &
SUNSHINE_PID=$!

# Wait for Sunshine to start
echo "Waiting for Sunshine to initialize..."
sleep 5

# Check if Sunshine is running
if ps -p $SUNSHINE_PID > /dev/null; then
    echo "✅ Sunshine is running (PID: $SUNSHINE_PID)"
    echo "🌐 Web interface: https://localhost:47990"
    echo "👤 Username: admin"
    echo "🔑 Password: password123"
    echo ""
    echo "Opening web interface in browser..."
    
    # Open web interface in default browser
    open https://localhost:47990
    
    echo ""
    echo "📱 To connect with Moonlight:"
    echo "1. Install Moonlight on your device"
    echo "2. Add computer with IP: $(ipconfig getifaddr en0 || ipconfig getifaddr en1)"
    echo "3. Enter PIN when prompted"
    echo ""
    echo "Press Ctrl+C to stop Sunshine"
    
    # Wait for user to stop
    wait $SUNSHINE_PID
else
    echo "❌ Failed to start Sunshine"
    exit 1
fi 