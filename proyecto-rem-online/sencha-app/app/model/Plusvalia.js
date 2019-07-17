/**
 *  Modelo para el tab Informacion Administrativa de Activos
 */
Ext.define('HreRem.model.Plusvalia', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    	{
    		name: 'numActivo'
    	},
    	{
    		name: 'numPlusvalia'
    	},
    	{
    		name: 'provinciaCombo'
    	},
    	{
    		name: 'municipioCombo'

    	},
    	{
    		name: 'id'
    	},
    	{
    		name: 'idActivo'
    	}
    ],

	proxy: {
		type: 'uxproxy',
		localUrl: 'plusvalia.json',
		api: {
            read: 'activo/getListPlusvalia'
        }
    }

});
