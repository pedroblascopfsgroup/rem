/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.ActivosAsociados', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'activo',
    			type: 'number'
    		},
    		{
    			name:'descripcion'
    		},
    		{
    			name:'localizacion'
    		},
    		{
    			name: 'idContrato'
    		}
    ]

});