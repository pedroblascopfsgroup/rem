Ext.define('HreRem.model.BusquedaActivoGrid', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',    
    

    fields: [    
      		
    // Datos Grid
    		{
    			name:'numActivo'
    		},
    		{
    			name: 'tipoActivoDescripcion'		
    		},
    		{
    			name: 'subtipoActivoDescripcion' 		
    		},
    		{
    			name:'tipoTituloActivoDescripcion'    		
    		},
    		{
    			name:'carteraDescripcion'    			
    		},
    		{
    			name:'provinciaDescripcion'    			
    		},
    		{
				name:'localidadDescripcion'    			
    		},
    		{
    			name:'tipoViaDescripcion'    			
    		},
    		{
    			name: 'via',
    			calculate: function(data) {
	            	return Ext.isEmpty(data.tipoViaDescripcion) ? data.nombreVia : Ext.util.Format.capitalize(data.tipoViaDescripcion.toLowerCase()) + " " + data.nombreVia;
		        }    			
    		},
    		{
    			name: 'nombreVia'
    		},    			
    		{
    			name: 'codPostal'
    		},    	
    		{
    			name: 'admision',
    			type: 'boolean'
    		},
    		{
    			name: 'gestion',
    			type: 'boolean'    			
    		},
    		{
    			name: 'selloCalidad',
    			type: 'boolean'    			
    		},
    		{
    			name: 'flagRatingCodigo'
    		},
    		{
    			name: 'situacionComercialDescripcion'
    		},
    		{
    			name: 'latitud',
    			type: 'number'
    		},
    		{
    			name: 'longitud',
    			type: 'number'
    		},
    		{
    			name:'tokenGmaps'
    		},
    // Datos buscador
    		{
    			name:'carteraCodigo'
    		},
    		{
    			name:'subcarteraCodigo'
    		},
    		{
    			name:'tipoActivoCodigo'
    		},
    		{
          		name:'subtipoActivoCodigo'
        	},
			{
          		name:'provinciaCodigo'
        	},
			{
          		name:'codPromoPrinex'
        	},
			{
          		name:'numFinca'
        	},
			{
          		name:'refCatastral'
        	},
			{
          		name:'numAgrupacion'
        	},
			{
          		name:'numActivoSareb'
        	},
			{
          		name:'numActivoPrinex'
        	},
			{
          		name:'numActivoUvem'
        	},
			{
          		name:'numActivoCaixa'
        	},
			{
          		name:'numActivoDivarian'
        	},
			{
          		name:'numActivoRecovery'
        	},
			{
          		name:'estadoActivoCodigo'
        	},
			{
          		name:'tipoUsoDestinoCodigo'
        	},
			{
          		name:'claseActivoBancarioCodigo'
        	},
			{
          		name:'subclaseActivoBancarioCodigo'
        	},
			{
          		name:'numActivoBbva'
        	},
			{
          		name:'tipoViaCodigo'
        	},
			{
          		name:'provinciaAvanzadaCodigo'
        	},
			{
          		name:'localidadAvanzadaDescripcion'
        	},
			{
          		name:'paisCodigo'
        	},
			{
          		name:'localidadRegistroDescripcion'
        	},
			{
          		name:'numRegistro'
        	},
			{
          		name:'numFincaAvanzada'
        	},
			{
          		name:'idufir'
        	},
			{
          		name:'tipoTituloActivoCodigo'
        	},
			{
          		name:'subtipoTituloActivoCodigo'
        	},
			{
          		name:'divHorizontal',
          		type: 'boolean'    			
        	},
			{	
          		name:'fechaInscripcionReg'          	
        	},
			{
          		name:'carteraAvanzadaCodigo'
        	},
			{
          		name:'subcarteraAvanzadaCodigo'
        	},
			{
          		name:'nombrePropietario'
        	},
			{
        		 name:'docPropietario'
        	},
			{
          		name:'ocupado',
          		type: 'boolean'    			
        	},
			{
          		name:'conTituloCodigo'
        	},
			{ 
          		name:'fechaPosesion'          		
        	},
			{
          		name:'tapiado',
          		type: 'boolean'    		
        	},
			{
          		name:'antiocupa',
          		type: 'boolean' 
        	},
			{
          		name:'tituloPosesorioCodigo'
        	},
			{
          		name:'tipoGestorCodigo'
        	},
			{
          		name:'usuarioGestor'
        	},
			{
          		name:'apiPrimarioId'
        	},			
			{
          		name:'situacionComercialCodigo'
        	},
			{
          		name:'tipoComercializacionCodigo'
        	},
			{
          		name:'conCargas',
          		type: 'boolean' 
        	},
			{
          		name:'estadoComunicacionGencatCodigo'
        	},
			{
          		name:'direccionComercialCodigo'
        	},
			{
          		name:'tipoSegmentoCodigo'
        	},
			{
          		name:'perimetroMacc',
          		type: 'boolean' 
        	},
            {
                name:'equipoGestion'
            },
			{
				name: 'codPromocionBbva'
			}
	    		
    ],
    
    proxy: {
		type: 'uxproxy',		
		remoteUrl: 'activo/getBusquedaActivosGrid',
		api: {
            read: 'activo/getBusquedaActivosGrid'            
        }
    }    

});