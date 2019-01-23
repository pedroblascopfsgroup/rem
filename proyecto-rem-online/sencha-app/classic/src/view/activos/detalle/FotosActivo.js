Ext.define('HreRem.view.activos.detalle.FotosActivo', {
	extend		: 'Ext.tab.Panel',
    xtype		: 'fotosactivo',
    flex 		: 3,
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    reference	: 'fotosactivo',
    layout		: 'fit',
    requires	: ['HreRem.view.activos.detalle.FotosWebActivo', 'HreRem.view.activos.detalle.FotosTecnicasActivo'],
    sytle		: 'padding-left: 15px !important',
    defaultType	: 'displayfield',
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
        me.setTitle(HreRem.i18n('title.fotos'));
        //HREOS-1964: Restringir los activos financieros (asistidos) para que solo puedan ser editables por los perfiles de IT y Gestoria PDV
		var ocultarFotoswebactivo = false;		
		if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
			ocultarFotoswebactivo = !(($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
				 && $AU.userHasFunction('EDITAR_TAB_FOTOS_ACTIVO_WEB'));
		}else{
			ocultarFotoswebactivo = !$AU.userHasFunction('EDITAR_TAB_FOTOS_ACTIVO_WEB');
		}
		
		var ocultarFotostecnicasactivo = false;		
		if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
			ocultarFotostecnicasactivo = !(($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
				 && $AU.userHasFunction('EDITAR_TAB_FOTOS_ACTIVO_TECNICAS'));
		}else{
			ocultarFotostecnicasactivo = !$AU.userHasFunction('EDITAR_TAB_FOTOS_ACTIVO_TECNICAS');
		}

        me.items = [];
    	$AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'fotoswebactivo', ocultarBotonesEdicion: ocultarFotoswebactivo})}, ['TAB_FOTOS_ACTIVO_WEB']);
        $AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'fotostecnicasactivo', ocultarBotonesEdicion: ocultarFotostecnicasactivo})}, ['TAB_FOTOS_ACTIVO_TECNICAS']);
        me.addPlugin({ptype: 'lazyitems', items: me.items });
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
    } 
});