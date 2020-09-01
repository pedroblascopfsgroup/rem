Ext.define('HreRem.model.HistoricoDeCamposModel', {
    extend: 'HreRem.model.Base',
    requires: ['HreRem.model.ActivoTrabajo'], 
    idProperty: 'id',

    fields: [
    		{
    			name:'idHistorico'
    		},
    		{
    			name:'idTrabajo'
    		},
    		{
    			name:'pestana'
    		},
    		{
    			name:'campo'
    		},
    		{
    			name:'usuarioModificacion'
    		},
    		{
    			name:'fechaModificacion',
               	type: 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'valorAnterior'
    		},
    		{
    			name:'valorNuevo'
    		}
    ],

	proxy: 
		{
			type: 'uxproxy'
    	}
});