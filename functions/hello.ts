import { Request, Response } from 'express';

/**
 * Example serverless function for Nhost
 * This function will be deployed as part of the CI/CD process
 */
export default async (req: Request, res: Response) => {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  try {
    const { name = 'World' } = req.body || req.query;
    
    return res.status(200).json({
      message: `Hello, ${name}! This function was deployed via CI/CD.`,
      timestamp: new Date().toISOString(),
      method: req.method,
    });
  } catch (error) {
    console.error('Error in hello function:', error);
    return res.status(500).json({
      error: 'Internal server error',
      message: 'Something went wrong'
    });
  }
};