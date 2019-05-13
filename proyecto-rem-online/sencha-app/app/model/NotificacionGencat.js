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
			reference: 'fechaSancionNotificacion',
			dateFormat: 'c'
		},
		{
			name:'cierreNotificacion',
			type:'date'
		},
		{
			name: 'fileUpload',
			xtype: 'filefield'
		},
		{
			name: 'tipo',
			xtype: 'combobox'
		},
		{
			name: 'descripcion',
			xtype: 'textarea'
		},
		{
			name:'id'
		},
		{
			name:'idHComunicacion'
		}
    ]
});