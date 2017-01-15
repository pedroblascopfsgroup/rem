Ext.define('HreRem.view.activos.detalle.ActivosDetalle', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'activosdetalle',
	cls			: 'panel-base shadow-panel, tabPanel-segundo-nivel',
    requires 	: ['HreRem.view.activos.detalle.DatosGeneralesActivo', 'HreRem.view.activos.detalle.AdmisionActivo', 'HreRem.view.activos.tramites.TramitesActivo', 
    			'HreRem.view.activos.detalle.ObservacionesActivo', 'HreRem.view.activos.detalle.AgrupacionesActivo', 'HreRem.view.activos.detalle.GestoresActivo', 
    			'HreRem.view.activos.detalle.FotosActivo','HreRem.view.activos.detalle.DocumentosActivo','HreRem.view.activos.detalle.GestionActivo',
    			'HreRem.view.activos.detalle.PreciosActivo','HreRem.view.activos.detalle.Publicacion','HreRem.view.activos.detalle.ComercialActivo',
    			'HreRem.view.activos.detalle.AdministracionActivo'],

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

    	beforetabchange: function (tabPanel, tabNext, tabCurrent) {
        	tabPanel.down("[itemId=botoneditar]").setVisible(false);	            	
        	// Comprobamos si estamos editando para confirmar el cambio de pestaña
        	if (tabCurrent != null) {
            	if (tabPanel.lookupController().getViewModel().get("editingFirstLevel")) {
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
        			name: 'firstLevel',
        		    handler	: 'onClickBotonEditar',
        		    iconCls: 'edit-button-color'
        		},
        		{
        			xtype: 'buttontab',
        			itemId: 'botonguardar',
        			name: 'firstLevel',
        		    handler	: 'onClickBotonGuardar', 
        		    iconCls: 'save-button-color',
			        hidden: true,
        		    bind: {hidden: '{!editingFirstLevel}'}
        		},
        		{
        			xtype: 'buttontab',
        			itemId: 'botoncancelar',
        			name: 'firstLevel',
        		    handler	: 'onClickBotonCancelar', 
        		    iconCls: 'cancel-button-color',
        		   	hidden: true,
        		    bind: {hidden: '{!editingFirstLevel}'}
        		}]
    },

    initComponent: function() {
    	var me = this;
	    me.callParent(); 

	    $AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'datosgeneralesactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_DATOS_GENERALES');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'tramitesactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_ACTUACIONES');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'gestoresactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_GESTORES');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'observacionesactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_OBSERVACIONES');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'fotosactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_FOTOS');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'documentosactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_DOCUMENTOS');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'agrupacionesactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_AGRUPACIONES');
    	// Si el activo esta en agrupacion asistida, se ocultan estas dos pestanyas
    	if(me.lookupController().getViewModel().get('activo').get('integradoEnAgrupacionAsistida')=="false") {
	    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'admisionactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_ADMISION');
	    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'gestionactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_GESTION');
    	}
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'preciosactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_PRECIOS');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'publicacionactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_PUBLICACION');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'comercialactivo', funPermEdition: ['EDITAR_TAB_ACTIVO_COMERCIAL']})}, 'TAB_ACTIVO_COMERCIAL');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'administracionactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_ADMINISTRACION');
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