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
    		{
    			name: 'isCondicionado',
    			type: 'boolean'
    		},
    		// Referente a la cabecera de datos publicacion. Campo calculado con datos de este modelo.
    		{
    			name: 'estadoCondicionadoCodigo'
    		},
    		{
    			name: 'sinInformeAprobado',
    			type: 'boolean'
    		},
    		{
    			name: 'vandalizado',
    			type: 'boolean'
    		},
    		{
    			name: 'conCargas',
    			type: 'boolean'
    		},
    		{
    			name: 'sinAcceso',
    			type: 'boolean'
    		}

    ],
    
	proxy: {
		type: 'uxproxy',
		extraParams:{
			tab: 'activocondicionantesdisponibilidad'
		},
		api: {
			read: 'activo/getTabActivo',
            update: 'activo/saveCondicionantesDisponibilidad',
            create: 'activo/saveCondicionantesDisponibilidad',
            destroy: 'activo/getCondicionantesDisponibilidad'
        }
    }
});