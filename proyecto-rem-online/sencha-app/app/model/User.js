/**
 * This view is used to present the details of a single User.
 */
Ext.define('HreRem.model.User', {
    extend: 'HreRem.model.Base',

    fields: [
    	{
    		name: 'userName'
    	},
    	{
    		name: 'userId'
    	},
    	{
    		name: "authorities"
    	},
    	{
    		name: "roles"
    	},
    	{
    		name: "codigoGestor"
    	}
    ]
			

});