Ext.define('HreRem.model.AgendaTrabajoModel', {
    extend: 'HreRem.model.Base',
    requires: ['HreRem.model.ActivoTrabajo'], 
    idProperty: 'id',

    fields: [
    		{
    			name:'idAgenda'
    		},
    		{
    			name:'idTrabajo'
    		},
    		{
    			name:'gestorAgenda'
    		},
    		{
    			name:'fechaAgenda',
               	type: 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'tipoGestion'
    		},
    		{
    			name:'observacionesAgenda'
    		},
    		{
    			name:'nombreGestorOrProveedor'
    		}
    ],

	proxy: 
		{
			type: 'uxproxy',
			api: {
	            create: 'trabajo/createAgendaTrabajo',
	            //update: 'trabajo/updateAgendaTrabajo',
	            destroy: 'trabajo/deleteAgendaTrabajo'
	        }
    	}
});