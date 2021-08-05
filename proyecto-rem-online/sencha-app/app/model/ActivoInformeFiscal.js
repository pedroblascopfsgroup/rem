/**
 *  Modelo para la pestaña de Informe Fiscal
 */
Ext.define('HreRem.model.ActivoInformeFiscal', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
		    {
		    	name: 'codigoTipoImpuestoCompra'
		    },
		    {
               	name: 'bonificado'
            },
            {
                name: 'codigoTipoImpositivoITP'
            },
            {
                name: 'codigoTipoImpositivoIVA'
            },
            {
                name: 'porcentajeImpuestoCompra'
            },
            {
                name: 'codigoTpIvaCompra'
            },
            {
                name: 'renunciaExencionCompra'
            },
            {
                name: 'deducible'
            }
    		
    ],

	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getTabActivo',
		api: {
            read: 'activo/getTabActivo'
        },
		extraParams: {tab: 'informefiscal'}
    }
    
    

});