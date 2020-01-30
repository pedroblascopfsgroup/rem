/**
 *  Modelo para el tab Patrimonio de Activos 
 */
Ext.define('HreRem.model.ActivoPatrimonio', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    

    fields: [
     		
    		{
    			name:'chkPerimetroAlquiler',
    			type: 'boolean'
    		},
    		{
    			name:'tipoAlquilerCodigo'
    		},
    		{
    			name:'codigoAdecuacion'
    		},
    		{
    			name:'descripcionAdecuacion'
    		},
    		{
    			name:'comboRentaAntigua'
			},
			{
				name:'chkSubrogado'
			},
			{
    			name: 'tipoInquilino'
    		},
    		{
    			name: 'estadoAlquiler'
    		},
    		{
    			name: 'ocupacion'
    		},
    		{
    			name: 'conTitulo'
    		},
    		{
    			name: 'pazSocial'
    		},
    		{
    			name: 'isCarteraCerberusDivarian',
    			type: 'boolean'
    		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveDatosPatrimonio',
            update: 'activo/saveDatosPatrimonio',
            destroy: 'activo/getTabActivo'
        },
        extraParams: {tab: 'patrimonio'}
    }

});