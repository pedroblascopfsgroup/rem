/**
 *  Modelo para Ofertas caixa Pbc 
 */
Ext.define('HreRem.model.OfertaCaixaPbc', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
     		{
    			name:'riesgoOperacion'
    		},
    		{
    			name:'ofertaSospechosa',
    			type: 'boolean'
    		},
    		{
    			name:'deteccionIndicio',
    			type: 'boolean'
    		},
    		{
    			name:'ocultaIdentidadTitular',
    			type: 'boolean'
    		},
    		{
    			name:'actitudIncoherente',
    			type: 'boolean'
    		},
    		{
    			name:'titulosPortador',
    			type: 'boolean'
    		},
    		{
    			name:'motivoCompra'
    		},
    		{
    			name:'finalidadOperacion'
    		},
    		{
    			name:'fondosPropios'
    		},
    		{
    			name:'procedenciaFondosPropios'
    		},
    		{
    			name:'otraProcedenciaFondosPropios'
    		},
    		{
    			name:'medioPago'
    		},
    		{
    			name:'pagoIntermediario',
    			type: 'boolean'
    		},
    		{
    			name:'paisTransferencia'
    		},
    		{
    			name:'fondosBanco'
    		},
	 		{
				name: 'dtoPBCCN',
				type: 'auto'
			},
	 		{
				name: 'dtoPBCArras',
				type: 'auto'
			},
	 		{
				name: 'dtoPBCVenta',
				type: 'auto'
			}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'expedienteComercial.json',
		remoteUrl: 'expedientecomercial/getTabExpediente',
		api: {
           read: 'expedientecomercial/getTabExpediente'
        },
        extraParams: {tab: 'pbcexpediente'}
    }
    
    

});