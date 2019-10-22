Ext.define('HreRem.model.ListaActivoGrid', {
    extend: 'HreRem.model.Base',
    idProperty: 'idActivo',

    fields: [
    		{
    			name:'descripcion'
    		},
    		{
    			name:'pais'
    		},
    		{
    			name:'provincia'
    		},
    		{
    			name:'direccion'
    		},
    		{
    			name:'numActivo'
    		},
    		{
    			name:'municipio'
    		},
    		{
    			name:'fincaRegistral'
    		},
    		{
    			name:'tipoActivo'
    		},
    		{
    			name:'subtipoActivo'
    		},
    		{
    			name:'activoId'
    		}
    ],

	proxy: {
		type: 'uxproxy'
    }
});

