/**
 *  Modelo para el grid de presupuestos asignados al trabajo
 */
Ext.define('HreRem.model.OfertaComercialActivo', {
    extend: 'HreRem.model.Base',

    fields: [    
  
            {
            	name:'numOferta'
            },
            {
            	name:'idOfertaWebCom'
            },
            {
            	name:'idActivo'
            },
            {
            	name:'importe'
            },
            {
            	name:'idCliente'
            },
    		{
    			name:'estadoOferta'
    		},
    		{
    			name:'tipoOferta'
    		},
    		{
    			name:'importeOferta'
    		},
            {
            	name: 'cesionDatosHaya',
            	type : 'boolean'
            },
            {
            	name: 'comunicacionTerceros',
            	type : 'boolean'
            },
            {
            	name: 'transferenciasInternacionales',
            	type : 'boolean'
            }
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'agrupacion.json',
		remoteUrl: 'activo/getActivoById',

		api: {
            read: '',
            create: 'activo/createOferta',
            update: '',
            destroy: ''
        }

    }    

});