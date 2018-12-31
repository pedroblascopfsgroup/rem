/**
 * This view is used to present the details of a single Agrupacion-Activo.
 */
Ext.define('HreRem.model.ActivoAgrupacionActivo', {
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
    			name:'subtipoActivoDescripcion'
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
    			name:'estadoSituacionComercial',
    			type: 'boolean'
    		},
    		{
    			name:'condPublVenta'
    		},
    		{
    			name: 'estadoAlquiler'
    		},
    		{
    			name: 'activoGencat'
    		},
    		{
    			name: 'condPublAlquiler'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',

		api: {
            create: 'agrupacion/createActivoAgrupacion',
            destroy: 'agrupacion/deleteOneActivoAgrupacionActivo'
        }

    }    

});