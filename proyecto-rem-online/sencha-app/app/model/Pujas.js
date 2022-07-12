/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.Pujas', {
    extend: 'HreRem.model.Base',
	idProperty: 'id',
	
    fields: [ 
    	{
	    	name: 'id'
	    },
	    {
	    	name: 'idActivo'
	    },
		{
	    	name: 'idOferta'
	    },
	    {
	    	name: 'idConcurrencia'
	    },
	    {
   			name: 'enConcurrencia'
   		},
    	{	
    		name: 'importePuja',
			calculate: function(data) {
				if(!$AU.userIsRol(CONST.PERFILES['HAYASUPER']) && data.enConcurrencia){
					return "*****";
				}else{
					return data.importePuja;
				}
			},
			depends: 'enConcurrencia'
    	},
   		{
   			name: 'fechaCrear',
			type: 'date',
			dateFormat: 'c'
   		}
	
    ]/*,
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getPujasDetalleByIdOferta',
		api: {}
    }*/

});