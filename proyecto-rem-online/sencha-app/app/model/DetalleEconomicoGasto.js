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
    		name: 'impuestoIndirectoExento',
    		type: 'boolean',
    		critical: true
    	},
    	{
    		name: 'renunciaExencionImpuestoIndirecto',
    		type: 'boolean',
    		critical: true
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
			defaultValue: 0,
			critical: true
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
			name : 'fechaConexion',
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
			name: 'reembolsoTercero',
			critical: true
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
		},
		{
			name: 'anticipo'
		},
		{
			name : 'fechaAnticipo',
			type : 'date',
			dateFormat: 'c'
		},
		{
			name: 'cartera'
		},
		{
			name: 'exencionlbk'
		},
		{
			name: 'totalImportePromocion'
		},
		{
			name: 'importeTotalPrinex'
		},
		{
			name: 'prorrata'
		},
		{
			name: 'existeRecargo'
		},
		{
			name:'tipoRecargo'
		},
		{
			name: 'gastosRefacturadosGasto'
		},
		{
			name: 'numeroGastoHaya'
		},
		{
			name:'isGastoRefacturableExistente',
			type: 'boolean'
		},
		{
   			name: 'gastoRefacturableB', 
   			type: 'boolean'
   		},
   		{
   			name:'bloquearCheckRefacturado',
   			type:'boolean'
   		},
   		{
   			name: 'bloquearGridRefacturados',
   			type: 'boolean'
   		},
   		{
   			name:'noAnyadirEliminarGastosRefacturados',
   			type:'boolean'
   		},
   		{
			name : 'irpfTipoImpositivoRetG',
			type: 'number',
   			defaultValue: 0
		},
		{
			name : 'irpfCuotaRetG',
			type: 'number',
			defaultValue: 0
		},
		{
			name : 'baseRetG',
			type: 'number',
			defaultValue: 0
		},
		{
			name : 'baseImpI',
			type: 'number',
			defaultValue: 0
		},
		{
   			name: 'retencionGarantiaAplica',
   			type: 'boolean'
   		},
		{
			name: 'clave'
		},
		{
			name: 'subclave'
		},
		{
			name: 'importeBrutoLbk',
			type: 'number',
			defaultValue: 0
		},
		{
			name: 'tipoRetencionCodigo'
		},
		{
   			name: 'pagoUrgente',
   			type: 'boolean'
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