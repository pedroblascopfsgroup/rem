Ext.define('HreRem.view.expedientes.OfertaExpediente', {
    extend		: 'Ext.tab.Panel',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    xtype		: 'ofertaexpediente',
    reference	: 'ofertaexpedienteref',
    layout		: 'fit',
    requires	: ['HreRem.view.expedientes.DatosBasicosOferta'],
	listeners	: {
    	boxready: function (tabPanel) {
			if(tabPanel.items.length > 0 && tabPanel.items.items.length > 0) {
				var tab = tabPanel.items.items[0];
				tabPanel.setActiveTab(tab);
			}

	   		// Si la pestaña necesita botones de edicion
			if(tab.ocultarBotonesEdicion) {
				tabPanel.down("[itemId=botoneditar]").setVisible(false);
			} else {
				tabPanel.evaluarBotonesEdicion(tab);
			}
		},

		beforetabchange: function (tabPanel, tabNext, tabCurrent) {
			tabPanel.down("[itemId=botoneditar]").setVisible(false);	            	
        	// Comprobamos si estamos editando para confirmar el cambio de pestaña
        	if (tabCurrent != null) {
            	if (tabPanel.down("[itemId=botonguardar]").isVisible()) {	
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
									}
	        			        }
	        			   }
	    			});
        			return false;
        		}
	        	// Si la pestaña necesita botones de edición
				if(!tabNext.ocultarBotonesEdicion) {
	        		tabPanel.evaluarBotonesEdicion(tabNext);
				}
        		return true;		            	
        	}
		}
	},

	tabBar: {
        items: [
        		{
        			xtype: 'tbfill'
        		},
        		{
					xtype: 'buttontab',
        			itemId: 'botoneditar',
        		    handler	: 'onClickBotonEditar',
        		    iconCls: 'edit-button-color'
        		},
        		{
        			xtype: 'buttontab',
        			itemId: 'botonguardar',
        		    handler	: 'onClickBotonGuardar', 
        		    iconCls: 'save-button-color',
        		    hidden: true
        		},
        		{
        			xtype: 'buttontab',
        			itemId: 'botoncancelar',
        		    handler	: 'onClickBotonCancelar', 
        		    iconCls: 'cancel-button-color',
        		    hidden: true
        		}
        ]
	},

    initComponent: function () {
    	var me = this;
    	me.setTitle(HreRem.i18n('title.oferta'));

    	var items = [];
    	$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'datosbasicosoferta', funPermEdition: ['EDITAR_TAB_DATOS_BASICOS_OFERTA_EXPEDIENTES']})}, ['TAB_DATOS_BASICOS_OFERTA_EXPEDIENTES']);
    	$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'ofertatanteoyretracto', bind: {disabled: '{esExpedienteNoSujetoTramiteTanteo}'}, funPermEdition: ['EDITAR_TAB_TANTEO_RETRACTO_OFERTA_EXPEDIENTES']})}, ['TAB_TANTEO_RETRACTO_OFERTA_EXPEDIENTES']);
    	
    	me.addPlugin({ptype: 'lazyitems', items: items});

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
		var editionEnabled = function() {
			me.down("[itemId=botoneditar]").setVisible(true);
		}			
		// Si la pestaña recibida no tiene asignados roles de edicion 
		if(Ext.isEmpty(tab.funPermEdition)) {
    		editionEnabled();
    	} else {
    		$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
    	}
	}
});