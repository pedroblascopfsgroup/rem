Ext.define('HreRem.model.ActivoSaneamiento', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
		{
			name:'idActivo'
		},
		{
			name:'numeroActivo'
		},
		{
			name:'gestoriaAsignada'
		},
		{
			name:'fechaAsignacion',
			type:'date',
			dateFormat: 'c'
		},
		//Cargas
		{
			name:'conCargas'
		},
		{
			name:'estadoCargas'
		},
		{
			name:'fechaRevisionCarga',
			type:'date',
			dateFormat: 'c'
		},
		{
			name: 'unidadAlquilable',
			type: 'boolean'
		},
		//Proteccion Oficial
		{
			name:'vpo'
		},
		{
			name:'tipoVpoId'
		},
		{
			name:'tipoVpoCodigo'
		},
		{
			name:'tipoVpoDescripcion'
		},
		{
			name:'vigencia',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'comunicarAdquisicion'
		},
		{
			name:'necesarioInscribirVpo'
		},
		{
			name:'libertadCesion'
		},
		{
			name:'renunciaTanteoRetrac'
		},
		{
			name:'visaContratoPriv'
		},
		{
			name:'venderPersonaJuridica'
		},
		{
			name:'minusvalia'
		},
		{
			name:'inscripcionRegistroDemVpo'
		},
		{
			name:'ingresosInfNivel'
		},
		{
			name:'residenciaComAutonoma'
		},
		{
			name:'noTitularOtraVivienda'
		},
		{
			name:'sueloVpo'
		},
		{
			name:'promocionVpo'
		},
		{
			name:'numExpediente'
		},
		{
			name:'fechaCalificacion',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'obligatorioSolDevAyuda'
		},
		{
			name:'obligatorioAutAdmVenta'
		},
		{
			name:'descalificado'
		},
		{
			name:'sujetoAExpediente'
		},
		{
			name:'organismoExpropiante'
		},
		{
			name:'fechaInicioExpediente',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'refExpedienteAdmin'
		},
		{
			name:'refExpedienteInterno'
		},
		{
			name:'observacionesExpropiacion'
		},
		{
			name:'maxPrecioVenta'
		},
		{
			name:'observaciones'
		}
    ],

    proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getTabActivo',

		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveActivoSaneamiento',
            update: 'activo/saveActivoSaneamiento',
            destroy: 'activo/getTabActivo'
        },
        extraParams: {tab: 'saneamiento'}
    }

});