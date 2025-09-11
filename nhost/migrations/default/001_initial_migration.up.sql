-- Example database migration
-- This file should contain SQL commands to set up your database schema

-- Create users table (example)
-- CREATE TABLE IF NOT EXISTS users (
--     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
--     email TEXT UNIQUE NOT NULL,
--     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
--     updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
-- );