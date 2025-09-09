#!/bin/bash

# Setup script for cloning all Mindful repositories

echo "Setting up Mindful repositories..."

# Define repository URLs (update these with your actual repository URLs)
CRM_BACKEND_REPO="git@github.com:yourusername/mindful-crm-backend.git"
CRM_FRONTEND_REPO="git@github.com:yourusername/mindful-crm-frontend.git"
PRODUCT_BACKEND_REPO="git@github.com:yourusername/mindful-product-backend.git"
PRODUCT_FRONTEND_REPO="git@github.com:yourusername/mindful-product-frontend.git"

# Clone repositories if they don't exist
if [ ! -d "../mindful-crm-backend" ]; then
    echo "Cloning CRM Backend..."
    git clone $CRM_BACKEND_REPO ../mindful-crm-backend
else
    echo "CRM Backend already exists"
fi

if [ ! -d "../mindful-crm-frontend" ]; then
    echo "Cloning CRM Frontend..."
    git clone $CRM_FRONTEND_REPO ../mindful-crm-frontend
else
    echo "CRM Frontend already exists"
fi

if [ ! -d "../mindful-product-backend" ]; then
    echo "Cloning Product Backend..."
    git clone $PRODUCT_BACKEND_REPO ../mindful-product-backend
else
    echo "Product Backend already exists"
fi

if [ ! -d "../mindful-product-frontend" ]; then
    echo "Cloning Product Frontend..."
    git clone $PRODUCT_FRONTEND_REPO ../mindful-product-frontend
else
    echo "Product Frontend already exists"
fi

# Set up environment files
echo "Setting up environment files..."

# CRM Backend
if [ ! -f "../mindful-crm-backend/.env" ]; then
    cp ../mindful-crm-backend/.env.example ../mindful-crm-backend/.env 2>/dev/null || echo "No .env.example found for CRM Backend"
fi

# CRM Frontend
if [ ! -f "../mindful-crm-frontend/.env" ]; then
    cp ../mindful-crm-frontend/.env.example ../mindful-crm-frontend/.env 2>/dev/null || echo "No .env.example found for CRM Frontend"
fi

# Product Backend
if [ ! -f "../mindful-product-backend/.env" ]; then
    cp ../mindful-product-backend/.env.example ../mindful-product-backend/.env 2>/dev/null || echo "No .env.example found for Product Backend"
fi

# Product Frontend
if [ ! -f "../mindful-product-frontend/.env" ]; then
    cp ../mindful-product-frontend/.env.example ../mindful-product-frontend/.env 2>/dev/null || echo "No .env.example found for Product Frontend"
fi

# Infrastructure
if [ ! -f ".env" ]; then
    cp .env.example .env 2>/dev/null || echo "No .env.example found for Infrastructure"
fi

echo "Setup complete! You can now run 'docker-compose up' to start all services."