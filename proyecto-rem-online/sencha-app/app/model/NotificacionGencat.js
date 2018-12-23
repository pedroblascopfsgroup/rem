Ext.define('HreRem.model.NotificacionGencat', {
    extend: 'HreRem.model.Base',

    fields: [
		
		//Notificacion
		{
			name:'fechaNotificacion',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'motivoNotificacion'
		},
		{
			name:'fechaSancionNotificacion',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'cierreNotificacion',
			type:'date'
		}
		
    ]

});