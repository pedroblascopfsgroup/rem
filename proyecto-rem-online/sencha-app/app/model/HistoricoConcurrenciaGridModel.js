Ext.define('HreRem.model.HistoricoConcurrenciaGridModel', {
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
	    	name: 'numActivo'
	    },
	    {
	    	name: 'idAgrupacion'
	    },
	    {
	    	name: 'numAgrupacion'
	    },
	    {
	    	name: 'numActivoAgrupacion'
	    },
	    {
	    	name: 'importeMinOferta'
	    },
	    {
	    	name: 'importeDeposito'
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
   		}
	
    ]/*,
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getPujasDetalleByIdOferta',
		api: {}
    }*/

});