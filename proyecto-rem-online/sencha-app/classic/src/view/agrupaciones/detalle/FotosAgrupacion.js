Ext.define('HreRem.view.agrupaciones.detalle.FotosAgrupacion', {
    extend: 'Ext.tab.Panel',
    xtype: 'fotosagrupacion',  
    flex 		: 3,
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    collapsed: false,
    scrollable	: 'y',
    layout		: 'fit',		
    reference: 'fotosagrupacion',
    requires: ['HreRem.view.agrupaciones.detalle.FotosWebAgrupacion'],
    
    defaults: {
        xtype: 'container',
        sytle: 'padding-left: 15px !important',
        defaultType: 'displayfield'
    },
    
    listeners	: {
    	boxready: function (tabPanel) {   		
			if(tabPanel.items.length > 0 && tabPanel.items.items.length > 0) {
				var tab = tabPanel.items.items[0];
				tabPanel.setActiveTab(tab);
			}
			
			if(tab.ocultarBotonesEdicion) {
				tabPanel.down("[itemId=botoneditarfoto]").setVisible(false);
			} else {
            	tabPanel.evaluarBotonesEdicion(tab);
			}
    	},

    	beforetabchange: function (tabPanel, tabNext, tabCurrent) {
        	tabPanel.down("[itemId=botoneditarfoto]").setVisible(false);	            	
        	// Comprobamos si estamos editando para confirmar el cambio de pestaña
        	if (tabCurrent != null) {
            	if (tabPanel.lookupController().getViewModel().get("editingfotos")) {
            		Ext.Msg.show({
            			   title: HreRem.i18n('title.descartar.cambios'),
            			   msg: HreRem.i18n('msg.desea.descartar'),
            			   buttons: Ext.MessageBox.YESNO,
            			   fn: function(buttonId) {
            			        if (buttonId == 'yes') {
            			        	var btn = tabPanel.down('button[itemId=botoncancelarfoto]');
            			        	Ext.callback(btn.handler, btn.scope, [btn, null], 0, btn);
            			        	tabPanel.getLayout().setActiveItem(tabNext);		            			        	
						            // Si la pestaña necesita botones de edición

				   					if(!tabNext.ocultarBotonesEdicion) {
					            		tabPanel.evaluarBotonesEdicion(tabNext);
				   					} else {
				   						tabPanel.down("[itemId=botoneditarfoto]").setVisible(false);
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
        			itemId: 'botoneditarfoto',
        		    handler	: 'onClickBotonEditarFoto',
        		    iconCls: 'edit-button-color',
        		    bind: {hidden: '{editingfotos}'}
        		},
        		{
        			xtype: 'buttontab',
        			itemId: 'botonguardarfoto',
        		    handler	: 'onClickBotonGuardarInfoFoto', 
        		    iconCls: 'save-button-color',
        		    hidden: true,
        		    bind: {hidden: '{!editingfotos}'}
        		},
        		{
        			xtype: 'buttontab',
        			itemId: 'botoncancelarfoto',
        		    handler	: 'onClickBotonCancelarFoto', 
        		    iconCls: 'cancel-button-color',
        		    hidden: true,
        		    bind: {hidden: '{!editingfotos}'}
        		}
        ]
    },

    initComponent: function () {

        var me = this;
        me.setTitle(HreRem.i18n('title.fotos'));      

        me.items = [];
    	$AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'fotoswebagrupacion', funPermEdition: ['EDITAR_TAB_FOTOS_AGRUPACION']})}, ['TAB_FOTOS_AGRUPACION']);
       
        me.callParent();
    },
    
     /**
     * Función de utilidad por si es necesario configurar algo de la vista y que no es posible
     * a través del viewModel 
     */
    configCmp: function(data) {
    	    	
    	var me = this;    	

    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabFotos(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    },

    evaluarBotonesEdicion: function(tab) {
		var me = this;
		me.down("[itemId=botoneditarfoto]").setVisible(false);
		var editionEnabled = function() {
			me.down("[itemId=botoneditarfoto]").setVisible(true);
		}

		// Si la pestaña recibida no tiene asignados roles de edicion 
		if(Ext.isEmpty(tab.funPermEdition)) {
    		editionEnabled();
    	} else {
    		$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
    	}
    }
});