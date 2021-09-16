/**
 * This view is used to present the details of a single Expediente Comercial.
 */
Ext.define('HreRem.model.DatosBasicosOferta', {
    extend: 'HreRem.model.Base',
    alias: 'viewmodel.datosBasicosOferta',

    fields: [

		    {
		    	name: 'idOferta'
		    },
		    {
    			name:'numOferta'
    		},
    		{
    			name:'tipoOfertaDescripcion'
    		},
    		{
    			name:'tipoOfertaCodigo'
    		},
    		{
    			name:'fechaNotificacion',
    			convert: function(value) {
    				if (!Ext.isEmpty(value)) {
						if  ((typeof value) == 'string') {
	    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
	    				} else {
	    					return value;
	    				}
    				}
    			}
    		},
    		{
    			name:'fechaAlta',
    			convert: function(value) {
    				if (!Ext.isEmpty(value)) {
						if  ((typeof value) == 'string') {
	    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
	    				} else {
	    					return value;
	    				}
    				}
    			}
    		},
    		{
    			name:'estadoDescripcion'
    		},
    		{
    			name:'prescriptor'
    		},
    		{
    			name:'importeOferta'
    		},
    		{
    			name:'importeContraOferta'
    		},
    		{
    			name:'comite'
    		},
    		{
    			name:'numVisita'
    		},
    		{
    			name: 'estadoVisitaOfertaCodigo'
    		},
    		{
    			name:'estadoVisitaOfertaDescripcion'
    		},
    		{
    			name: 'canalPrescripcionCodigo'
    		},
    		{
    			name: 'canalPrescripcionDescripcion'
    		},
    		{
    			name: 'comiteSeleccionadoCodigo'
    		},
    		{
    			name: 'comitePropuestoCodigo'
    		},
    		{
    			name: 'ventaCartera'
    		},
    		{
    			name: 'exclusionBulk'
    		},
    		{
    			name: 'isAdvisoryNoteEnTareas'
    		},
    		{
    			name: 'tareaAdvisoryNoteFinalizada'
    		},
    		{
    			name: 'tareaAutorizacionPropiedadFinalizada'
    		},
    		{
    			name:'idAdvisoryNote'
    		},
    		{
    			name:'tipoBulkAdvisoryNote'
    		},
     		{
			name:'fechaRespuestaCES',
			convert: function(value) {
    				if (!Ext.isEmpty(value)) {
						if  ((typeof value) == 'string') {
	    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
	    				} else {
	    					return value;
	    				}
    				}
    			}
    		},
    		{
			name:'fechaRespuesta',
			convert: function(value) {
    				if (!Ext.isEmpty(value)) {
						if  ((typeof value) == 'string') {
	    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
	    				} else {
	    					return value;
	    				}
    				}
    			}
    		},
    		{
    			name: 'isCarteraCerberusApple',
    			type: 'boolean'
     		},
    		{
    			name: 'tipoAlquilerCodigo'
    		},
    		{
    			name: 'tipoInquilinoCodigo'
    		},
    		{
    			name: 'numContratoPrinex'
    		},
    		{
    			name: 'refCircuitoCliente'
    		},
    		{
    			name: 'comiteSancionadorCodigoAlquiler'
    		},
    		{
    			name:'necesitaFinanciacion'
    		},
    		{
    			name:'estadoAprobadoLbk'
    		},
    		{
    			name: 'permiteProponer',
    			convert: function(value) {
    				if (!Ext.isEmpty(value)) {
						if  ((typeof value) == 'string') {
	    					if(value == "true"){
	    						return true;
	    					}else{
	    						return false;
	    					}
	    				} else {
	    					return value;
	    				}
    				}
    			}
    		},
    		{
    			name:'idEco'
    		},
    		{
    			name:'idGestorComercialPrescriptor'
        	},
    		{
    			name:'importeContraofertaCES'
    		},
    		{
    			name:'fechaResolucionCES',
    			convert: function(value) {
    				if (!Ext.isEmpty(value)) {
						if  ((typeof value) == 'string') {
	    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
	    				} else {
	    					return value;
	    				}
    				}
    			}
    		},
    		{
    			name:'numOferPrincipal'	
    		},
    		{
    			name: 'isCarteraLbkVenta',
    			type: 'boolean'
     		},
    		{
    			name: 'isLbkOfertaComercialPrincipal',
    			type: 'boolean'
     		},
    		{
    			name: 'muestraOfertaComercial',
    			type: 'boolean'
     		},
    		{
    			name:'importeTotal'	
    		},
    		{
    			name:'nuevoNumOferPrincipal'	
    		},
    		{
    			name:'claseOfertaCodigo'	
    		},
    		{
    			name:'importeContraofertaOfertanteCES'
    		},
    		{
    			name:'ofertaSingular'
    		},
    		{
    			name:'correoGestorBackoffice'
    		},
    		{
    			name:'tipoResponsableCodigo'
    		},
    		{
    			name: 'isEmpleadoCaixa',
    			type: 'boolean'
    		},
    		{
                name: 'tieneInterlocutoresNoEnviados',
                type: 'boolean'
            },
    		{
    			name:'ofertaEspecial',
    			type: 'boolean'
    		},
    		{
    			name:'ventaSobrePlano',
    			type: 'boolean'
    		},
    		{
    			name:'riesgoOperacionCodigo'
    		},
    		{
    			name:'riesgoOperacionDescripcion'
    		},
    		{
    			name:'ventaCarteraCfv',
    			type: 'boolean'
    		},
    		{
    			name:'opcionACompra',
    			type: 'boolean'
    		},
    		{
    			name:'valorCompra'
    		},
    		{
    			name:'fechaVencimientoOpcionCompra',
    			type:'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'clasificacionCodigo'
    		},
    		{
    			name:'checkListDocumentalCompleto',
    			type: 'boolean'
    		},
    		{
    			name:'checkSubasta',
    			type: 'boolean'
    		},
    		{
    			name: 'numeroContacto'
    		},
    		{
    			name: 'canalDistribucionBc'
    		}
    		
    ],

	proxy: {
		type: 'uxproxy',
		localUrl: 'expedienteComercial.json',

		api: {
            read: 'expedientecomercial/getTabExpediente',
            update: 'expedientecomercial/saveDatosBasicosOferta'
        },

        extraParams: {tab: 'datosbasicosoferta'}
    }

});
