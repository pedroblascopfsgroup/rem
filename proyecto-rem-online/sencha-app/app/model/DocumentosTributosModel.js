Ext.define('HreRem.model.DocumentosTributosModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'id'
    		},
    		{
    			name:'nombre'
    		},
    		{
    			name:'descripcionTipo'
    		},
    		{
    			name:'descripcion'
    		},
    		{
    			name:'createDate',
               	type: 'date',
        		dateFormat: 'c'
    		},
    		{
    			name:'tamanyo'
    		},
    		{
    			name:'gestor'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		localUrl: 'adjuntos.json',
		remoteUrl: 'activo/getDocumentoTributoById',
		api: {
            read: 'activo/getDocumentosTributo',
            create: 'activo/createDocumentosTributos',
            update: 'activo/updateDocumentosTributos',
            destroy: 'activo/destroyDocumentosTributos'
        }
    }
});