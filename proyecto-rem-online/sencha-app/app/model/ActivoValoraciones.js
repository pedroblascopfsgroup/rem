/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.ActivoValoraciones', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
     		{
    			name:'numActivo'
    		},
    		{
    			name:'numActivoRem'
    		},
    		{
    			name:'importeAdjudicacion'
    		},
    		{
    			name:'valorAdquisicion'
    		},    		
    		{
    			name:'importeEvento'
    		},
    		{
    			name:'importeSubasta'
    		},
    		{
    			name:'gestor'
    		},
    		{
    			name:'observaciones'
    		},
    		{
    			name:'importeTasacionVenta'
    		},
    		{
    			name:'valorEstimadoVenta'
    		},
    		{
    			name:'importeNetoContProp'
    		},
    		{
    			name:'importePropVenta'
    		},
    		{
    			name:'importePropAlquiler'
    		},
    		{
    			name:'importeMinPropVenta'
    		},
    		{
    			name:'importeMinPropAlquiler'
    		},
    		{
    			name:'importePublicacion'
    		},
    		{
    			name:'importeValorTasacion'
    		},
    		{
    			name:'fechaValorTasacion',
    			convert: function(value) {
    				if (!Ext.isEmpty(value)) {
						if  ((typeof value) == 'string') {
	    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
	    				} else {
	    					return value;
	    				}
    				}
    			}
    		},
    		{
    			name:'valorEstimadoAlquiler'
    		},
    		{
    			name:'valorLegalVpo'
    		},
    		{
    			name:'valorCatastralSuelo'
    		},
    		{
    			name:'valorCatastralConstruccion'
    		},
    		{
    			name:'bloqueoPrecioFechaIni',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'bloqueoPrecio',
    			convert: function(value, record) {
    				if (Ext.isEmpty(record.get('bloqueoPrecioFechaIni'))) {
    					return '0';
    				} else {
    					return '1';
    				}
    			},
    			depends: 'bloqueoPrecioFechaIni'
    		},
    		{
    			name:'gestorBloqueoPrecio'
    		},
    		{
    			name:'valorReferencia'
    		},
    		{
    			name:'valorAsesoramientoLiquidativo'
    		},
    		{
    			name:'fsvVenta'
    		},
    		{
    			name:'fsvRenta'
    		},
    		{
    			name:'vnc'
    		},
    		{
    			name:'precioTransferencia'
    		},
    		{
    			name:'vacbe'
    		},
    		{
    			name:'vpo',
    			type: 'boolean'
    		},
    		{
    			name:'incluidoBolsaPreciar',
    			type: 'boolean'
    		},
    		{
    			name:'incluidoBolsaRepreciar',
    			type: 'boolean'
    		},
    		{
    			name:'deudaBruta'
    		},
    		{
    			name:'valorRazonable'
    		},
    		{
    			name:'fechaVentaHaya',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'liquidez'
    		},
    		{
    			name:'fsvVentaOrigen'
    		},
    		{
    			name:'fsvRentaOrigen'
    		},
    		{
    			name: 'precioVentaNegociable',
    			type: 'boolean'
    		},
    		{
    			name: 'precioAlquilerNegociable',
    			type: 'boolean'
    		},
    		{
    			name: 'campanyaPrecioVentaNegociable',
    			type: 'boolean'
    		},
    		{
    			name: 'campanyaPrecioAlquilerNegociable',
    			type: 'boolean'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getTabActivo',
		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveValoresPreciosActivo',
            update: 'activo/saveValoresPreciosActivo'
        },
        extraParams: {tab: 'valoracionesprecios'}
    }
    
    

});