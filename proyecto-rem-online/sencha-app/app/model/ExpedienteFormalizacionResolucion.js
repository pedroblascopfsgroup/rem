/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.ExpedienteFormalizacionResolucion', {
    extend: 'HreRem.model.Base',

    fields: [    

    		{
    			name:'nombreNotario'
    		},
    		{
    			name:'motivoResolucion'
    		},
    		{
    			name:'gastosCargo'
    		},
    		{
    			name:'formaPago'
    		},
    		{
    			name:'fechaPeticion',
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
    			name:'fechaResolucion',
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
    			name:'importe'
    		},
    		{
    			name:'fechaPago',
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
    			name:'numProtocolo'
    		},
    		{
    			name:'fechaVenta',
    			type:'date',
    			dateFormat: 'c'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'expedienteformalizacionresolucion.json',
		api: {
            read: 'expedientecomercial/getTabExpediente'
        },
		 extraParams: {tab: 'formalizacion'}
    }
    
    

});