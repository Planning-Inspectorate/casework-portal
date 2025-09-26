import { buildRouter } from './router.js';
import { configureNunjucks } from './nunjucks.js';
import { addLocalsConfiguration } from '#util/config-middleware.js';
import { createBaseApp } from '@pins/casework-portal-lib/app/app.js';

/**
 * @param {import('#service').WebService} service
 * @returns {Express}
 */
export function createApp(service) {
	const router = buildRouter(service);
	// create an express app, and configure it for our usage
	return createBaseApp({
		service,
		configureNunjucks,
		router,
		middlewares: [addLocalsConfiguration()],
		cspDirectives
	});
}

/** @type {import('helmet').ContentSecurityPolicyOptions['directives']} */
const cspDirectives = {
	scriptSrc: [
		"'self'",
		"'sha256-EkKo+C5UwqgMN26GNVh01ET+DM5zmVk0irXY7ci7frA='",
		(req, res) => `'nonce-${res.locals.cspNonce}'`
	],
	defaultSrc: ["'self'"],
	connectSrc: ["'self'"],
	fontSrc: ["'self'"],
	imgSrc: ["'self'"],
	styleSrc: ["'self'"]
};
