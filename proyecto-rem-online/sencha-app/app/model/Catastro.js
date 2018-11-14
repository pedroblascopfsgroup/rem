/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.Catastro', {
    extend: 'HreRem.model.Base',
    idProperty: 'idCatastro',

    fields: [    
  
     		{
    			name:'numActivo'
    		},
    		{
    			name:'numActivoRem'
    		},
    		{
    			name:'refCatastral'
    		},
    		{
    			name:'poligono'
    		},
    		{
    			name:'parcela'
    		},
    		{
    			name:'titularCatastral'
    		},
    		{
    			name:'superficieConstruida'
    		},
    		{
    			name:'superficieUtil'
    		},
    		{
    			name:'superficieReperComun'
    		},
    		{
    			name:'superficieParcela'
    		},
    		{
    			name:'superficieSuelo'
    		},
    		{
    			name:'valorCatastralConst'
    		},
    		{
    			name:'valorCatastralSuelo'
    		},
    		{
    			name:'fechaRevValorCatastral',
    			type:'date',
    			dateFormat: 'c'
    			// FIXME SOLUCION PARA BORRAR FECHAS
    			//dateWriteFormat: 'Y-m-d'
    		},
    		{
    			name:'fechaAltaCatastro',
    			type:'date',
    			dateFormat: 'c'    			
    		},
    		{
    			name:'fechaBajaCatastro',
    			type:'date',
    			dateFormat: 'c'    			
    		},
    		{
    			name:'observaciones' 			
    		},
    		{
    			name:'fechaSolicitud901',
    			type:'date',
    			dateFormat: 'c'    			
    		},
    		{
    			name:'resultadoSiNO'
    		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',

		api: {
            create: 'activo/createCatastro',
            update: 'activo/saveCatastro',
            destroy: 'activo/deleteCatastro'
        }
        
    }  

});