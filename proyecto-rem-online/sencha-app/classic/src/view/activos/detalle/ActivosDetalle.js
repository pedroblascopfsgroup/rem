Ext.define('HreRem.view.activos.detalle.ActivosDetalle', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'activosdetalle',
    reference	: 'activosdetalle',
	cls			: 'panel-base shadow-panel, tabPanel-segundo-nivel',
    requires 	: ['HreRem.view.activos.detalle.DatosGeneralesActivo', 'HreRem.view.activos.detalle.AdmisionActivo', 'HreRem.view.activos.tramites.TramitesActivo', 
    			'HreRem.view.activos.detalle.ObservacionesActivo', 'HreRem.view.activos.detalle.AgrupacionesActivo', 'HreRem.view.activos.detalle.GestoresActivo', 
    			'HreRem.view.activos.detalle.FotosActivo','HreRem.view.activos.detalle.TabDocumentosActivo','HreRem.view.activos.detalle.GestionActivo',
    			'HreRem.view.activos.detalle.PreciosActivo','HreRem.view.activos.detalle.Publicacion','HreRem.view.activos.detalle.ComercialActivo',
    			'HreRem.view.activos.detalle.AdministracionActivo', 'HreRem.view.activos.detalle.DocumentosActivoPromocion','HreRem.view.activos.detalle.DocumentosActivoSimple',
			'HreRem.view.activos.detalle.PatrimonioActivo', 'HreRem.view.activos.detalle.PlusvaliaActivo', 'HreRem.view.activos.detalle.SuministrosActivo'],

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
            	if (tabPanel.lookupController().getViewModel().get("editingFirstLevel") || tabPanel.lookupController().getViewModel().get("editing")) {
            		Ext.Msg.show({
            			   title: HreRem.i18n('title.descartar.cambios'),
            			   msg: HreRem.i18n('msg.desea.descartar'),
            			   buttons: Ext.MessageBox.YESNO,
            			   fn: function(buttonId) {
            			        if (buttonId == 'yes') {
									tabPanel.lookupController().getViewModel().set("editingFirstLevel", false);
									tabPanel.lookupController().getViewModel().set("editing", false);									
									tabPanel.lookupController().getViewModel().notify();
									var btn = tabPanel.down('button[itemId=botoncancelar]');
        			        		Ext.callback(btn.handler, btn.scope, [btn, null], 0, btn);
									tabPanel.setActiveTab(tabNext);									
									
						            // Si la pestaña necesita botones de edición

				   					if(!tabNext.ocultarBotonesEdicion) {
					            		tabPanel.evaluarBotonesEdicion(tabNext);
				   					} else {
				   						tabPanel.down("[itemId=botoneditar]").setVisible(false);
				   					}
            			        }
								else if(!tabCurrent.ocultarBotonesEdicion) {
				            		tabPanel.evaluarBotonesEdicion(tabCurrent);
								} else {
									tabPanel.down("[itemId=botoneditar]").setVisible(false);
								}
            			   }
        			});

            		return false;
            	}				

				else if(!tabNext.ocultarBotonesEdicion) {
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
	    //HREOS-1964: Restringir los activos financieros (asistidos) para que s�lo puedan ser editables por los perfiles de IT y Gestor�a PDV
	    var editable = false;
	    
	    if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){ 
	    	editable = !(
	    			($AU.userIsRol(CONST.PERFILES['GESTOPDV']) 
	    			|| $AU.userIsRol(CONST.PERFILES['HAYASUPER']) 
	    			|| $AU.userIsRol(CONST.PERFILES['HAYACAL']) 
	    			|| $AU.userIsRol(CONST.PERFILES['HAYASUPCAL']) 
	    			|| $AU.userIsRol(CONST.PERFILES['DIRECCION_TERRITORIAL'])) 
					
	    			&& $AU.userHasFunction('EDITAR_TAB_ACTIVO_COMERCIAL')
	    			);
	    	
		}else{
			editable = !$AU.userHasFunction('EDITAR_TAB_ACTIVO_COMERCIAL');
		}
	    
	    
	    if(!$AU.userIsRol(CONST.PERFILES['CARTERA_BBVA'])) {

		    $AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'datosgeneralesactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_DATOS_GENERALES');
	    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'tramitesactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_ACTUACIONES');
	    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'gestoresactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_GESTORES');
	    	if($AU.getUser().codigoCartera == CONST.CARTERA['BANKIA'] && me.lookupController().getViewModel().get('activo').get('isCarteraBankia')){
				if($AU.userIsRol(CONST.PERFILES['USUARIO_CONSULTA']) || $AU.userHasFunction('TAB_ACTIVO_OBSERVACIONES')){
					me.add({xtype: 'observacionesactivo', launch: CONST.OBSERVACIONES_TAB_LAUNCH['ACTIVO'], ocultarBotonesEdicion: true});
				}
			}else{
				$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'observacionesactivo',launch: CONST.OBSERVACIONES_TAB_LAUNCH['ACTIVO'], ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_OBSERVACIONES');
			}
	    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'fotosactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_FOTOS');
	    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'tabdocumentosactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_DOCUMENTOS');
	    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'agrupacionesactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_AGRUPACIONES');
	    	// Si el activo esta en agrupacion asistida, se ocultan estas dos pestanyas
	    	//if(me.lookupController().getViewModel().get('activo').get('integradoEnAgrupacionAsistida')=="false") {
	    	//Se comenta el IF anterior para que se pueda mostrar el check de calidad
	    	var disabled = me.lookupController().getViewModel().get('activo.perimetroAdmision')==false;
	    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'admisionactivo', ocultarBotonesEdicion: true,disabled:disabled})}, 'TAB_ACTIVO_ADMISION');
	    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'gestionactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_GESTION');
	    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'preciosactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_PRECIOS');
	    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'publicacionactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_PUBLICACION');
	    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'comercialactivo', ocultarBotonesEdicion: editable/*funPermEdition: ['EDITAR_TAB_ACTIVO_COMERCIAL']*/})}, 'TAB_ACTIVO_COMERCIAL');
	    	
	    	if ($AU.userIsRol(CONST.PERFILES['GESTIAFORMLBK']) && me.lookupController().getViewModel().get('activo').get('isCarteraLiberbank')) {
	    		me.add({xtype: 'administracionactivo', ocultarBotonesEdicion: true});
	    	} else {
	    		$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'administracionactivo', ocultarBotonesEdicion: false})}, 'TAB_ACTIVO_ADMINISTRACION');
	    	}
	    			
	    	me.add({xtype: 'patrimonioactivo', ocultarBotonesEdicion: true});
	
	    	me.add({xtype: 'plusvaliaactivo', ocultarBotonesEdicion: !$AU.userHasFunction('EDITAR_TAB_ACTIVO_PLUSVALIA')});
	    }else{
	    	me.tabsDeBBVA(me,editable); 
	    }

    	
    	
    	
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
    
    tabsDeBBVA: function(me, editable){
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'datosgeneralesactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_DATOS_GENERALES');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'tabdocumentosactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_DOCUMENTOS');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'agrupacionesactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_AGRUPACIONES');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'comercialactivo', ocultarBotonesEdicion: editable})}, 'TAB_ACTIVO_COMERCIAL');    			
    	me.add({xtype: 'patrimonioactivo', ocultarBotonesEdicion: true});
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'preciosactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_PRECIOS');
    	$AU.confirmFunToFunctionExecution(function(){me.add({xtype: 'publicacionactivo', ocultarBotonesEdicion: true})}, 'TAB_ACTIVO_PUBLICACION');
    }
});