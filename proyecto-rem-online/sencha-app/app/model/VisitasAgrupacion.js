/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.VisitasAgrupacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
		{
			name : 'idVisita'
		},
		{
			name : 'fechaSolicitud',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name : 'nombre'
		},
		{
			name : 'numDocumento'
		},
		{
			name : 'fechaVisita',
			type : 'date',
			dateFormat: 'c'
		} 
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById',
    }

});