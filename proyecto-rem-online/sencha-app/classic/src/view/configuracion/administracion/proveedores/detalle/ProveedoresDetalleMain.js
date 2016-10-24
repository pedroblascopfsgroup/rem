Ext.define('HreRem.view.configuracion.administracion.proveedores.detalle.ProveedoresDetalleMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'proveedoresdetallemain',
    cls			: 'proveedores-detalle',
    iconCls		: 'x-fa fa-user',
	iconAlign	: 'left',
	controller	: 'proveedordetalle',
    viewModel	: {
        type: 'proveedordetalle'
    },
    layout		: {
        type: 'vbox',
        align: 'stretch'
    },
    requires 	: ['HreRem.view.configuracion.administracion.proveedores.detalle.ProveedorDetalleModel','HreRem.view.configuracion.administracion.proveedores.detalle.ProveedoresDetalleTabPanel',
    			'HreRem.view.configuracion.administracion.proveedores.detalle.ProveedorDetalleController'],

    // NOTA: Añadiendo los items en la función configCmp, y llamando a esta en el callback de la petición de datos del activo, conseguimos que la pestaña se añada casi de inmediato al tabpanel,
	// renderizando el resto de contenido una vez hecha la petición. Se ha añadido un simple container, que posteriormente se quitará, para que la mascará de carga de la pestaña se muestre correctamante

	items: [	
			{xtype: 'container',
			 cls: 'container-mask-background',
			 flex: 1
			}
    ],

    configCmp: function(data) {

    	var me = this;

    	if(me.down('[cls=container-mask-background]')) {
    		me.removeAll();
    		me.add(
    			{
			    		xtype:'toolfieldset',			   		         						   		        
			        	cls: 'fieldsetBase cabecera',
			        	height: 20,
			        	title: ' ',
			        	scrollable: 'y',
			        	border: false,			        	
					    layout: {
						        type: 'hbox'
					    },
						tools: [
								{	xtype: 'tbfill'},
								{
									xtype: 'button',
									margin: '10 6 0 0',
									cls: 'boton-cabecera',
									iconCls: 'ico-refrescar',
									handler	: 'onClickBotonRefrescar',
									tooltip: HreRem.i18n('btn.refrescar')
						    	}
						    	
						],
						items: [
	    						
						]
	        		}
	       	);
    		me.add({xtype: 'proveedoresdetalletabpanel', flex: 1});
    	}
    }
});