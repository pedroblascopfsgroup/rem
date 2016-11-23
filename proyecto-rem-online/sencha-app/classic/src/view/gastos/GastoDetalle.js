Ext.define('HreRem.view.gastos.GastoDetalle', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'gastodetalle',
	cls			: 'panel-base shadow-panel tabPanel-segundo-nivel',
    requires 	: ['HreRem.view.gastos.DatosGeneralesGasto', 'HreRem.view.gastos.DetalleEconomicoGasto', 'HreRem.view.gastos.ActivosAfectadosGasto',
    				'HreRem.view.gastos.ContabilidadGasto','HreRem.view.gastos.GestionGasto', 'HreRem.view.gastos.ImpugnacionGasto','HreRem.view.gastos.DocumentosGasto'],
    listeners: {
			boxready: function (tabPanel) {
				if(tabPanel.items.length > 0 && tabPanel.items.items.length > 0) {
					var tab = tabPanel.items.items[0];
					tabPanel.setActiveTab(tab);
				}

				var me= this;
	        	var viewModel= me.lookupViewModel();
				if(tab.ocultarBotonesEdicion || viewModel.get('gasto.esGastoEditable')==false) {
					tabPanel.down("[itemId=botoneditar]").setVisible(false);
				} else {		
	            	tabPanel.evaluarBotonesEdicion(tab);
				}
			},

			beforetabchange: function (tabPanel, tabNext, tabCurrent) {
	        	tabPanel.down("[itemId=botoneditar]").setVisible(false);	            	
	        	// Comprobamos si estamos editando para confirmar el cambio de pestaña
	        	if (tabCurrent != null) {
	        		if (tabPanel.down("[itemId=botonguardar]").isVisible()){	
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
	        		var me= this;
	        		var viewModel= me.lookupViewModel();
	        		// Si la pestaña necesita botones de edición
	        		if(!tabNext.ocultarBotonesEdicion && viewModel.get('gasto.esGastoEditable')== true) {
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

    	var items = [];
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'datosgeneralesgasto', funPermEdition: ['EDITAR_TAB_DATOS_GENERALES_GASTOS']})}, ['TAB_DATOS_GENERALES_GASTOS']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'detalleeconomicogasto', funPermEdition: ['EDITAR_TAB_DETALLE_ECONOMICO_GASTOS']})}, ['TAB_DETALLE_ECONOMICO_GASTOS']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'activosafectadosgasto', funPermEdition: ['']})}, ['TAB_ACTIVOS_AFECTADOS_GASTOS']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'contabilidadgasto', funPermEdition: ['EDITAR_TAB_CONTABILIDAD_GASTOS']})}, ['TAB_CONTABILIDAD_GASTOS']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'gestiongasto', funPermEdition: ['EDITAR_TAB_GESTION_GASTOS']})}, ['TAB_GESTION_GASTOS']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'impugnaciongasto', funPermEdition: ['EDITAR_TAB_IMPUGNACION_GASTOS']})}, ['TAB_IMPUGNACION_GASTOS']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'documentosgasto', ocultarBotonesEdicion: true})}, ['TAB_DOCUMENTOS']);

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
