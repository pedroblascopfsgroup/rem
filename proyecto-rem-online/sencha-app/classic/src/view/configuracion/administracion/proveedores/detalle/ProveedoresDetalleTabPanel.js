Ext.define('HreRem.view.configuracion.administracion.proveedores.detalle.ProveedoresDetalleTabPanel', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'proveedoresdetalletabpanel',
	cls			: 'panel-base shadow-panel tabPanel-segundo-nivel',
    requires 	: ['HreRem.view.configuracion.administracion.proveedores.detalle.ProveedorDetalleController', 'HreRem.view.configuracion.administracion.proveedores.detalle.ProveedorDetalleModel',
                'HreRem.view.configuracion.administracion.proveedores.detalle.FichaProveedor', 'HreRem.view.configuracion.administracion.proveedores.detalle.DocumentosProveedor',
				'HreRem.view.configuracion.administracion.proveedores.detalle.ConductasInapropiadasList', 'HreRem.view.configuracion.administracion.proveedores.detalle.DatosContacto'],
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
        		}]
    },

    initComponent: function () {
        var me = this;
		var isMediador = me.lookupController().getViewModel().get('proveedor').get('isMediador');

        var items = [];
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'fichaproveedor', funPermEdition: ['EDITAR_TAB_DATOS_PROVEEDORES']})}, ['TAB_DATOS_PROVEEDORES']);
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'bloqueoApis', funPermEdition: ['EDITAR_TAB_DATOS_PROVEEDORES']})}, ['TAB_DATOS_PROVEEDORES']);
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'documentosproveedor', ocultarBotonesEdicion: true, bind:{disabled: '{proveedor.isSociedadTasadora}'}})}, ['TAB_DOCUMENTOS_PROVEEDORES']);
        if (isMediador){
        	$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'datoscontacto', ocultarBotonesEdicion: false})}, ['TAB_DATOS_PROVEEDORES']);
			$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'conductasInapropiadasList', ocultarBotonesEdicion: true})}, ['TAB_CONDUCTAS_PROVEEDORES']);
        }

        
        me.addPlugin({ptype: 'lazyitems', items: items});
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