---
name: CI/CD Deployment Issue
about: Report a problem with the Nhost CI/CD deployment workflow
title: '[CI/CD] '
labels: ['bug', 'ci/cd']
assignees: ''

---

## Describe the Issue
A clear and concise description of what went wrong with the deployment.

## Environment
- **Environment**: [Production/Development]
- **Branch**: [main/dev/staging/etc]
- **Deployment Type**: [Automatic/Manual]

## Workflow Information
- **Workflow Run URL**: [Link to the failed GitHub Actions run]
- **Error Step**: [Which step in the workflow failed]

## Error Details
```
Paste the error message from the GitHub Actions log here
```

## Expected Behavior
A clear description of what you expected to happen.

## Current Nhost Configuration
- **Base Directory**: [. or ./backend or other]
- **Nhost Project Type**: [New project/Existing project]

## Checklist
- [ ] I have verified my GitHub secrets are correctly configured
- [ ] I have checked that my Nhost PAT has the required permissions
- [ ] I have confirmed the project ID and subdomain are correct
- [ ] I have reviewed the nhost.toml configuration
- [ ] I have checked the migration/metadata/function files are valid

## Additional Context
Add any other context about the problem here, such as:
- Recent changes to the codebase
- Environment-specific issues
- Related error messages