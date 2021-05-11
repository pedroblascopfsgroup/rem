Ext.define('HreRem.model.SituacionOcupacionalGridModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
			{
				name:'id'
			},
    		{
    			name:'ocupado'
    		},
    		{
    			name:'conTitulo'
    		},
    		{
                name:'fechaAlta',
                type:'date',
                dateFormat: 'c'
    		},
    		{
    			name:'horaAlta'
    		},
    		{
    			name:'usuarioAlta'
    		},
    		{
    			name:'lugarModificacion'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		localUrl: 'admision.json',
		api: {}
    }
});