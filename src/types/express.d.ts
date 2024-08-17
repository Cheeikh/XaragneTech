// src/types/express.d.ts
import { Request } from 'express';

declare module 'express-serve-static-core' {
  interface Request {
    user?: any; // Remplacez `any` par le type exact si vous le connaissez, par exemple `jwt.JwtPayload`
  }
}
