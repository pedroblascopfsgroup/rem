Ext.define('HreRem.view.activos.detalle.Publicacion', {
    extend		: 'Ext.tab.Panel',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    xtype		: 'publicacionactivo',
    reference	: 'publicacionactivoref',
    layout		: 'fit',
    requires	: ['HreRem.view.activos.detalle.InformeComercialActivo', 'HreRem.view.activos.detalle.DatosPublicacionActivo'],

	listeners: {
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

		activate: function(tabPanel) {
			var me = this;
			var muestraEdicion = me.up('activosdetallemain').getViewModel().getData().activo.getData().aplicaComercializar
					&& !me.up('activosdetallemain').getViewModel().getData().activo.getData().isVendido;
			var pestañaInformeComercial = me.down('informecomercialactivo');
			var pestañaDatosPublicacion = me.down('datospublicacionactivo');

			pestañaInformeComercial.ocultarBotonesEdicion = !muestraEdicion;
			pestañaDatosPublicacion.ocultarBotonesEdicion = !muestraEdicion;
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
        		    iconCls: 'edit-button-color',
        		    bind: {hidden: '{editing}'}
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
        		}
        ]
    },

     evaluarBotonesEdicion: function(tab) {    	
		var me = this;
		me.down("[itemId=botoneditar]").setVisible(false);
		var editionEnabled = function() {
			me.down("[itemId=botoneditar]").setVisible(true);
		}

		//HREOS-846 Si NO esta dentro del perimetro, no se habilitan los botones de editar
		if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="true") {
			// Si la pestaña recibida no tiene asignadas funciones de edicion 
			if(Ext.isEmpty(tab.funPermEdition)) {
	    		editionEnabled();
	    	} else {
	    		$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
	    	} 
		}
    },

    initComponent: function () {
    	var me = this;
    	me.setTitle(HreRem.i18n('title.publicacion.activo'));

    	var items = [];
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'informecomercialactivo', funPermEdition: ['EDITAR_TAB_INFO_COMERCIAL_PUBLICACION']})}, ['TAB_INFO_COMERCIAL_PUBLICACION']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'datospublicacionactivo', funPermEdition: ['EDITAR_TAB_DATOS_PUBLICACION']})}, ['TAB_DATOS_PUBLICACION']);

		me.addPlugin({ptype: 'lazyitems', items: items});
		me.callParent();
    },

    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.getActiveTab().funcionRecargar();
    }
});