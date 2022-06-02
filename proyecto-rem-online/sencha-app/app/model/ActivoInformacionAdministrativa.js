/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.ActivoInformacionAdministrativa', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
     		{
    			name:'numActivo'
    		},
    		{
    			name:'numActivoRem'
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
    			name:'tipoCalificacionCodigo'
    		},
    		{
    			name:'tipoCalificacionDescripcion'
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
    			name:'tipoVpoDescripcionLarga'
    		},
    		// Informacion relacionada con VPO
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
    			name:'tributacionAdq'
    		},
			{
    			name:'tributacionAdqDescripcion'
    		},
    		{
				name:'fechaVencTpoBonificacion',
				type:'date',
    			dateFormat: 'c'
			},
			{
    			name:'fechaSoliCertificado',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaComAdquisicion', 
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaLiqComplementaria',
    			type:'date',
    			dateFormat: 'c'
			},
			{
    			name:'fechaComRegDemandantes', //
    			type:'date',
    			dateFormat: 'c'
    		},
    		
    		{
    			name:'fechaEnvioComunicacionOrganismo', //
    			type:'date',
    			dateFormat: 'c'
    		},
    		
    		{
    			name:'fechaRecepcionRespuestaOrganismo', //
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaVencimiento',
    			type: 'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'estadoVentaCodigo'
    		},
			{
    			name:'estadoVentaDesripcion'
    		},
    		{
    			name:'maxPrecioModuloAlquiler'
    		},
    		{
    			name:'compradorAcojeAyuda',
    			type: 'boolean'
    		},
    		{
    			name:'importeAyudaFinanciacion'
    		},
    		{
    			name:'fechaVencimientoAvalSeguro',
    			type: 'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaDevolucionAyuda',
    			type: 'date',
    			dateFormat: 'c'
    		},
    		

    		
    		
    		{
    			name:'vpo',
    			convert: function(value) {
    				if (!Ext.isEmpty(value)) {
						if  (value == 1 || value == '01') {
	    					return true;
	    				} else {
	    					return false;
	    				}			
	    			}
    			}
    		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getTabActivo',
		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveActivoInformacionAdministrativa',
            update: 'activo/saveActivoInformacionAdministrativa',
            destroy: 'activo/getTabActivo'
        },
		extraParams: {tab: 'infoadministrativa'}
    }
    
    

});