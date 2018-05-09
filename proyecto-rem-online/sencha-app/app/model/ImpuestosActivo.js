/**
 * Modelo para el grid del buscador de impuestos de la pestaña de administración.
 */
Ext.define('HreRem.model.ImpuestosActivo', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    	{
    		name:'idActivo'
    	},
    	{
           	name:'tipoImpuesto'
        },
        {
          	name: 'fechaInicio',
           	type: 'date',
    		dateFormat: 'c'
        },
        {
           	name: 'fechaFin',
           	type: 'date',
    		dateFormat: 'c'
        },
        {
           	name: 'periodicidad'
        },
        {
           	name: 'calculo'
        }
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'impuestos.json',
		api: {
			update: 'activo/updateImpuestos',
            //read: 'activo/getImpuestos',
            create: 'activo/createImpuestos',
            destroy: 'activo/deleteImpuestos'
		}
    }
});