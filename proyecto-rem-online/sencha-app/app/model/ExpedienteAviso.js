/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.ExpedienteAviso', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
      
    		{
    			name: 'descripcion'
    		},
    		{
    			name: 'mostrarAvisos',
    			depends: 'descripcion',
    			convert: function(value, record) {
					if (!Ext.isEmpty(record.get('descripcion'))) {
	    				return true;
	    			} else {
    					return false;
    				}
    			}
    		}

    		
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'expedientecomercial/getAvisosExpedienteById'

    }    

});