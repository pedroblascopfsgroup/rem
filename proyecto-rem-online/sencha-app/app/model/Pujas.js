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