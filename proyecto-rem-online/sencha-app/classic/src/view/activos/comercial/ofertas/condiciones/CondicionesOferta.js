Ext.define('HreRem.view.activos.comercial.ofertas.condiciones.CondicionesOferta', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'condicionesoferta',
    cls			: 'panel-base shadow-panel tabPanel-tercer-nivel-con-cabecera',
    reference	: 'condicionesoferta',
    title		: 'Condiciones',
	//layout		: 'fit',

/*	controller: 'ofertas',
    viewModel: {
        type: 'ofertas'
    }, */  

   /* requires: [
               'HreRem.view.activos.comercial.ofertas.datosGenerales.DatosGeneralesOferta',
               'HreRem.view.activos.comercial.ofertas.datosEconomicos.DatosEconomicosOferta'
           ],
     */      
    items: [
    		{
    			xtype: 'condicioneseconomicastabmain'
    		},
    		{
    			xtype: 'condicionesjuridicastabmain'
    		}
        ]

});

