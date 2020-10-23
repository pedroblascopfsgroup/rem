Ext.define('HreRem.model.AgendaRevisionTituloGridModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'idActivoAgendaRevisionTitulo',

    fields: [
    		{
    			name:'id'
    		},
    		{
    			name:'idActivoAgendaRevisionTitulo'
    		},
    		{
    			name:'subtipologiaCodigo'
    		},
    		{
    			name:'subtipologiaDescripcion'
    		},
    		{
    			name:'observaciones'
    		},
    		{
    			name:'fechaAlta',
    		   	type: 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'gestorAlta'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		localUrl: 'admision.json',
		api: { 
            create: 'admision/createAgendaRevisionTitulo',
            update: 'admision/updateAgendaRevisionTitulo',
            destroy: 'admision/deleteAgendaRevisionTitulo'
        }
    }
});