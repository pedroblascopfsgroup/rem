/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.ActivoSubdivision', {
    extend: 'HreRem.model.Base',
    idProperty: 'activoId',

    fields: [
    		{
    			name: 'activoId'
    		},
		    {
		    	name: 'idSubdivision'
		    },
     		{
    			name:'numActivo'
    		},
    		{
    			name:'numFinca'
    		},
    		{
    			name:'tipoActivo'
    		}, 
    		{
    			name:'subtipoActivo'
    		}, 
    		{
    			name:'estadoDisposicionInforme'
    		}, 
    		{
    			name:'estadoPublicacionS'
    		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById',

		api: {
            read: 'agrupacion/getListActivosSubdivisionById',
            create: 'agrupacion/getListActivosSubdivisionById',
            update: 'agrupacion/getListActivosSubdivisionById',
            destroy: 'agrupacion/getListActivosSubdivisionById'
        }

    }    

});