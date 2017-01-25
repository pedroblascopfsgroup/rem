Ext.define('HreRem.model.ConfiguracionGeneracionPropuestasModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'idRegla',

    fields: [
		{
			name:'idRegla'
		},
		{
			name:'carteraCodigo'
		},
		{
			name:'propuestaPrecioCodigo'
		},
		{
			name:'indicadorCondicionCodigo'
		},
		{
			name:'menorQueText'
		},
		{
			name:'mayorQueText'
		},
		{
			name:'igualQueText'
		}
    ],

	proxy: {
		type: 'uxproxy',
		api	: {
            read	: 'precios/getConfiguracionGeneracionPropuestas',
            create	: 'precios/createConfiguracionGeneracionPropuesta',
            update	: 'precios/updateConfiguracionGeneracionPropuesta',
            destroy	: 'precios/deleteConfiguracionGeneracionPropuesta'
        }
    }
});