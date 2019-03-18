/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.GestionEconomicaTrabajo', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    
    /**
     * Al crear un registro se genera como id un número negativo y no un String 
     */
    //identifier: 'negative',

    fields: [ 
    		
		    {
		    	name: 'idTrabajo'
		    },
		    {
		    	name: 'idActivo'
		    },
		    {
		    	name: 'idAgrupacion'
		    },      
    		{
    			name: 'numTrabajo'
    		},
    		{
    			name: 'tipoTrabajoCodigo'
    		},
    		{
    			name: 'subtipoTrabajoCodigo'
    		},
    		{
    			name: 'carteraCodigo'
    		},
    		{
    			name: 'subcarteraCodigo'
    		},
    		{
    			name: 'esTarificado',
    		    convert: function (value) {
   		         	return Ext.isEmpty(value) ? null : value === "true";
    		    }    		
    		},
    		{
    			name: 'fechaCompromisoEjecucion',
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
    			name: 'fechaEjecucionReal',
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
    			name: 'fechaFin',
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
    			name: 'diasRetrasoOrigen'
    		},
    		{
    			name: 'diasRetrasoMesCurso'
    		},
    		{
    			name: 'importePenalizacionDiario'  			
    		},
    		{
    			name: 'importePenalizacionTotal',
    			calculate: function (data) {
     				if(data.importePenalizacionDiario != 0 && data.diasRetrasoOrigen != 0) {
     					return data.importePenalizacionDiario * data.diasRetrasoOrigen;
     				}
     				else
     				{
     					return 0;
     				}
     				
    			}  
    		},
    		{
    			name: 'importePenalizacionMesCurso',
    			calculate: function (data) {
     				if(data.importePenalizacionDiario != 0 && data.diasRetrasoMesCurso != 0) {
     					return data.importePenalizacionDiario * data.diasRetrasoMesCurso;
     				}
     				else
     				{
     					return 0;
     				}
    			}  
    		},
    		{
    			name: 'idProveedor'
    		},
    		{
    			name: 'nombreProveedor'
    		},
    		{
    			name: 'usuarioProveedorContacto',
				convert: function(value){
    				if(Ext.isEmpty(value)){
    					return '____';
    				}else{
    					return value;
    				}
    			}
    		},
    		{
    			name: 'emailProveedorContacto'
    		},
    		{
    			name: 'telefonoProveedorContacto'
    		},
    		{
    			name: 'importeTotal'
    		},
    		{
    			name: 'idProveedorContacto'
    		},
    		{
    			name: 'codigoTipoProveedor'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'trabajo.json',
		remoteUrl: 'trabajo/getTrabajoById',

		api: {
            read: 'trabajo/findOne',
            create: 'trabajo/create',
            update: 'trabajo/saveGestionEconomicaTrabajo',
            destroy: 'trabajo/findOne'
        },
        extraParams: {pestana: 'gestionEconomica'}
    }    

});