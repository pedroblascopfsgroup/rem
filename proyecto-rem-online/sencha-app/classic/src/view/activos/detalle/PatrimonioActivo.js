Ext.define('HreRem.view.activos.detalle.PatrimonioActivo', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'patrimonioactivo',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    reference	: 'patrimonio',
    layout		: 'fit',
    requires	: ['HreRem.view.activos.detalle.DatosPatrimonio', 'HreRem.view.activos.detalle.ContratosPatrimonio'],
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
        	if (tabCurrent != null)
        	{
            	if (tabPanel.lookupController().getViewModel().get("editing"))
        	{	
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
        		}]
    },

	initComponent: function () {
	     var me = this;
	     me.setTitle(HreRem.i18n('title.patrimonio.activo'));	     
	     var items =[];     	     
	     items.push({xtype: 'datospatrimonio', ocultarBotonesEdicion: false, title: HreRem.i18n('title.datos.basicos')});
	     items.push({xtype: 'contratospatrimonio', ocultarBotonesEdicion: true, bind: {disabled:'{!esActivoAlquilado}'}, title: HreRem.i18n('title.patrimonio.datos.patrimonio.contratos')});
	     me.addPlugin({ptype: 'lazyitems', items: items });
	     me.callParent();
	 },

    evaluarBotonesEdicion: function(tab) {    	
		var me = this;
		me.down("[itemId=botoneditar]").setVisible(false);
		var editionEnabled = function() {
			me.down("[itemId=botoneditar]").setVisible(true);
		}
		
		if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="true") {
			if(Ext.isEmpty(tab.funPermEdition)) {
	    		editionEnabled();
	    	} else {
	    		$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
	    	}
		}
    },

    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.getActiveTab().funcionRecargar();
    }
});