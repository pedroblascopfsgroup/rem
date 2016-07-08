/**
 *  Modelo para el grid de cargas de Activos 
 */
Ext.define('HreRem.model.ActivoCargas', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'id'
    		},
    		{
    			name:'fechaRevision',
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
    			name:'descripcionCarga'
    		},
    		{
    			name:'idCarga'
    		},
    		{
    			name:'titular'
    		},
    		{
    			name:'importeRegistral'
    		},
    		{
    			name:'importeEconomico'
    		},
    		{
    			name:'fechaPresentacion',
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
    			name:'fechaInscripcion',
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
    			name:'fechaCancelacion',
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
    			name:'fechaCancelacionRegistral',
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
    			name:'subtipoCargaCodigo'
    		},
    		{
    			name:'subtipoCargaDesc'
    		},    		
    		{
    			name:'situacionCargaCodigo'
    		},
    		{
    			name:'subtipoCargaCodigoEconomica'
    		},
    		{
    			name:'subtipoCargaDesconomica'
    		},    		
    		{
    			name:'situacionCargaCodigoEconomica'
    		},
    		{
    			name:'tipoCargaCodigo'
    		},
    		{
    			name:'tipoCargaDesc'
    		},    		
    		{
    			name: 'isCargaRegistral',
    			calculate: function(data) { 
    				return data.tipoCargaCodigo == 'REG';
    			},
    			depends: 'tipoCargaCodigo'
    			
    		},
    		{
    			name: 'isCargaEconomica',
    			calculate: function(data) {
    				return data.tipoCargaCodigoEconomica == 'ECO';
    			},
    			depends: 'tipoCargaCodigoEconomica'			
    		},
    		{
    			name:'tipoCargaCodigoEconomica'
    		},
    		{
    			name:'tipoCargaDescEconomica'
    		},    		
    		{
    			name:'descripcionCargaEconomica'
    		},
    		{
    			name:'titularEconomica'
    		},
    		{
    			name:'importeEconomicoEconomica'
    		},
    		{
    			name:'fechaCancelacionEconomica',
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
    			name:'ordenCarga'
    		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',

		api: {
			read: 'activo/getCargaById',
            create: 'activo/saveActivoCarga',
            update: 'activo/saveActivoCarga'
        }
    }
    
    

});