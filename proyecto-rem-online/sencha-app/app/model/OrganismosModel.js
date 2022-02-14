/**
 * This view is used to present the details of a single AdmisionDocumento.
 */
Ext.define('HreRem.model.Organismos', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    reference: 'organismosModel',

    fields: [   
    		
    	{
			name: 'idOrganismo'
		},
		{
			name: 'organismo'
		},
		{
			name: 'organismoDesc'
		},
		{
			name: 'comunidadAutonoma'
		},
		{
			name: 'comunidadAutonomaDesc'
		},
		{
			name: 'fechaOrganismo',
			type:'date',
			dateFormat: 'c'
		},
		{
			name: 'tipoActuacion'
		},
		{
			name: 'tipoActuacionDesc'
		},
		{
			name: 'gestorOrganismo'
		}
    ],
    
    proxy: {
		type: 'uxproxy',		
		writeAll: true,
		api: {
            create: 'activo/saveOrganismo',
            update: 'activo/saveOrganismo',
            destroy: 'activo/deleteOrganismoById'
        }

    } 

});