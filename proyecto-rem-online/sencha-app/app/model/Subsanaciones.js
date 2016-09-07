/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.Subsanacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'idSubsanacion'
    		},
    		{
    			name:'estado'
    		},
    		{
    			name: 'peticionario'
    		},
    		{
    			name: 'motivo'
    		},
    		{
    			name: 'fechaPeticion',
    			type : 'date',
				dateFormat: 'c'
    		},
    		{
    			name: 'gastosSubsanacion'
    		},
    		{
    			name: 'gastosInscripcion'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		writeAll: true,
		localUrl: 'subsanacion.json',
		api: {
            
        }
    }

});