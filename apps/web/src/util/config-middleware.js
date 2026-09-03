/**
 * Add configuration values to locals.
 * @returns {import('express').Handler}
 */
export function addLocalsConfiguration() {
	return (req, res, next) => {
		res.locals.config = {
			headerTitle: 'Manage casework',
			styleFile: 'style-f258795f.css'
		};
		next();
	};
}
