import type { BaseConfig } from '@pins/casework-portal-lib/app/config-types';

interface Config extends BaseConfig {
	auth: {
		authority: string;
		clientId: string;
		clientSecret: string;
		disabled: boolean;
		redirectUri: string;
		signoutUrl: string;
	};
}
