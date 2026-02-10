/**
 * Add configuration values to locals.
 * @returns {import('express').Handler}
 */
export function addLocalsConfiguration() {
	return (req, res, next) => {
		res.locals.config = {
			headerTitle: 'Manage casework',
			styleFile: 'style-695eb0a1.css'
		};
		next();
	};
}
