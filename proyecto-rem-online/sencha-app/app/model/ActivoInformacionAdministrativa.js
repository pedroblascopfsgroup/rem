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