/**
 * This view is used to present the details of a single Expediente Comercial.
 */
Ext.define('HreRem.model.OfertaTanteoYRetracto', {
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
    			name:'fechaComunicacionReg'
    		},
    		{
    			name:'fechaContestacion'
    		},
    		{
    			name:'fechaSolicitudVisita'
    		},
    		{
    			name:'fechaRealizacionVisita'
    		},
    		{
    			name:'fechaFinTanteo'
    		},
    		{
    			name:'resultadoTanteoCodigo'
    		},
    		{
    			name:'resultadoTanteoDescripcion'
    		},
    		{
    			name:'fechaMaxFormalizacion'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'expedienteComercial.json',
		
		api: {
            read: 'expedientecomercial/getTabExpediente',
            update: 'expedientecomercial/saveOfertaTanteoYRetracto'
        },
		
        extraParams: {tab: 'ofertatanteoyretracto'}
    }    

});