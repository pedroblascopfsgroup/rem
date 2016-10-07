/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.DetalleEconomicoGasto', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [ 
    	{
    		name: 'importePrincipalSujeto'
   	 	},
   	 	{
   	 		name: 'importePrincipalNoSujeto'
   	 	},
   	 	{
   	 		name: 'importeRecargo'
   	 	},
   	 	{
   	 		name: 'importeInteresDemora'
   	 	},
    	{
    		name: 'importeCostas'
   		},
   		{
   			name: 'importeOtrosIncrementos'
   		},
   		{
   			name: 'importeProvisionesSuplidos'
   		},
    	{
    		name: 'impuestoIndirectoTipo'
    	},
    	{
    		name: 'impuestoIndirectoExento'
    	},
    	{
    		name: 'renunciaExencionImpuestoIndirecto'
    	},
    	{
    		name: 'impuestoIndirectoTipoImpositivo'
    	},
		{
			name : 'impuestoIndirectoCuota'
		},
		{
			name : 'irpfTipoImpositivo'
		},
		{
			name : 'irpfCuota'
		},
		{
			name : 'importeTotal'
		},
		{
			name : 'fechaTopePago',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name: 'repercutibleInquilino'
		},
		{
			name: 'importePagado'
		},
		{
			name : 'fechaPago',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name: 'tipoPagador'
		},
		{
			name: 'tipoPago'
		},
		{
			name: 'destinatariosPago'
		},
		{
			name: 'reembolsoTercero'
		},
		{
			name: 'incluirPagoProvision'
		},
		{
			name: 'abonoCuenta'
		},
		{
			name: 'iban'
		},
		{
			name: 'iban1'
		},
		{
			name: 'iban2'
		},
		{
			name: 'iban3'
		},
		{
			name: 'iban4'
		},
		{
			name: 'iban5'
		},
		{
			name: 'iban6'
		},
		{
			name: 'titularCuenta'
		},
		{
			name: 'nifTitularCuenta'
		},
		{
			name: 'pagadoConexionBankia'
		},
		{
			name: 'oficina'
		},
		{
			name: 'numeroConexion'
		}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'detalleeconomicogasto.json',
		api: {
            read: 'gastosproveedor/getTabGasto',
            update: 'gastosproveedor/saveDetalleEconomico'
        },
		
        extraParams: {tab: 'detalleEconomico'}
    }

});