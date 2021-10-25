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
    			name:'tipoAlquilerDescripcion'
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
    			name: 'tipoInquilinoDescripcion'
    		},
    		{
    			name: 'estadoAlquiler'
    		},
			{
    			name: 'estadoAlquilerDescripcion'
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
    		},
    		{
    			name: 'isCarteraCerberusDivarianOBBVA',
    			type: 'boolean'
    		},
    		{
    			name: 'cesionUso'
    		},
    		{
    			name: 'cesionUsoDescripcion'
    		},
    		{
    			name: 'isCarteraTitulizada',
    			type: 'boolean'
    		},
    		{
    			name: 'acuerdoPago'
    		},
    		{
    			name: 'moroso'
    		},
    		{
    			name: 'activoPromoEstrategico'
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