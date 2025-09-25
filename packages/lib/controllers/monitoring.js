import { Router as createRouter } from 'express';
import { asyncHandler } from '../util/async-handler.js';
import { cacheNoStoreMiddleware } from '../middleware/cache.js';
/**
 * @param {Object} params
 * @param {import('pino').BaseLogger} params.logger
 * @param {string} [params.gitSha]
 * @returns {import('express').Router}
 */
export function createMonitoringRoutes({ gitSha, logger }) {
	const router = createRouter();
	const handleHealthCheck = buildHandleHeathCheck(logger, gitSha);

	router.use(cacheNoStoreMiddleware); // don't store monitoring responses, always get fresh data

	router.head('/', asyncHandler(handleHeadHealthCheck));
	router.get('/health', asyncHandler(handleHealthCheck));

	return router;
}

/** @type {import('express').RequestHandler} */
export function handleHeadHealthCheck(_, response) {
	// no-op - HEAD mustn't return a body
	response.sendStatus(200);
}

/**
 * @param {import('pino').BaseLogger} logger
 * @param {string} [gitSha]
 * @returns {import('express').RequestHandler}
 */
export function buildHandleHeathCheck(logger, gitSha) {
	return async (_, response) => {
		response.status(200).send({
			status: 'OK',
			uptime: process.uptime(),
			commit: gitSha
		});
	};
}
