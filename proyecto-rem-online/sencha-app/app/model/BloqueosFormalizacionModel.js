/**
 *  Modelo para el Grid Bloqueos de la tab formalización del expediente.
 */
Ext.define('HreRem.model.BloqueosFormalizacionModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
  
    		{
    			name:'id'
    		},
    		{
    			name: 'areaBloqueoCodigo'
    		},
    		{
    			name: 'tipoBloqueoCodigo'
    		},
    		{
    			name: 'fechaAlta',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'usuarioAlta'
    		},
    		{
    			name: 'fechaBaja',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'usuarioBaja'
    		},
    		{
    			name: 'idActivo'
    		},
    		{
    			name: 'acuerdoCodigo'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api	: {
			create: 'expedientecomercial/createBloqueoFormalizacion',
			update: 'expedientecomercial/updateBloqueoFormalizacion',
            destroy: 'expedientecomercial/deleteBloqueoFormalizacion'
        }
    }
});