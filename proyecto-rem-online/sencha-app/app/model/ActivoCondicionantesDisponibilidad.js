/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.ActivoCondicionantesDisponibilidad', {
    extend: 'HreRem.model.Base',
    idProperty: 'idActivo',

    fields: [    
    		{
    			name:'ruina'
    		},
    		{
    			name:'pendienteInscripcion'
    		},
    		{
    			name:'obraNuevaSinDeclarar'
    		},
    		{
    			name:'sinTomaPosesionInicial'
    		},
    		{
    			name:'proindiviso'
    		},
    		{
    			name:'obraNuevaEnConstruccion'
    		},
    		{
    			name:'ocupadoConTitulo'
    		},
    		{
    			name:'tapiado'
    		},
    		{
    			name:'otro'
    		},
    		{
    			name:'ocupadoSinTitulo'
    		},
    		{
    			name:'divHorizontalNoInscrita'
    		}

    ],
    
	proxy: {
		type: 'uxproxy',
		remoteUrl: 'activo/getCondicionantesDisponibilidad',
		api: {
            read: 'activo/getCondicionantesDisponibilidad',
            create: 'activo/getCondicionantesDisponibilidad',
            update: 'activo/getCondicionantesDisponibilidad',
            destroy: 'activo/getCondicionantesDisponibilidad'
        }
//		,
//		extraParams: {pestana: '2'}
    }
    
    

});