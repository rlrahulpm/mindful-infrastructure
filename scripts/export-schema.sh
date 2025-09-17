#!/bin/bash

# Database Schema Export Script
# This script exports the database schema (structure only, no data)

set -e

# Load environment variables
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Default values
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-3306}
DB_NAME=${MYSQL_DATABASE:-productdb}
DB_USER=${DATABASE_USERNAME:-mindful}
DB_PASS=${DATABASE_PASSWORD:-mindful2025}

echo "Exporting database schema..."
echo "Host: $DB_HOST:$DB_PORT"
echo "Database: $DB_NAME"
echo "User: $DB_USER"

# Export schema (structure only, no data)
mysqldump \
    --host=$DB_HOST \
    --port=$DB_PORT \
    --user=$DB_USER \
    --password=$DB_PASS \
    --no-data \
    --routines \
    --triggers \
    --single-transaction \
    --add-drop-table \
    --add-drop-database \
    $DB_NAME > schema.sql

echo "Schema exported to schema.sql"

# Also create a version with database creation
echo "-- Database creation and schema" > schema-with-db.sql
echo "CREATE DATABASE IF NOT EXISTS $DB_NAME;" >> schema-with-db.sql
echo "USE $DB_NAME;" >> schema-with-db.sql
echo "" >> schema-with-db.sql
cat schema.sql >> schema-with-db.sql

echo "Complete schema with database creation exported to schema-with-db.sql"