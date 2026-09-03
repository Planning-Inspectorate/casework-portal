import { formatInTimeZone } from 'date-fns-tz';
import { systems } from './systems.js';
import * as authSession from '@planning-inspectorate/core/auth';

/**
 * @param {import('#service').WebService} service
 * @returns {import('express').Handler}
 */
export function buildHome(service) {
	const { logger } = service;
	return async (req, res) => {
		logger.info('list items');

		const entra = service.initEntraClient(req.session);

		const me = await entra.me();

		const links = systems
			.map((s) => {
				s.userHasAccess = userHasSystemAccess(req.session, s.entraGroups);
				return s;
			})
			.filter((s) => s.userHasAccess);

		return res.render('views/home/view.njk', {
			pageCaption: `${greeting()} ${me.givenName},`,
			pageHeading: 'What would you like to do today?',
			links
		});
	};
}

/**
 * @param session
 * @param {string[]} groupIds
 * @returns {boolean}
 */
function userHasSystemAccess(session, groupIds) {
	if (groupIds.length === 0) {
		return true;
	}
	const account = authSession.getAccount(session);

	if (account?.idTokenClaims.groups) {
		return groupIds.some((id) => account.idTokenClaims.groups.includes(id));
	}
	return false;
}

function greeting() {
	const hour = parseInt(formatInTimeZone(new Date(), 'Europe/London', 'H'));

	if (hour < 11) {
		return 'Good morning';
	}
	if (hour < 16) {
		return 'Good afternoon';
	}
	return 'Good evening';
}
