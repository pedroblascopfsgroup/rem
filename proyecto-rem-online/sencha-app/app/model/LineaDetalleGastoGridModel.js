Ext.define('HreRem.model.LineaDetalleGastoGridModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'id'
    		},
    		{
    			name:'subtipoGasto'
    		},
    		{
    			name:'baseSujeta'
    		},
    		{
    			name:'baseNoSujeta'
    		},
    		{
    			name:'recargo'
    		},
    		{
    			name:'tipoRecargo'
    		},
    		{
    			name:'interes'
    		},
    		{
    			name:'costas'
    		},
    		{
    			name:'otros'
    		},
    		{
    			name:'provSupl'
    		},
    		{
    			name:'tipoImpuesto'
    		},
    		{
    			name:'operacionExenta'
    		},
    		{
    			name:'renunciaExenta'
    		},
    		{
    			name:'tipoImpositivo'
    		},
    		{
    			name:'cuota'
    		},
    		{
    			name:'importeTotal'
    		},
    		{
    			name:'ccBase'
    		},
    		{
    			name:'ppBase'
    		},
    		{
    			name:'ccEsp'
    		},
    		{
    			name:'ppEsp'
    		},
    		{
    			name:'ccTasas'
    		},
    		{
    			name:'ppTasas'
    		},
    		{
    			name:'ccRecargo'
    		},
    		{
    			name:'ppRecargo'
    		},
    		{
    			name:'ccInteres'
    		},
    		{
    			name:'ppInteres'
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