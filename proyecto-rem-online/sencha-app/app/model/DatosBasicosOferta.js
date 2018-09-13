/**
 * This view is used to present the details of a single Expediente Comercial.
 */
Ext.define('HreRem.model.DatosBasicosOferta', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

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