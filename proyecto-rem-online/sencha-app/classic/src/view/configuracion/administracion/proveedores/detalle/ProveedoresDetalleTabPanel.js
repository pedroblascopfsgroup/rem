Ext.define('HreRem.view.configuracion.administracion.proveedores.detalle.ProveedoresDetalleTabPanel', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'proveedoresdetalletabpanel',
	cls			: 'panel-base shadow-panel tabPanel-segundo-nivel',
    requires 	: ['HreRem.view.configuracion.administracion.proveedores.detalle.ProveedorDetalleController', 'HreRem.view.configuracion.administracion.proveedores.detalle.ProveedorDetalleModel',
                'HreRem.view.configuracion.administracion.proveedores.detalle.FichaProveedor', 'HreRem.view.configuracion.administracion.proveedores.detalle.DocumentosProveedor'],
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
        var items = [];
      
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'fichaproveedor', funPermEdition: ['EDITAR_TAB_DATOS_PROVEEDORES']})}, ['TAB_DATOS_PROVEEDORES']);
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'documentosproveedor', ocultarBotonesEdicion: true, bind:{disabled: '{proveedor.isSociedadTasadora}'}})}, ['TAB_DOCUMENTOS_PROVEEDORES']);

        me.addPlugin({ptype: 'lazyitems', items: items});
        me.callParent();
    },

    evaluarBotonesEdicion: function(tab) {
		var me = this;
		me.down("[itemId=botoneditar]").setVisible(false);
		var editionEnabled = function() {
			me.down("[itemId=botoneditar]").setVisible(true);
		}
		var editionDisabled = function() {
            me.down("[itemId=botoneditar]").setVisible(false);
        }
		// Si la pestaña recibida no tiene asignados roles de edicion 
		if(Ext.isEmpty(tab.funPermEdition)) {
    		editionEnabled();
    	} else if(!this.permiteProveedorNoHomologable()){
    		$AU.confirmFunToFunctionExecution(editionDisabled, tab.funPermEdition);
    	}
    	else {
    		$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
    	}
    },
    permiteProveedorNoHomologable: function () {
    	 var me = this;
    	 var tipoProveedor =  me.lookupController().getViewModel().get('proveedor.subtipoProveedorCodigo');
    	 if($AU.userIsRol(CONST.PERFILES['DESINMOBILIARIO']) && 
    		(tipoProveedor != CONST.SUBTIPOS_PROVEEDOR['COMUNIDAD_DE_PROPIETARIOS'] &&  tipoProveedor != CONST.SUBTIPOS_PROVEEDOR['COMPLEJO_INMOBILIARIO'] && tipoProveedor != CONST.SUBTIPOS_PROVEEDOR['ENTIDAD_DE_CONSERVACION'] &&
    		tipoProveedor != CONST.SUBTIPOS_PROVEEDOR['JUNTA_DE_COMPENSACION'] &&  tipoProveedor != CONST.SUBTIPOS_PROVEEDOR['AGRUPACION_DE_INTERES_URBANISTICO'] && tipoProveedor != CONST.SUBTIPOS_PROVEEDOR['AYUNTAMIENTO_MUNICIPAL'] &&
    		tipoProveedor != CONST.SUBTIPOS_PROVEEDOR['DIPUTACION_PROVINCIAL'] &&  tipoProveedor != CONST.SUBTIPOS_PROVEEDOR['CONSEJERIA_AUTONOMICO'] && tipoProveedor != CONST.SUBTIPOS_PROVEEDOR['HACIENDA_ESTATAL'] &&
    		tipoProveedor != CONST.SUBTIPOS_PROVEEDOR['OTRA_ADMINISTRACION_PUBLICA'] &&  tipoProveedor != CONST.SUBTIPOS_PROVEEDOR['NOTARIO'] && tipoProveedor != CONST.SUBTIPOS_PROVEEDOR['REGISTRO'] &&
    		tipoProveedor != CONST.SUBTIPOS_PROVEEDOR['PROCURADORES'] &&  tipoProveedor != CONST.SUBTIPOS_PROVEEDOR['SUMINISTRO'])
    	 ) {
    		 return false;
    	 }
    	 return true;
    }
});