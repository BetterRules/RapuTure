// By default, this pack is loaded for server-side rendering.
// It must expose react_ujs as `ReactRailsUJS` and prepare a require context.
let componentRequireContext = require.context('components', true);
let ReactRailsUJS = require('react_ujs');
ReactRailsUJS.useContext(componentRequireContext);
