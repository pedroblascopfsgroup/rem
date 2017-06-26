/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.TanteoActivo', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'id'
    		},
    		{
    			name:'idActivo'
    		},
    		{
    			name:'ecoId'
    		},
    		{
    			name:'codigoTipoAdministracion'
    		},
    		{
    			name:'descTipoAdministracion'
    		},
    		{
    			name: 'fechaComunicacion',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaRespuesta',
    			type:'date',
    			dateFormat: 'c'
    				
    		},
    		{
    			name:'numeroExpediente'
    		},
    		{
    			name: 'solicitaVisita'
    		},
    		{
    			name: 'solicitaVisitaCodigo'
    		},
    		{
    			name: 'fechaFinTanteo',
    			type:'date',
    			dateFormat: 'c'
    				
    		},
    		{
    			name:'codigoTipoResolucion'
    		},
    		{
    			name: 'fechaVencimiento',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaVisita',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaResolucion',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaSolicitudVisita',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'condiciones'
    		}
    ],
    
	proxy: {
		type: 'uxproxy',
		writeAll: true,
		localUrl: 'tanteoGestionEconomica.json',
		api: {
			create: 'expedientecomercial/saveTanteo',
            update: 'expedientecomercial/saveTanteo',
            destroy: 'expedientecomercial/deleteTanteo'
        }
    }

});