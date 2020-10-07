Ext.define('HreRem.model.ActivoAlquiladosGrid', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
			{
				name: 'numActivo'  
			},
			{
				name: 'subTipoActivo'  
			},
			{
				name: 'municipio'  
			},
			{
				name: 'direccion'  
			},
			{
				name: 'rentaMensual'  
			},
			{
				name: 'deudaActual'  
			},
			{
				name: 'conDeudas'
			},
			{
				name: 'inquilino'
			},
			{
				name: 'ofertante'
			},
			{
				name: 'fechaFinContrato',
				type: 'date',
    			dateFormat: 'c'
			},
			{
				name: 'estadoExpediente'
			}
    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'condicionesExpediente.json',
		remoteUrl: 'expedientecomercial/getActivosAlquilados',
		api: {
			update: 'expedientecomercial/updateActivosAlquilados',
            read: 'expedientecomercial/getActivosAlquilados'
        }
    }  
});
          