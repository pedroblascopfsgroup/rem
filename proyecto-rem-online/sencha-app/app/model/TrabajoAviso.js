/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.TrabajoAviso', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
      
    		{
    			name: 'descripcion'
    			//, type:'auto'
    			/*convert: function(value, record) {
    				debugger;
    			}*/
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
		remoteUrl: 'trabajo/getTrabajoById',

		api: {
            read: 'trabajo/getAvisosTrabajoById'
        }

    }    

});