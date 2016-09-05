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
    		},
    		// Referente a la cabecera de datos publicacion. Campo calculado con datos de este modelo.
    		{
    			name: 'estadoDisponibilidadComercial',
				calculate: function(data){
					if(data.ruina || data.pendienteInscripcion || data.obraNuevaSinDeclarar || data.sinTomaPosesionInicial
							|| data.proindiviso || data.obraNuevaEnConstruccion || data.ocupadoConTitulo || data.tapiado
							|| data.ocupadoSinTitulo || data.divHorizontalNoInscrita || !Ext.isEmpty(data.otro)){
						return true;
					}
				}
    		}

    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getCondicionantesDisponibilidad',
            update: 'activo/saveCondicionantesDisponibilidad',
            create: 'activo/saveCondicionantesDisponibilidad',
            destroy: 'activo/getCondicionantesDisponibilidad'
        }
    }
});