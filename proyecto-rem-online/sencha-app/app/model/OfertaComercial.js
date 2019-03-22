/**
 *  Modelo para el grid de presupuestos asignados al trabajo
 */
Ext.define('HreRem.model.OfertaComercial', {
    extend: 'HreRem.model.Base',

    fields: [
    	
            {
            	name:'numOferta'
            },
            {
            	name:'idOfertaWebCom'
            },
            {
            	name:'idAgrupacion'
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
    			name:'nombreCliente'
    		},
    		{
    			name:'razonSocialCliente'
    		},
    		{
    			name:'apellidosCliente'
    		},
    		{
    			name:'numDocumentoCliente'
    		},
    		{
    			name:'tipoDocumento'
    		},
    		{
            	name: 'tipoPersona'
            },
            {
            	name: 'estadoCivil'
            },
            {
            	name: 'regimenMatrimonial'
            },
            {
            	name: 'email'
            },
            {
            	name: 'telefono'
            },
            {
            	name: 'direccion'
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
            },
            {
            	name: 'pedirDoc',
            	type : 'boolean'
            }
            
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'agrupacion.json',
		remoteUrl: 'agrupacion/getAgrupacionById',

		api: {
            read: '',
            create: 'agrupacion/createOferta',
            update: '',
            destroy: ''
        }

    }    

});