# Zonhost - Nhost CI/CD Template

A complete GitHub Actions CI/CD setup for Nhost projects with automatic deployment of database migrations, GraphQL metadata, and serverless functions.

## 🚀 Features

- **Automatic Deployments**: Deploy to production (main/master) and development (dev/staging) environments
- **Database Migrations**: Automatically apply new database migrations
- **GraphQL Metadata**: Deploy and apply Hasura GraphQL metadata
- **Serverless Functions**: Deploy TypeScript/JavaScript serverless functions
- **Environment Management**: Separate production and development configurations
- **Flexible Base Directory**: Support for Nhost projects in root or subfolders

## 📋 Setup Instructions

### 1. Repository Configuration

#### Base Directory Configuration
The `NHOST_BASE_DIRECTORY` environment variable in the workflow files controls where your Nhost project is located:
- **Root directory**: Set to `"."` (default)
- **Subfolder**: Set to `"./backend"` or your subfolder path

Update this in both workflow files:
- `.github/workflows/deploy-production.yml`
- `.github/workflows/deploy-development.yml`

#### Branch Configuration
- **Production**: Deployments trigger on pushes to `main` or `master` branches
- **Development**: Deployments trigger on pushes to `dev`, `staging`, or `develop` branches

### 2. GitHub Secrets Configuration

Add the following secrets to your GitHub repository:

#### Production Environment Secrets
- `NHOST_PAT`: Your Nhost Personal Access Token
- `NHOST_PROJECT_ID`: Production project ID
- `NHOST_SUBDOMAIN`: Production project subdomain

#### Development Environment Secrets  
- `NHOST_DEV_PAT`: Development Nhost Personal Access Token (can be same as production)
- `NHOST_DEV_PROJECT_ID`: Development project ID
- `NHOST_DEV_SUBDOMAIN`: Development project subdomain

### 3. GitHub Environments Setup

1. Go to your repository **Settings** → **Environments**
2. Create two environments:
   - `production`
   - `development`
3. Configure protection rules as needed (e.g., require reviews for production)

## 🏗️ Project Structure

```
├── .github/workflows/          # GitHub Actions workflows
│   ├── deploy-production.yml   # Production deployment
│   └── deploy-development.yml  # Development deployment
├── nhost/                      # Nhost configuration
│   ├── migrations/             # Database migrations
│   │   └── default/           # Default database migrations
│   └── metadata/               # GraphQL metadata
├── functions/                  # Serverless functions
│   └── hello.ts               # Example function
├── nhost.toml                 # Nhost project configuration
└── package.json               # Node.js dependencies
```

## 🔄 How Deployments Work

When you push to a configured branch, the CI/CD pipeline:

1. **Checks out** the commit
2. **Installs** Nhost CLI
3. **Authenticates** with your Nhost project
4. **Links** to the appropriate project (production/development)
5. **Deploys** `nhost.toml` configuration
6. **Applies** new database migrations
7. **Deploys** GraphQL metadata
8. **Deploys** serverless functions

## 📝 Usage Examples

### Adding a New Database Migration

1. Create migration files in `nhost/migrations/default/`:
   ```sql
   -- 002_add_users_table.up.sql
   CREATE TABLE users (
     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
     email TEXT UNIQUE NOT NULL,
     created_at TIMESTAMPTZ DEFAULT NOW()
   );
   ```

2. Create corresponding down migration:
   ```sql
   -- 002_add_users_table.down.sql
   DROP TABLE IF EXISTS users;
   ```

3. Commit and push to trigger deployment

### Adding a Serverless Function

1. Create a new TypeScript file in `functions/`:
   ```typescript
   // functions/api/users.ts
   export default async (req, res) => {
     // Your function logic
     res.json({ message: 'Hello from users API!' });
   };
   ```

2. Commit and push to trigger deployment

## 🔧 Local Development

1. Install Nhost CLI:
   ```bash
   npm install -g @nhost/cli
   ```

2. Start local development:
   ```bash
   nhost dev
   ```

3. Your local Nhost stack will be available at:
   - Dashboard: http://localhost:9695
   - GraphQL: http://localhost:8080/v1/graphql
   - Functions: http://localhost:7001

## 🌍 Environment Variables

Configure these in your `nhost.toml` or as environment variables:

- `HASURA_GRAPHQL_ADMIN_SECRET`: Hasura admin secret
- `NHOST_WEBHOOK_SECRET`: Nhost webhook secret  
- `HASURA_GRAPHQL_JWT_SECRET`: JWT secret for authentication

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
