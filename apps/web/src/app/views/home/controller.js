import { formatInTimeZone } from 'date-fns-tz';

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

		return res.render('views/home/view.njk', {
			pageCaption: `${greeting()} ${me.givenName},`,
			pageHeading: 'What would you like to do today?',
			links: [
				{
					title: 'Manage appeals',
					description: 'Access the Manage appeals service to view casework and issue decisions',
					url: 'https://back-office-appeals.planninginspectorate.gov.uk/'
				},
				{
					title: 'Programme appeals',
					description: 'Access the Programme appeals service to view unassigned cases and allocate Inspectors',
					url: 'https://casework-programming.planninginspectorate.gov.uk/'
				},
				{
					title: 'Manage NSIPs',
					description: 'Access the Manage NSIPs service to view casework and documentation',
					url: 'https://back-office-applications.planninginspectorate.gov.uk/'
				},
				{
					title: 'Manage Crown developments',
					description: 'Access the Manage Crown developments service to view casework and documentation',
					url: 'https://crown-developments-manage.planninginspectorate.gov.uk/'
				},
				{
					title: 'Submit a decision for reading',
					description: 'Access CheckMark to submit a decision for reading',
					url: 'https://checkmarkclient.azurewebsites.net/my-decisions/new-decision/'
				},
				{
					title: 'Read a decision',
					description: 'Access CheckMark to read a decision',
					url: 'https://checkmarkclient.azurewebsites.net/my-reading'
				}
			]
		});
	};
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
