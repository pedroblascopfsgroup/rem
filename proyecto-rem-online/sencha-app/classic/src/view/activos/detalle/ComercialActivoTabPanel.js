Ext.define('HreRem.view.activos.detalle.ComercialActivoTabPanel', {
    extend		: 'Ext.tab.Panel',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    xtype		: 'comercialactivotabpanel',
    reference	: 'comercialactivotabpanelref',
    layout		: 'fit',
    requires	: [
    				'HreRem.view.activos.detalle.VisitasComercialActivo', 
    				'HreRem.view.activos.detalle.OfertasComercialActivo',
    				'HreRem.view.activos.detalle.GencatComercialActivo'
    			  ],    

	listeners	: {
    	boxready: function (tabPanel) {   		
			if(tabPanel.items.length > 0 && tabPanel.items.items.length > 0) {
				var tab = tabPanel.items.items[0];
				tabPanel.setActiveTab(tab);
				this.evaluarBotonesEdicion(tab);
			}
			
		},
		beforetabchange: function (tabPanel, tabNext, tabCurrent) {
        	tabPanel.down("[itemId=botoneditar]").setVisible(false);	            	
        	// Comprobamos si estamos editando para confirmar el cambio de pestaña
        	if (tabCurrent != null) {
            	if (tabPanel.lookupController().getViewModel().get("editing")) {
            		Ext.Msg.show({
            			   title: HreRem.i18n('title.descartar.cambios'),
            			   msg: HreRem.i18n('msg.desea.descartar'),
            			   buttons: Ext.MessageBox.YESNO,
            			   fn: function(buttonId) {
            			        if (buttonId == 'yes') {
            			        	var btn = tabPanel.down('button[itemId=botoncancelar]');
            			        	Ext.callback(btn.handler, btn.scope, [btn, null], 0, btn);
            			        	tabPanel.getLayout().setActiveItem(tabNext);		            			        	
						            // Si la pestaña necesita botones de edición

				   					if(!tabNext.ocultarBotonesEdicion) {
					            		tabPanel.evaluarBotonesEdicion(tabNext);
				   					} else {
				   						tabPanel.down("[itemId=botoneditar]").setVisible(false);
				   					}
            			        }
            			   }
        			});

            		return false;
            	}

            	// Si la pestaña necesita botones de edición
				if(!tabNext.ocultarBotonesEdicion) {
            		tabPanel.evaluarBotonesEdicion(tabNext);
				} else {
						tabPanel.down("[itemId=botoneditar]").setVisible(false);
					}

            	return true;
        	}
        }
    },
    tabBar: { // Botones edicion
		items: [
        		{
        			xtype: 'tbfill'
        		},
        		{
					xtype: 'buttontab',
        			itemId: 'botoneditar',
        		    handler	: 'onClickBotonEditar',
        		    iconCls: 'edit-button-color',
        		    bind: {hidden: '{editing}'}
        		},
        		{
        			xtype: 'buttontab',
        			itemId: 'botonguardar',
        		    handler	: 'onClickGuardarComercial',
        		    iconCls: 'save-button-color',
        		    hidden: true,
        		    bind: {hidden: '{!editing}'}
        		},
        		{
        			xtype: 'buttontab',
        			itemId: 'botoncancelar',
        		    handler	: 'onClickBotonCancelar', 
        		    iconCls: 'cancel-button-color',
        		    hidden: true,
        		    bind: {hidden: '{!editing}'}
        		}
        ]
    },

    initComponent: function () {
    	var me = this;

		var items = [];

		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'ofertascomercialactivo'})}, ['TAB_COMERCIAL_OFERTAS']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'visitascomercialactivo'})}, ['TAB_COMERCIAL_VISITAS']);
		
		if (me.lookupViewModel().get('activo.afectoAGencat')) {
			items.push({xtype: 'gencatcomercialactivo'});
		}

    	me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    },

    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.getActiveTab().funcionRecargar();
    },

    evaluarBotonesEdicion: function(tab) {
    	var me = this;
		me.down("[itemId=botoneditar]").setVisible(false);
		
		if (tab.xtype === "gencatcomercialactivo") {
			me.down("[itemId=botoneditar]").setVisible(true);
		}

	}
	
});