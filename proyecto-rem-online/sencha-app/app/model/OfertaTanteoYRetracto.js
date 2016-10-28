/**
 * This view is used to present the details of a single Oferta > Tanteo y Retracto.
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
    			name:'condicionesTransmision'
    		},
    		{
    			name:'fechaComunicacionReg',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaContestacion',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaSolicitudVisita',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaRealizacionVisita',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaFinTanteo',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'resultadoTanteoCodigo'
    		},
    		{
    			name:'resultadoTanteoDescripcion'
    		},
    		{
    			name:'plazoMaxFormalizacion',
    			type:'date',
    			dateFormat: 'c'
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