/**
 * Modelo para el grid del buscador de perfiles de la pestaña de administración.
 */
Ext.define('HreRem.model.GastoRefacturableGridExistente', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
            {
            	name:'idCombo'
            },
            {
            	name:'isGastoRefacturable', 
            	type: 'boolean'
            },
            {
            	name: 'numeroDeGastoRefacturable'
            }
    ],proxy: {
		type: 'uxproxy',
		api: {
            read: 'gastosproveedor/getGastosRefacturablesGastoCreado'
		}
    }
});