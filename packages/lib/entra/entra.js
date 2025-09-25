import { Client } from '@microsoft/microsoft-graph-client';

/**
 * @param {boolean} authEnabled
 * @returns {import('./types.js').InitEntraClient}
 */
export function buildInitEntraClient(authEnabled) {
	return (session) => {
		if (!authEnabled) {
			return null;
		}
		const accessToken = session.account?.accessToken;

		const client = Client.initWithMiddleware({
			authProvider: {
				getAccessToken() {
					return accessToken;
				}
			}
		});
		return new EntraClient(client);
	};
}

export class EntraClient {
	/** @type {import('@microsoft/microsoft-graph-client').Client} */
	#client;

	/**
	 * @param {import('@microsoft/microsoft-graph-client').Client} client
	 */
	constructor(client) {
		this.#client = client;
	}

	/**
	 * @returns {Promise<any>}
	 */
	async me() {
		return this.#client.api('/me').get();
	}
}
