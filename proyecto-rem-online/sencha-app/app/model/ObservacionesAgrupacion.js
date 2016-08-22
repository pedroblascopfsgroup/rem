/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.ObservacionesAgrupacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'id'
    		},
    		{
    			name:'idUsuario'
    		},
    		{
    			name:'nombreCompleto'
    		},
    		{
    			name:'observacion'
    		},
    		{
    			name:'fecha',
    			type:'date',
    			dateFormat: 'c'
    		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById',
		api: {
            create: 'agrupacion/createObservacionesAgrupacion',
            update: 'agrupacion/saveObservacionesAgrupacion',
            destroy: 'agrupacion/deleteObservacionesAgrupacion'
        }
    }

});