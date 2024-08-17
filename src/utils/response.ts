import { Response } from 'express';

export const sendResponse = (res: Response, statusCode: number, data: any): void => {
    res.status(statusCode).json(data);
};

export const sendErrorResponse = (res: Response, statusCode: number, message: string): void => {
    res.status(statusCode).json({ error: message });
};
