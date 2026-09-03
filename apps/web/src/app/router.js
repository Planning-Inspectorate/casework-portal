import { Router as createRouter } from 'express';
import { createRoutesAndGuards as createAuthRoutesAndGuards } from '@planning-inspectorate/core/auth';
import { createMonitoringRoutes } from '@planning-inspectorate/core/controllers';
import { cacheNoCacheMiddleware } from '@planning-inspectorate/core/middleware';
import { createErrorRoutes } from './views/static/error/index.js';
import { buildHome } from './views/home/controller.js';

/**
 * @param {import('#service').WebService} service
 * @returns {import('express').Router}
 */
export function buildRouter(service) {
	const router = createRouter();
	const monitoringRoutes = createMonitoringRoutes(service);
	const { router: authRoutes, guards: authGuards } = createAuthRoutesAndGuards(service);

	router.use('/', monitoringRoutes);

	// don't cache responses, note no-cache allows some caching, but with revalidation
	// see https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Cache-Control#no-cache
	router.use(cacheNoCacheMiddleware);

	router.get('/unauthenticated', (req, res) => res.status(401).render('views/errors/401.njk'));

	if (!service.authDisabled) {
		service.logger.info('registering auth routes');
		router.use('/auth', authRoutes);

		// all subsequent routes require auth

		// check logged in
		router.use(authGuards.assertIsAuthenticated);
	} else {
		service.logger.warn('auth disabled; auth routes and guards skipped');
	}

	router.get('/', buildHome(service));
	router.use('/error', createErrorRoutes(service));

	return router;
}
