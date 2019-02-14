Ext.define('HreRem.model.ReclamacionActivo', {
    extend: 'HreRem.model.Base',

    fields: [
    	{
    		name:'id'
    	},
    	{
    		name : 'fechaAviso',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
    		name : 'fechaReclamacion',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
			name: 'IsUserAllowed',
			calculate: function(){
				return ($AU.userIsRol(CONST.PERFILES['HAYAGESTFORMADM']) || $AU.userIsRol(CONST.PERFILES['GESTIAFORM']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']));
			}
		}
    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById',
        api: {
        	update: 'gencat/updateFechaReclamacion'
        }
    }    

});