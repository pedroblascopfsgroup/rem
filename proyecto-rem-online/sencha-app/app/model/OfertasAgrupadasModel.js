/**
 * This view is used to present the details of a Ofertas Agrupadas Liberbank.
 */
Ext.define('HreRem.model.OfertasAgrupadasModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    	{
    		name : 'id'
    	},
    	{
    		name : 'numOfertaPrincipal'
    	},
    	{
    		name : 'numOfertaDependiente'
    	},
    	{
    		name : 'numActivo'
    	},
    	{
    		name : 'importeOfertaDependiente'
    	},
    	{
    		name : 'valorTasacionActivo'
    	},
    	{
    		name : 'valorNetoContable'
    	},
    	{
    		name : 'valorRazonable'
    	}
    ]
});