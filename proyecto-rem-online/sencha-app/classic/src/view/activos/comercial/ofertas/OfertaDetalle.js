Ext.define('HreRem.view.activos.comercial.ofertas.OfertaDetalle', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'ofertadetalle',
    iconCls		: 'x-fa fa-exchange',
	iconAlign	: 'left',
    cls			: 'panel-base tabPanel-segundo-nivel-con-cabecera',
    reference	: 'ofertaDetalle',

	controller: 'ofertas',
    /*viewModel: {
        type: 'ofertas'
    },*/   

    requires: [
               'HreRem.view.activos.comercial.ofertas.datosGenerales.DatosGeneralesOferta',
               'HreRem.view.activos.comercial.ofertas.datosEconomicos.DatosEconomicosOferta'
           ],
           
    items: [
			{ 
				xtype: 'cabeceraactivooferta'
			},
			
			{
    			xtype: 'tabpanel',
    			tabBar: {
            
				        items: [{xtype: 'tbfill'},{
				            xtype: 'button',
				            tipo: 'btnFavoritos',
				            isFavorito: false,
				            cssFavorito: 'fa-exchange',
				            cls: 'boton-favorito',
				            tipoId: 'oferta',
				            handler: 'onClickBotonFavoritos'
				        }]
				},
    			items: [	
						{
							xtype: 'datosgeneralesoferta'
						},
			            {
							xtype: 'datoseconomicosoferta'
			    		},
			    		{
			    			xtype: 'ofertantestabmain'
			    		},
			    		{
			    			xtype: 'condicionesoferta'
			    		},
			    		{
			    			xtype: 'propuestastabmain'
			    		}
			    	   ]
			}
        ]

});

