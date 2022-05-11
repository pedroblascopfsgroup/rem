/**
 *  Modelo para el grid de cargas de Activos 
 */
Ext.define('HreRem.model.ActivoCargas', {
    extend: 'HreRem.model.Base',

    fields: [    
  
		    {
		    	name: 'idActivo',
		    	critical: true
		    },
    		{
    			name:'fechaRevision',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'descripcionCarga'
    		},
    		{
    			name:'idActivoCarga',
    			critical: true
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
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaInscripcion',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaCancelacion',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaCancelacionRegistral',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'subtipoCargaCodigo'
    		},
    		{
    			name:'subtipoCargaDescripcion'
    		},    		
    		{
    			name:'situacionCargaCodigo'
    		},
    		{
    			name:'subtipoCargaCodigoEconomica'
    		},
    		{
    			name:'subtipoCargaDescripcionEconomica'
    		},    		
    		{
    			name:'situacionCargaCodigoEconomica'
    		},
    		{
    			name:'tipoCargaCodigo'
    		},
    		{
    			name:'tipoCargaDescripcion'
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
    			name:'tipoCargaDescripcionEconomica'
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
    			type: 'date',
    			dateFormat: 'c'
    			
    		},
    		{
    			name:'ordenCarga'
    		},
    		{
    			name: 'origenDatoCodigo',
    			convert: function(value){
    				if(value == null || value == ''){
    					return '01';
    				}
    				return value;
    			}
    		},
    		{
    			name: 'origenDatoDescripcion',
    			convert: function(value){
    				if(value == null || value == ''){
    					return 'REM';
    				}
    				return value;
    			}
    		},{
    			name: 'cargasPropias'
    		},
    		{
    			name:'fechaSolicitudCarta',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaRecepcionCarta',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaPresentacionRpCarta',
    			type:'date',
    			dateFormat: 'c'
    				
    		},
    		{
    			name:'indicadorPreferente',
    			type: 'boolean'
    			
    		},
    		{
    			name:'identificadorCargaEjecutada',
    			type: 'boolean'
    			
    		},
    		{
    			name:'igualdadRango',
    			type: 'boolean'
    			
    		},
    		{
    			name:'identificadorCargaIndefinida',
    			type: 'boolean'
    			
    		},
    		{
    			name:'identificadorCargaEconomica',
    			type: 'boolean'
    			
    		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',

		api: {
			read: 'activo/getCargaById',
            create: 'activo/saveActivoCarga',
            update: 'activo/saveActivoCarga',
            destroy: 'activo/deleteCarga'
        }
    }
    
    

});