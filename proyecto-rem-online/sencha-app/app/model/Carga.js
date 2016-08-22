/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.Carga', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
     		{
    			name:'numActivo'
    		},
    		{
    			name:'numActivoRem'
    		},
    		{
    			name:'titular'
    		},
    		{
    			name:'estadoDescripcion'
    		},
    		{
    			name:'estadoEconomicaDescripcion'
    		},
    		{
    			name:'importeEconomico'
    		},
    		{
    			name:'importeRegistral'
    		},
    		{
    			name:'tipoCargaActivoDescripcion'
    		},
    		{
    			name:'subtipoCargaActivoDescripcion'
    		}
    		/*,
    		{
		        reference: 'ActivoCargas' // the entityName for MyApp.model.User
    		}*/
    		
    ]

});