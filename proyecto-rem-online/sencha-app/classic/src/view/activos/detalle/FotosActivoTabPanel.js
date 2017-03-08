Ext.define('HreRem.view.activos.detalle.FotosActivoTabPanel', {
	extend		: 'Ext.tab.Panel',
    xtype		: 'fotosactivotabpanel',
    flex 		: 3,
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    reference	: 'tabpanelfotosactivo',
    layout		: 'fit',
    requires	: ['HreRem.view.activos.detalle.FotosWebActivo', 'HreRem.view.activos.detalle.FotosTecnicasActivo'],
    listeners	: {
    	boxready: function (tabPanel) {   		
			if(tabPanel.items.length > 0 && tabPanel.items.items.length > 0) {
				var tab = tabPanel.items.items[0];
				tabPanel.setActiveTab(tab);
			}
			
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
    tabBar: {
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
        		    handler	: 'onClickBotonGuardarInfoFoto', 
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

        me.items = [];
    	$AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'fotoswebactivo', funPermEdition: ['EDITAR_TAB_FOTOS_ACTIVO_WEB']})}, ['TAB_FOTOS_ACTIVO_WEB']);
        $AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'fotostecnicasactivo', funPermEdition: ['EDITAR_TAB_FOTOS_ACTIVO_TECNICAS']})}, ['TAB_FOTOS_ACTIVO_TECNICAS']);

        me.callParent();
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