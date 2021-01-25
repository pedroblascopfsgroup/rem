Ext.define('HreRem.model.TarifasGridModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'codigoTarifa'
    		},
    		{
    			name:'descripcion'
    		},
    		{
    			name:'precioUnitario'
    		},
    		{
    			name:'unidadMedida'
    		}
    ]
});