/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.ActivoTrabajoSubida', {
    extend: 'HreRem.model.Base',
    idProperty: 'idActivo',
	
    fields: [    
     		{
    			name:'numActivoHaya'
    		},
		    {
		    	name: 'numActivoRem'
		    },
    		{
    			name:'idActivo'
    		},
    		{
    			name:'cartera'
    		},
			{
    			name:'codigoCartera'
    		},
    		{
    			name:'tipoActivo'
    		},
    		{
    			name:'subtipoActivo'
    		},
    		{
    			name:'situacionComercial'
    		},
    		{
    			name:'numFincaRegistral'
    		},
			{
				name : 'activoEnPropuestaEnTramitacion',
				type: 'boolean'
			},
			{
				name : 'activoTramite',
				type: 'boolean'
			}
//    		,
//    		{
//    			name: 'situacionPosesoria',
//    			calculate: function (data) {
//         				
//     				if(data.situacionPosesoriaOcupado == 0) {
//     					return "Desocupado"
//     				} else if(data.situacionPosesoriaOcupado == 1 && data.situacionPosesoriaTitulo == 0) {
//     					return "Ocupado sin titulo"
//     				} else if(data.situacionPosesoriaOcupado == 1 && data.situacionPosesoriaTitulo == 1) {
//     					return "Ocupado con titulo"
//     				} else {
//     					return "";
//     				}  
//         			
//    			}    			
//    		}
    		
    ]

});