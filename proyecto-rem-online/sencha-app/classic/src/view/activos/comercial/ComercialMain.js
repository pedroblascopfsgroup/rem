Ext.define('HreRem.view.activos.comercial.ComercialMain', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'comercialmain',
    title		: 'Comercial',
    closable	: false,
	cls	: 'panel-base shadow-panel tabPanel-tercer-nivel',
		
	requires: [
        'HreRem.view.activos.comercial.solicitudes.SolicitudesMain',
        'HreRem.view.activos.comercial.visitas.VisitasTabMain',
        'HreRem.view.activos.comercial.ofertas.OfertasTabMain'
    ],
    
    items		: [
    
	   	{xtype: 'solicitudesmain'},
	   	{xtype: 'visitastabmain'},
	   	{xtype: 'ofertasTabMain'},
	    {title: 'Publicación',
	   	 xtype: 'comingsoon'},
	    {title: 'Precios',
	   	 xtype: 'comingsoon'},
	    {title: 'Formalización',
	   	 xtype: 'comingsoon'}


    
    ]
});