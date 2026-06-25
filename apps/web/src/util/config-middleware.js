/**
 * Add configuration values to locals.
 * @returns {import('express').Handler}
 */
export function addLocalsConfiguration() {
	return (req, res, next) => {
		res.locals.config = {
			headerTitle: 'Manage casework',
			styleFile: 'style-a17c5b26.css'
		};
		next();
	};
}
