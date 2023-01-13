Ext.define('HreRem.view.agrupaciones.detalle.AgrupacionesDetalle', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'agrupacionesdetalle',
	cls			: 'panel-base shadow-panel, tabPanel-segundo-nivel',
	flex		: 1,
	layout		: 'fit',
    requires 	: ['HreRem.view.agrupaciones.detalle.FichaAgrupacion','HreRem.view.agrupaciones.detalle.ObservacionesAgrupacion',
    				'HreRem.view.agrupaciones.detalle.DocumentosAgrupacion', 'HreRem.view.agrupaciones.detalle.SeguimientoAgrupacion',
        			'HreRem.view.agrupaciones.detalle.SubdivisionesAgrupacionMain','HreRem.view.agrupaciones.detalle.FotosAgrupacion',
        			'HreRem.view.agrupaciones.detalle.ActivosAgrupacion','HreRem.view.agrupaciones.detalle.ObservacionesAgrupacion',
        			'Ext.ux.TabReorderer','HreRem.view.agrupacion.detalle.ComercialAgrupacion', 'HreRem.model.AgrupacionFicha'],
    listeners: {
    	boxready: function (tabPanel) {
    		if(tabPanel.items.length > 0 && tabPanel.items.items.length > 0) {
				var tab = tabPanel.items.items[0];
				tabPanel.setActiveTab(tab);
			}

			var tab = tabPanel.getActiveTab();		
			if(tab.ocultarBotonesEdicion) {
				me.down("[itemId=botoneditar]").setVisible(false);
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

    initComponent: function () {
        var me = this;
        var items = [];
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'fichaagrupacion', funPermEdition: ['EDITAR_AGRUPACION']})}, ['TAB_AGRUPACION']),
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'activosagrupacion', ocultarBotonesEdicion: true})}, ['TAB_LISTA_ACTIVOS_AGRUPACION']),
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'fotosagrupacion', ocultarBotonesEdicion: true, bind: {disabled:'{esAgrupacionProyecto}'}, tabConfig: { bind: { hidden: '{esAgrupacionProyecto}' }}})}, ['TAB_FOTOS_AGRUPACION']),
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'observacionesagrupacion', ocultarBotonesEdicion: true})}, ['TAB_OBSERVACIONES_AGRUPACION']),
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'documentosagrupacion', ocultarBotonesEdicion: true, bind: {disabled:'{!visibilidadPestanyaDocumentos}'},tabConfig: { bind: { hidden: '{esAgrupacionProyecto}' }}})}, ['TAB_DOCUMENTOS_AGRUPACION']),
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'seguimientoagrupacion', ocultarBotonesEdicion: true, bind: {disabled:'{!esAgrupacionProyecto}'}})}, ['TAB_SEGUIMIENTO_AGRUPACION']),
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'subdivisionesagrupacionmain', ocultarBotonesEdicion: true, bind: {disabled:'{!esAgrupacionObraNuevaOrAsistidaOrPromocionAlquiler}'},tabConfig: { bind: { hidden: '{esAgrupacionProyecto}' }}})}, ['TAB_SUBDIVISIONES_AGRUPACION']),
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'datospublicacionagrupacion', /*bind: {disabled:'{!habilitarPestanyaDatosPublicacionAgrupacion}'},*/ funPermEdition: ['EDITAR_TAB_DATOS_PUBLICACION']})}, ['TAB_DATOS_PUBLICACION']),
//		items.push({xtype: 'datospublicacionagrupacion', ocultarBotonesEdicion: false, bind: {disabled:'{!habilitarPestanyaDatosPublicacionAgrupacion}'}});
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'comercialagrupacion', ocultarBotonesEdicion: true, bind: {disabled:'{habilitarComercial}'},tabConfig: { bind: { hidden: '{esAgrupacionProyecto}' }}})}, ['TAB_COMERCIAL_AGRUPACION'])
 
        me.addPlugin({ptype: 'lazyitems', items: items});
        me.callParent(); 
    },

    /**
     * Función de utilidad por si es necesario configurar algo de la vista y que no es posible
     * a través del viewModel 
     */
    configCmp: function(data) {
    	var me = this;
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

		var esEditable = me.lookupController().getViewModel().get('agrupacionficha.esEditable');
		
		//Si la agrupación es editable
		if(esEditable) {
			//Se comprueba si es de tipo proyecto
			var agrupacionProyecto = false;
			var agrupacionPromocionAlquiler = false;
			var agrupacionesCaixa = false;
			var agrupacionONDnd = me.lookupController().getViewModel().get('agrupacionficha.isObraNueva')
								&& me.lookupController().getViewModel().get('agrupacionficha.esONDnd');
			var tipoAgrupacion =  me.lookupController().getViewModel().get('agrupacionficha.tipoAgrupacionCodigo');
			var tipoCartera =  me.lookupController().getViewModel().get('agrupacionficha.codigoCartera');
	     	if((tipoAgrupacion == CONST.TIPOS_AGRUPACION['PROYECTO'])) {
	     		agrupacionProyecto = true;
	     	}
	     	else if ((tipoAgrupacion == CONST.TIPOS_AGRUPACION['PROMOCION_ALQUILER'])) {
	     		agrupacionPromocionAlquiler = true;
	     	} else if (tipoCartera == CONST.CARTERA['BANKIA'] && (tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA'] 
	     				|| tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_ALQUILER'] 
	     				|| tipoAgrupacion == CONST.TIPOS_AGRUPACION['RESTRINGIDA_OBREM'])) {
	     		agrupacionesCaixa = true;
			}
				// Si la pestaña recibida no tiene asignadas funciones de edicion
				if(Ext.isEmpty(tab.funPermEdition)) {
		    		editionEnabled();
		    	} 
				else {
			    	// Si los usuarios son gestores de suelo o edificacion, además de superusuario, podrán editar la pestaña ficha si no se les niega.
					if(agrupacionProyecto){
			    		if($AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTSUE']) || $AU.userIsRol(CONST.PERFILES['GESTEDI'])
			    			|| $AU.userIsRol(CONST.PERFILES['GESTOR_ACTIVOS']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_ACTIVO'])){
				    			$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
			    		}
				    	else{
						    $AU.confirmFunToFunctionExecution(editionDisabled, tab.funPermEdition);
						}
				    }
			    	else if(agrupacionPromocionAlquiler){
				    	
			    		if($AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['GESTOR_COMERCIAL']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_COMERCIAL'])){
					    	$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
				    	}
				    	else{
						    $AU.confirmFunToFunctionExecution(editionDisabled, tab.funPermEdition);
						}
			    	} else if (agrupacionesCaixa) {
			    		$AU.confirmFunToFunctionExecution(editionDisabled, tab.funPermEdition);
					} else if (agrupacionONDnd){
						$AU.confirmFunToFunctionExecution(editionDisabled, tab.funPermEdition);
					} else{
					    $AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
					}

		    	}
		}
    }
});