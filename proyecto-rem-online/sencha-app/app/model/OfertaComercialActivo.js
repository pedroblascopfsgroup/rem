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
    			name:'deDerechoTanteo'
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
            	name: 'intencionFinanciar'
            },
            {
            	name: 'codigoPrescriptor'
            },
            {
            	name: 'codigoSucursal'
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
            	name: 'claseOferta'
            },
    		{
            	name: 'numOferPrincipal'
            },
    		{
            	name: 'vinculoCaixaCodigo'
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