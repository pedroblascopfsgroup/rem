Ext.define('HreRem.model.ActivoCondicionantesDisponibilidad', {
    extend: 'HreRem.model.Base',
    idProperty: 'idActivo',

    fields: [    
    		{
    			name:'ruina',
    			type: 'boolean'
    		},
    		{
    			name:'pendienteInscripcion',
    			type: 'boolean'
    		},
    		{
    			name:'obraNuevaSinDeclarar',
    			type: 'boolean'
    		},
    		{
    			name:'sinTomaPosesionInicial',
    			type: 'boolean'
    		},
    		{
    			name:'proindiviso',
    			type: 'boolean'
    		},
    		{
    			name:'obraNuevaEnConstruccion',
    			type: 'boolean'
    		},
    		{
    			name:'ocupadoConTitulo',
    			type: 'boolean'
    		},
    		{
    			name:'tapiado',
    			type: 'boolean'
    		},
    		{
    			name:'otro'
    		},
    		{
    			name: 'portalesExternos',
    			type: 'boolean'
    		},
    		{
    			name: 'portalesExternosDescripcion',
				calculate: function(data){
					if(data.portalesExternos){
						return HreRem.i18n('fieldlabel.estado.portal.externo.publicado');
					} else {
						return HreRem.i18n('fieldlabel.estado.portal.externo.no.publicado');
					}
				},
				depends: 'portalesExternos'
    		},
    		{
    			name:'ocupadoSinTitulo',
    			type: 'boolean'
    		},
    		{
    			name:'divHorizontalNoInscrita',
    			type: 'boolean'
    		},
    		// Referente a la cabecera de datos publicacion. Campo calculado con datos de este modelo.
    		{
    			name: 'estadoDisponibilidadComercial',
				calculate: function(data){
					if(data.ruina || data.pendienteInscripcion || data.obraNuevaSinDeclarar || data.sinTomaPosesionInicial
							|| data.proindiviso || data.obraNuevaEnConstruccion || data.ocupadoConTitulo || data.tapiado
							|| data.ocupadoSinTitulo || data.divHorizontalNoInscrita || !Ext.isEmpty(data.otro)){
						return true;
					} else {
						return false;
					}
				}
    		}

    ],
    
	proxy: {
		type: 'uxproxy',
		writeAll: true,
		api: {
            read: 'activo/getCondicionantesDisponibilidad',
            update: 'activo/saveCondicionantesDisponibilidad',
            create: 'activo/saveCondicionantesDisponibilidad',
            destroy: 'activo/getCondicionantesDisponibilidad'
        }
    }
});