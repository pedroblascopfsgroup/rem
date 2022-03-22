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
				    hidden: false
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
    	me.editableDatosGenerales= false;
    	me.editableDetalleEconomico= false;
    	me.editableActivosAfectados= false;
    	me.editableContabilidad= false;
    	me.editableGestionGasto= false;
    	var estadoGasto= me.lookupController().getViewModel().get('gasto').get('estadoGastoCodigo');
    	var autorizado = me.lookupController().getViewModel().get('gasto').get('autorizado');
    	var rechazado = me.lookupController().getViewModel().get('gasto').get('rechazado');
    	var agrupado = me.lookupController().getViewModel().get('gasto').get('esGastoAgrupado');
    	var gestoria = me.lookupController().getViewModel().get('gasto').get('nombreGestoria')!=null;
    	me.edicionPestanyas(estadoGasto,autorizado,rechazado, agrupado, gestoria);

    	var items = [];
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'datosgeneralesgasto', ocultarBotonesEdicion:!me.editableDatosGenerales})}, ['TAB_DATOS_GENERALES_GASTOS']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'detalleeconomicogasto', ocultarBotonesEdicion:!me.editableDetalleEconomico})}, ['TAB_DETALLE_ECONOMICO_GASTOS']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'activosafectadosgasto', ocultarBotonesEdicion:!me.editableActivosAfectados})}, ['TAB_ACTIVOS_AFECTADOS_GASTOS']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'contabilidadgasto', ocultarBotonesEdicion:!me.editableContabilidad})}, ['TAB_CONTABILIDAD_GASTOS']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'gestiongasto', ocultarBotonesEdicion:!me.editableGestionGasto})}, ['TAB_GESTION_GASTOS']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'impugnaciongasto', ocultarBotonesEdicion: true/*, funPermEdition: ['EDITAR_TAB_IMPUGNACION_GASTOS']*/})}, ['TAB_IMPUGNACION_GASTOS']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'documentosgasto', ocultarBotonesEdicion: true})}, ['TAB_DOCUMENTOS']);
		
		me.addPlugin({ptype: 'lazyitems', items: items});
		me.callParent();
    },

	evaluarBotonesEdicion: function(tab) {
			var me = this,
			viewModel= me.lookupViewModel(),
			esEditable = false;
			var estadoGasto= viewModel.get('gasto').get('estadoGastoCodigo');
	    	var autorizado = viewModel.get('gasto').get('autorizado');
	    	var rechazado = viewModel.get('gasto').get('rechazado');
	    	var agrupado = viewModel.get('gasto').get('esGastoAgrupado');
	    	var gestoria = viewModel.get('gasto').get('nombreGestoria')!=null;
			if(tab.xtype=='datosgeneralesgasto'){
				esEditable = me.edicionPestanyaDatosGenerales(estadoGasto, autorizado, rechazado, agrupado, gestoria);
			}else if(tab.xtype=='detalleeconomicogasto'){
				esEditable = me.edicionPestanyaDetalleEconomico(estadoGasto, autorizado, rechazado, agrupado, gestoria);
			}else if(tab.xtype=='activosafectadosgasto'){
				esEditable = me.edicionPestanyaActivosAfectados(estadoGasto, autorizado, rechazado, agrupado, gestoria);
			}else if(tab.xtype=='contabilidadgasto'){
				esEditable = me.edicionPestanyaContabilidad(estadoGasto, autorizado, rechazado, agrupado, gestoria);
			}else if(tab.xtype=='gestiongasto'){
				esEditable = me.edicionPestanyaGestion(estadoGasto, autorizado, rechazado, agrupado, gestoria);
			}
			me.down("[itemId=botoneditar]").setVisible(false);

			var editionEnabled = function() {
				if(tab.getXTypes().includes('impugnaciongasto') || tab.getXTypes().includes('documentosgasto') || esEditable) {
					me.down("[itemId=botoneditar]").setVisible(true);
				}
			}

			// Si la pestaña recibida no tiene asignados roles de edicion 
			if(Ext.isEmpty(tab.funPermEdition)) {
				editionEnabled();
			} else {
				$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
			}
		},
	edicionPestanyaDatosGenerales: function(estadoGasto, autorizado, rechazado, agrupado, gestoria){
		if(!$AU.userIsRol(CONST.PERFILES['GESTIAFORMLBK']) && $AU.userHasFunction('EDITAR_TAB_DATOS_GENERALES_GASTOS') && (
		    	CONST.ESTADOS_GASTO['INCOMPLETO']==estadoGasto || CONST.ESTADOS_GASTO['PENDIENTE']==estadoGasto || CONST.ESTADOS_GASTO['RECHAZADO']==estadoGasto || 
		    	(CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO']==estadoGasto && !autorizado && !agrupado) || (CONST.ESTADOS_GASTO['SUBSANADO']==estadoGasto && !autorizado)
		    	|| (CONST.ESTADOS_GASTO['RETENIDO']==estadoGasto && $AU.userIsRol(CONST.PERFILES['HAYASUPER'])))){
		    		return true;
	    }
		return false;
		
	},
	edicionPestanyaDetalleEconomico: function(estadoGasto, autorizado, rechazado, agrupado, gestoria){ 
		if(!$AU.userIsRol(CONST.PERFILES['GESTIAFORMLBK']) && $AU.userHasFunction('EDITAR_TAB_DETALLE_ECONOMICO_GASTOS') && ((CONST.ESTADOS_GASTO['PAGADO']==estadoGasto) ||
				(CONST.ESTADOS_GASTO['AUTORIZADO']==estadoGasto && gestoria) || /*CONST.ESTADOS_GASTO['AUTORIZADO_PROPIETARIO']==estadoGasto || */
	    		CONST.ESTADOS_GASTO['CONTABILIZADO']==estadoGasto || CONST.ESTADOS_GASTO['INCOMPLETO']==estadoGasto || CONST.ESTADOS_GASTO['PENDIENTE']==estadoGasto || 
	    		CONST.ESTADOS_GASTO['RECHAZADO']==estadoGasto || (CONST.ESTADOS_GASTO['SUBSANADO']==estadoGasto && !autorizado) 
	    		|| (CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO']==estadoGasto && !autorizado && !agrupado) || (CONST.ESTADOS_GASTO['RETENIDO']==estadoGasto && $AU.userIsRol(CONST.PERFILES['HAYASUPER'])))){
	    			
	    			return true;
	    }
		return false;
		
	},
	edicionPestanyaActivosAfectados: function(estadoGasto, autorizado, rechazado, agrupado, gestoria){
		if(!$AU.userIsRol(CONST.PERFILES['GESTIAFORMLBK']) && $AU.userHasFunction('EDITAR_TAB_ACTIVOS_AFECTADOS_GASTOS') && (
		    	CONST.ESTADOS_GASTO['INCOMPLETO']==estadoGasto || CONST.ESTADOS_GASTO['PENDIENTE']==estadoGasto || CONST.ESTADOS_GASTO['RECHAZADO']==estadoGasto || 
		    	(CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO']==estadoGasto && !autorizado&& !agrupado) || (CONST.ESTADOS_GASTO['SUBSANADO']==estadoGasto && !autorizado)
		    	|| (CONST.ESTADOS_GASTO['RETENIDO']==estadoGasto && $AU.userIsRol(CONST.PERFILES['HAYASUPER'])))){
		    		return true;
	    }
		return false;
		
	},
	edicionPestanyaContabilidad: function(estadoGasto, autorizado, rechazado, agrupado, gestoria){
		if(!$AU.userIsRol(CONST.PERFILES['GESTIAFORMLBK']) && $AU.userHasFunction('EDITAR_TAB_CONTABILIDAD_GASTOS') && (
		    	CONST.ESTADOS_GASTO['INCOMPLETO']==estadoGasto || CONST.ESTADOS_GASTO['PENDIENTE']==estadoGasto || CONST.ESTADOS_GASTO['RECHAZADO']==estadoGasto || 
		    	(CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO']==estadoGasto && !autorizado && !agrupado) || (CONST.ESTADOS_GASTO['SUBSANADO']==estadoGasto && !autorizado)
		    	|| (CONST.ESTADOS_GASTO['RETENIDO']==estadoGasto && $AU.userIsRol(CONST.PERFILES['HAYASUPER'])))){
	    			return true;
	    	}
		return false;
		
	},
	edicionPestanyaGestion: function(estadoGasto, autorizado, rechazado, agrupado, gestoria){
		if(!$AU.userIsRol(CONST.PERFILES['GESTIAFORMLBK']) && $AU.userHasFunction('EDITAR_TAB_GESTION_GASTOS') && (CONST.ESTADOS_GASTO['CONTABILIZADO']!=estadoGasto && CONST.ESTADOS_GASTO['CONTABILIZADO']!=estadoGasto && CONST.ESTADOS_GASTO['ANULADO']!=estadoGasto && CONST.ESTADOS_GASTO['AUTORIZADO'] != estadoGasto && CONST.ESTADOS_GASTO['AUTORIZADO_PROPIETARIO'] != estadoGasto) 
    			&& (CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO']!=estadoGasto || (CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO']==estadoGasto && !autorizado && !agrupado)) 
    			&& (CONST.ESTADOS_GASTO['SUBSANADO']!=estadoGasto || (CONST.ESTADOS_GASTO['SUBSANADO']==estadoGasto && !autorizado) || (CONST.ESTADOS_GASTO['RETENIDO']==estadoGasto && $AU.userIsRol(CONST.PERFILES['HAYASUPER'])))){
    			return true;
    	}
		return false;
		
	},
	edicionPestanyas: function(estadoGasto, autorizado, rechazado, agrupado, gestoria){
		var me = this;
		me.editableDatosGenerales = me.edicionPestanyaDatosGenerales(estadoGasto, autorizado, rechazado, agrupado, gestoria);
		me.editableDetalleEconomico= me.edicionPestanyaDetalleEconomico(estadoGasto, autorizado, rechazado, agrupado, gestoria);
    	me.editableActivosAfectados= me.edicionPestanyaActivosAfectados(estadoGasto, autorizado, rechazado, agrupado, gestoria);
    	me.editableContabilidad= me.edicionPestanyaContabilidad(estadoGasto, autorizado, rechazado, agrupado, gestoria);
    	me.editableGestionGasto= me.edicionPestanyaGestion(estadoGasto, autorizado, rechazado, agrupado, gestoria);   	
    	  	
    	
    			
	}
	
});