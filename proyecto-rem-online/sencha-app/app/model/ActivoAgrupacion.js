/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.ActivoAgrupacion', {
    extend: 'HreRem.model.Base',
  //  idProperty: 'id',

    fields: [    
      
     		{
    			name:'numActivo'
    		},
    		{
    			name:'numActivoRem'
    		},
    		{
    			name:'activoId'
    		},
    		{
    			name:'tipoActivoDescripcion'
    		},
    		{
    			name:'subtipoActivo'
    		},
    		{
    			name:'agrId'
    		},
    		{
    			name:'superficieConstruida',
    			type:'float'
    		},
    		{
    			name:'importePublicacion',
    			type:'float'
    		},
    		{
    			name:'importePropVenta',
    			type:'float'
    		},
    		{
    			name:'activoPrincipal'
    		},
    		{
    			name:'subdivision'
    		},
    		{
    			name:'direccion'
    		},
    		{
    			name:'numFinca'
    		},
    		{
    			name:'puerta'
    		},
    		{
    			name:'tieneTipoAlquiler'
    		}
    		
    		
    ],
    
	proxy: {
		type: 'uxproxy',

		api: {
            read: 'agrupacion/getListActivosAgrupacionById',
            create: 'agrupacion/createActivoAgrupacion',
            destroy: 'agrupacion/deleteActivoAgrupacion'
        }

    }    

});