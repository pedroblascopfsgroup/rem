Ext.define('HreRem.model.TasacionBankiaModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'fechaSolicitudTasacion',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'externoID'
    		},
    		{
    			name:'id'
    		},
    		{
    			name:'gestorSolicitud'
    		},
    		{
    			name: 'deshabilitarBtnSolicitud',
    			calculate: function(data) { 
    				return !Ext.isEmpty(data.fechaSolicitudTasacion);
    			},
    			depends: 'fechaSolicitudTasacion'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getSolicitudTasacionBankia'
        }
    }
});