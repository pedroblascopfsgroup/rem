/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.Pujas', {
    extend: 'HreRem.model.Base',
	idProperty: 'id',
	
    fields: [ 
    	{
	    	name: 'id'
	    },
	    {
	    	name: 'idActivo'
	    },
		{
	    	name: 'idOferta'
	    },
	    {
	    	name: 'idConcurrencia'
	    },
    	{	
    		name: 'importePuja'
    	},
		{
			name:'importePujaFormateado',
			convert: function(value, record) {
				//if (Ext.isEmpty(record.get('importeOferta'))) {
					if (record.get('importePuja') === undefined) {
					return "*****";
				} else {
					return  record.get('importePuja');
				}
			},
			depends: 'importePuja'
		},
   		{
   			name: 'fechaCrear',
			type: 'date',
			dateFormat: 'c'
   		}
	
    ]/*,
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getPujasDetalleByIdOferta',
		api: {}
    }*/

});