/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.Fotos', {
    //extend: 'HreRem.model.Base',
    extend: 'Ext.data.Model',
    //idProperty: 'id',

    fields: [    
  
  			/*{
    			name:'id',
    			type:'int'
    		},*/
    		{
    			name:'nombre'
    		},
    		{
    			name:'descripcion'
    		},
    		{
    			name:'codigoDescripcionFoto'
    		},
    		{
    			name:'codigoSubtipoActivo'
    		},
    		{
    			name:'fechaDocumento',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'orden'
    		},
    		{
    			name:'fileItem'
    		},
    		{
    			name:'tituloFoto'
    		},
    		{
    			name:'principal'
    		},
    		{
    			name:'interiorExterior'
    		},
    		{
    			name:'numeroActivo'
    		},
    		{
    			name:'suelos'
    		},
    		{
    			name:'plano'
    		},
    		{
    			name:'codigoTipoFoto'
    		}

    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById',
		api: {
			read: 'activo/getFotosById',
            create: 'activo/createFotosActivo',
            update: 'activo/saveFotosActivo',
            destroy: 'activo/deleteFotosActivo'
        }
    }

});