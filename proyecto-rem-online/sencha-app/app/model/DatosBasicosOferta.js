/**
 * This view is used to present the details of a single Expediente Comercial.
 */
Ext.define('HreRem.model.DatosBasicosOferta', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [ 
    		
		    {
		    	name: 'idOferta'
		    },
		    {
    			name:'numOferta'
    		},
    		{
    			name:'tipoOfertaDescripcion'
    		},
    		{
    			name:'fechaNotificacion'
    		},
    		{
    			name:'fechaAlta'
    		},
    		{
    			name:'estadoDescripcion'
    		},
    		{
    			name:'prescriptorDescripcion'
    		},
    		{
    			name:'importeOferta'
    		},
    		{
    			name:'importeContraoferta'
    		},
    		{
    			name:'comite'
    		},
    		{
    			name:'numVisita'
    		}, 
    		{
    			name: 'estadoVisitaOfertaCodigo'	
    		},
    		{
    			name:'estadoVisitaOfertaDescripcion'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'expedienteComercial.json',
		
		api: {
            read: 'expedientecomercial/getTabExpediente',
            update: 'expedientecomercial/saveDatosBasicosOferta'
        },
		
        extraParams: {tab: 'datosbasicosoferta'}
    }    

});