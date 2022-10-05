Ext.define('HreRem.model.FirmaAdendaGrid', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
			{
				name: 'firmado'  
			},
			{
				name: 'fecha',
				type: 'date',
    			dateFormat: 'c'
			},
			{
				name: 'motivo'
			}
    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'condicionesExpediente.json',
		remoteUrl: 'expedientecomercial/getFirmaAdenda',
		api: {
            read: 'expedientecomercial/getFirmaAdenda'
        }
    }  
});
          