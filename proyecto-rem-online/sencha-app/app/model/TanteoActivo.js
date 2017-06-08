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
    			name: 'fechaComunicacion'
    		},
    		{
    			name: 'fechaRespuesta'
    		},
    		{
    			name:'numeroExpediente'
    		},
    		{
    			name: 'solicitaVisita'
    		},
    		{
    			name: 'fechaFinTanteo'
    		},
    		{
    			name:'codigoTipoResolucion'
    		},
    		{
    			name: 'fechaVencimiento'
    		},
    		{
    			name: 'fechaVisita'
    		},
    		{
    			name: 'fechaResolucion'
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