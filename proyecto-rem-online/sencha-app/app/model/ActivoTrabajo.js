/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.ActivoTrabajo', {
    extend: 'HreRem.model.Base',
    idProperty: 'idActivo',
	
    fields: [   

     		{
    			name:'numActivo'
    		},
		    {
		    	name: 'numActivoRem'
		    },
//    		{
//    			name:'activoId'
//    		},
    		{
    			name:'idActivo'
    		},
    		{
    			name:'idTrabajo'
    		},
    		{
    			name:'tienePerimetroGestion'
    		},
    		{
    			name:'subtipoActivoDescripcion'
    		},
    		{
    			name:'tipoActivoDescripcion'
    		},
    		{
    			name:'entidadPropietariaDescripcion'
    		},
    		{
    			name: 'localidadDescripcion'
    		},
    		{
    			name: 'provinciaDescripcion'
    		},
    		{
    			name: 'direccion'
    		},
    		{
    			name: 'situacionComercial'
    		},
    		{
    			name: 'situacionPosesoria',
    			calculate: function (data) {
         				
     				if(data.situacionPosesoriaOcupado == 0) {
     					return "Desocupado"
     				} else if(data.situacionPosesoriaOcupado == 1 && data.situacionPosesoriaTitulo == 0) {
     					return "Ocupado sin titulo"
     				} else if(data.situacionPosesoriaOcupado == 1 && data.situacionPosesoriaTitulo == 1) {
     					return "Ocupado con titulo"
     				} else {
     					return "";
     				}  
         			
    			}    			
    		},
    		{
    			name: 'situacionPosesoriaOcupado'
    		},
    		{
    			name: 'situacionPosesoriaTitulo'
    		},
    		{
    			name: 'limitePresupuesto'
    		},
            {
                name: 'saldoDisponible'
            },
    		{
    			name: 'participacion',
    			type: 'float'
    			
    		},
    		{
    			name: 'importeParticipa',
                type: 'float'
    		},
    		{
    			name: 'saldoNecesario'
    		},
    		{
    			name: 'sumaAgrupacionNetoContable'
    		},
    		{
    			name: 'importeNetoContable'
    		},
    		{
    			name: 'participacionCalculada',
    			type: 'float',
    			calculate: function (data) {
    				return data.importeNetoContable / data.sumaAgrupacionNetoContable * 100
    			}
    			
    		},
    		{
    			name: 'descripcionEstado'
    		},
    		{
    			name: 'utlimoTrabajo'
    		},
    		{
    			name: 'fecha'
    		}
    		
    ],
    
    
	proxy: {
		type: 'uxproxy',
		api: {
            update: 'trabajo/saveActivoTrabajo'
        }
    }

});