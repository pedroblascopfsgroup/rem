/**
 */
Ext.define('HreRem.model.ComboMunicipio', {
    extend: 'HreRem.model.ComboBase',

    fields: [
    	{
    		name: 'provincia'
    	},
    	{
    		name: 'codigoProvincia',
    		convert: function(value, record){return record.get('provincia').codigo},
			depends: 'provincia'
    	}
    ]

});