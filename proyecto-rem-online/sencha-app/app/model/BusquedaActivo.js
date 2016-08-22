/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.BusquedaActivo', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',    
    

    fields: [    
  
    		{
    			name:'numeroActivo'
    		},
    		{
    			name:'numActivo'
    		},
    		{
    			name: 'tipoActivo',
    			reference: 'HreRem.model.DDBase'
    		},
    		{
    			name: 'subtipoActivo',
    			reference: 'HreRem.model.DDBase'
    		},
    		{
    			name:'tipoTituloActivo',
    			reference: 'HreRem.model.DDBase'
    		},
    		{
    			name:'entidadPropietaria',
    			reference: 'HreRem.model.DDBase'
    		},
    		{
    			name:'provincia',
    			reference: 'HreRem.model.DDBase'
    		},
    		{
				name:'localidad',
    			reference: 'HreRem.model.DDBase'
    		},
    		{
    			name:'tipoVia',
    			reference: 'HreRem.model.DDBase'
    		},
    		{
    			name: 'via',
    			calculate: function(data) {
	            	return Ext.isEmpty(data.tipoVia) ? data.nombreVia : Ext.util.Format.capitalize(data.tipoVia.descripcion.toLowerCase()) + " " + data.nombreVia;
		        }
    			
    		},
    		{
    			name: 'nombreVia'
    		},
    		{
    			name:'propietario'
    		},
    		{
    			name:'tokenGmaps'
    		},
    		{
    			name:'idufir'
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
    			name: 'situacionComercial'
    		},
    		{
    			name: 'latitud',
    			type: 'number'
    		},
    		{
    			name: 'longitud',
    			type: 'number'
    		}
    		
        
        
    ] 
    

});