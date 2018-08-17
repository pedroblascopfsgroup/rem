Ext.define('HreRem.view.agrupaciones.detalle.AgrupacionesDetalleMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'agrupacionesdetallemain',
	cls			: 'panel-base',
	iconCls		: 'ico-pestana-agrupaciones',
	width		: '100%',
    height		: '100%',
    iconAlign	: 'left',
    layout		: {
        type: 'vbox',
        align: 'stretch'
    },

    requires : ['HreRem.view.agrupaciones.detalle.AgrupacionDetalleController', 'HreRem.view.agrupaciones.detalle.AgrupacionDetalleModel', 'HreRem.ux.button.BotonFavorito', 
    			'HreRem.view.agrupaciones.detalle.CabeceraAgrupacion','HreRem.view.agrupaciones.detalle.AgrupacionesDetalle','HreRem.view.common.GridBaseEditable','Ext.ux.TabReorderer'],

    controller: 'agrupaciondetalle',
    viewModel: {
        type: 'agrupaciondetalle'
    },

    // NOTA: Añadiendo los items en la función configCmp, y llamando a esta en el callback de la petición de datos del activo, conseguimos que la pestaña se añada casi de inmediato al tabpanel,
	// renderizando el resto de contenido una vez hecha la petición. Se ha añadido un simple container, que posteriormente se quitará, para que la mascará de carga de la pestaña se muestre correctamante
    items: [	
    		{xtype: 'container',
			 cls: 'container-mask-background',
			 flex: 1
			}
    ],

    /**
     * Función de utilidad por si es necesario configurar algo de la vista y que no es posible
     * a través del viewModel 
     */
    configCmp: function(data) {
    	var me = this;

    	if(me.down('[cls=container-mask-background]')) {
    		me.removeAll();
    		me.add({xtype: 'cabeceraagrupacion'});
    		me.add({xtype: 'agrupacionesdetalle', flex: 1});
    	} 

    	me.down('cabeceraagrupacion').configCmp(data); 
    	me.down('agrupacionesdetalle').configCmp(data);
    	
     	
    	if(me.getViewModel().get('agrupacionficha.tipoAgrupacionCodigo') === CONST.TIPOS_AGRUPACION['PROYECTO']){				
			var tabSeguimientoAgrupacion= me.down('seguimientoagrupacion');
			tabSeguimientoAgrupacion.tab.setVisible(false);
		/*	var tabObservacionesAgrupacion= me.down('observacionesagrupacion');
			tabObservacionesAgrupacion.tab.setVisible(false);*/
			
		}
    }
});