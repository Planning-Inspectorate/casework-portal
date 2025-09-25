import { EntraClient } from './entra.js';

interface AuthSession {
	account?: {
		accessToken?: string;
	};
}

export type InitEntraClient = (session: AuthSession) => EntraClient | null;
