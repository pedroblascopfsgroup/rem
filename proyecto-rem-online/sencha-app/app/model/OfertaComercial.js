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
            	name: 'cesionDatos',
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
            },
            {
            	name:'numOferPrincipal'
            },
            {
            	name:'vinculoCaixaCodigo'
            },
            {
            	name: 'tipologivaVentaCod'
            },
            {
            	name:'provinciaNacimiento'
            },
            {
            	name:'provinciaNacimientoDescripcion'
            },
            {
            	name: 'codigoPostalNacimiento'
            },
            {
            	name: 'emailNacimiento'
            },
            {
            	name: 'telefonoNacimiento1'
            },
            {
            	name: 'telefonoNacimiento2'
            },
            {
            	name: 'checkSubasta',
    			type: 'boolean'
            },
            {
    			name: 'codTipoDocumentoRte'
    		},
    		{
    			name: 'numDocumentoRte'
    		},
    		{
    			name:'nombreRazonSocialRte'
    		},
    		{
    			name:'apellidosRte'
    		},
    		{
    			name: 'paisNacimientoRepresentanteCodigo'
    		},
    		{
    			name: 'paisNacimientoRepresentanteDescripcion'
    		},
    		{
    			name:'provinciaNacimientoRepresentanteCodigo'
    		},
    		{
    			name:'provinciaNacimientoRepresentanteDescripcion'
    		},
    		{
    			name:'localidadNacimientoRepresentanteCodigo'
    		},
    		{
    			name:'localidadNacimientoRepresentanteDescripcion'
    		},
    		{
    			name:'fechaNacimientoRepresentante',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'codigoPaisRte'
    		},
    		{
    			name:'provinciaRteCodigo'
    		},
    		{
    			name:'municipioRteCodigo'
    		},
    		{
    			name:'codigoPostalRte'
    		},
    		{
    			name:'direccionRte'
    		},
    		{
    			name:'emailRte'
    		},
    		{
    			name:'telefono1Rte'
    		},
    		{
    			name:'telefono2Rte'
    		},
    		{
    			name:'representantePrp',
    			type: 'boolean'
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