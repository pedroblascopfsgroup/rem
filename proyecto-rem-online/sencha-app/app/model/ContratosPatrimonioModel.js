/**
 *  Modelo para el tab Contrato de patrimonio 
 */
Ext.define('HreRem.model.ContratosPatrimonioModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
     		
    		{
    			name:'fechaActualizacion',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'idContrato'
    		},
    		{
    			name:'inquilino'
    		},
    		{
    			name:'renta'
    		},
    		{
    			name:'fechaFirma',
    			type:'date',
    			dateFormat: 'c'
			},
			{
				name:'fechaFinContrato',
    			type:'date',
    			dateFormat: 'c'
			},
			{
    			name: 'estadoContrato'
    		},
    		{
    			name: 'ofertaREM'
    		},
    		{
    			name: 'deudaPendiente'
    		},
    		{
    			name: 'cuota'
    		},
    		{
    			name: 'recibosPendientes'
    		},
    		{
    			name: 'ultimoReciboAdeudado',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'ultimoReciboPagado',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'multiplesResultados',
    			type: 'boolean'
    		},
    		{
    			name: 'tieneRegistro',
    			type: 'boolean'
    		},
    		{
    			name: 'numeroActivoHaya'
    		},
    		{
    			name: 'idExpediente'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getTabActivo'
        },
        extraParams: {tab: 'contratospatrimonio'}
    }

});