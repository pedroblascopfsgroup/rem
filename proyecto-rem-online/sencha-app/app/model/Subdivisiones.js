/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.Subdivisiones', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    	

    	{
    		name: 'agrupacionId'
    	},
    	{
    		name: 'descripcion'	
    	},
    	{
    		name: 'codigoSubtipoActivo'
    	},
    	{
    		name: 'numActivos'
    	},
    	{
    		name: 'dormitorios'
    	},
    	{
    		name: 'plantas'
    	} 	
  

    ] 

});