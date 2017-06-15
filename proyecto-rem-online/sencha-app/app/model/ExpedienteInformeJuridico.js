/**
 * This view is used to present the details of a single InformeJuridico.
 */
Ext.define('HreRem.model.ExpedienteInformeJuridico', {
    extend: 'HreRem.model.Base',
    requires : ['HreRem.ux.data.Proxy'], 

    fields: [    
            {
            	name:'id'
            },
    		{
    			name:'idActivo'
    		},
    		{
    			name:'idExpediente'
    		},
    		{
    			name:'fechaEmision',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'resultadoBloqueo'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'expedientecomercial/getFechaEmisionInfJuridico',
            update: 'expedientecomercial/saveFechaEmisionInfJuridico',
            create: 'expedientecomercial/saveFechaEmisionInfJuridico'
        }
    } 
    
    

});