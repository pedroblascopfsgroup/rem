/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.DetalleEconomicoGasto', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [ 
    	{
    		name: 'importePrincipalSujeto',
    		type: 'number',
    		defaultValue: 0
   	 	},
   	 	{
   	 		name: 'importePrincipalNoSujeto',
   	 		type: 'number',
   	 		defaultValue: 0
   	 	},
   	 	{
   	 		name: 'importeRecargo',
   	 		type: 'number',
   	 		defaultValue: 0
   	 	},
   	 	{
   	 		name: 'importeInteresDemora',
   	 		type: 'number',
   	 		defaultValue: 0
   	 	},
    	{
    		name: 'importeCostas',
    		type: 'number',
    		defaultValue: 0
   		},
   		{
   			name: 'importeOtrosIncrementos',
   			type: 'number',
   			defaultValue: 0
   		},
   		{
   			name: 'importeProvisionesSuplidos',
   			type: 'number',
   			defaultValue: 0
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
    		name: 'impuestoIndirectoTipoImpositivo',
    		type: 'number',
   			defaultValue: 0
    	},
		{
			name : 'impuestoIndirectoCuota',
			type: 'number',
			defaultValue: 0
		},
		{
			name : 'irpfTipoImpositivo',
			type: 'number',
   			defaultValue: 0
		},
		{
			name : 'irpfCuota',
			type: 'number',
			defaultValue: 0
		},
		{
			name : 'importeTotal',
			type: 'number',
			defaultValue: 0
		},
		{
			name : 'baseImponibleCalculo',
			type: 'number',
			defaultValue: 0,
			calculate: function (data) {
         		return data.importeTotal;
			},
			depends: 'importeTotal'
     
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
			name: 'importePagado',
			type: 'number',
			defaultValue: 0
		},
		{
			name : 'fechaPago',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name: 'tipoPagadorCodigo'
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
		},
		{
			name: 'optaCriterioCaja'
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