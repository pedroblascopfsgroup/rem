/**
 * Modelo para el grid del buscador de impuestos de la pestaña de administración.
 */
Ext.define('HreRem.model.TasacionesGasto', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    	{
    		name:'idGasto'
    	},
    	{
           	name:'idActivo'
        },
        {
            name:'idTasacion'
        },
        {
            name:'numGastoHaya'
        },
        {
            name:'numActivo'
        },
        {
            name:'idTasacionExt'
        },
        {
            name:'codigoFirmaTasacion'
        },
        {
          	name: 'fechaRecepcionTasacion',
           	type: 'date',
    		dateFormat: 'c'
        }
    ]
});