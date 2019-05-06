/**
 * This view is used to present the details of OfertasAsociadasActivoList on Gencat tab.
 */
Ext.define('HreRem.model.OfertasAsociadasActivo', {
    extend: 'HreRem.model.Base',

    fields: [
		{
			name:'fechaPreBloqueo',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'numOferta'
		},
		{
			name:'importeOferta'
		},
		{
			name:'tipoComprador'
		},
		{
			name:'situacionOcupacional'
		}
    ],
    
    proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getActivoById'
    }

});