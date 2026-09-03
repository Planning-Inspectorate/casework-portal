import type { BaseConfig } from '@planning-inspectorate/core/app';

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
