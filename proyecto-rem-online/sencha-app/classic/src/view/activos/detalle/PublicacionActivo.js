Ext.define('HreRem.view.activos.detalle.Publicacion', {
    extend		: 'Ext.tab.Panel',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    xtype		: 'publicacionactivo',
    reference	: 'publicacionactivoref',
    layout		: 'fit',
    requires	: ['HreRem.view.activos.detalle.InformeComercialActivo', 'HreRem.view.activos.detalle.DatosPublicacionActivo', 'HreRem.view.activos.detalle.FasePublicacionActivo', 'HreRem.view.activos.detalle.CalidadDatoPublicacionActivo'],

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
			var muestraEdicion = (me.up('activosdetallemain').getViewModel().getData().activo.getData().aplicaComercializar
			                        || me.up('activosdetallemain').getViewModel().getData().activo.getData().entidadPropietariaCodigo == CONST.CARTERA['BANKIA'])
					&& !me.up('activosdetallemain').getViewModel().getData().activo.getData().isVendido;
			var pestanyaInformeComercial = me.down('informecomercialactivo');
			var pestanyaDatosPublicacion = me.down('datospublicacionactivo');

			if(pestanyaInformeComercial != null){
				pestanyaInformeComercial.ocultarBotonesEdicion = !muestraEdicion;
			}
			if(pestanyaDatosPublicacion != null){
				pestanyaDatosPublicacion.ocultarBotonesEdicion = !muestraEdicion;
				me.up('activosdetallemain').getViewModel().get('filtrarComboMotivosOcultacionVenta');
				me.up('activosdetallemain').getViewModel().get('filtrarComboMotivosOcultacionAlquiler');
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

     evaluarBotonesEdicion: function(tab) {    
    	var me = this;
		me.down("[itemId=botoneditar]").setVisible(false);
		var editionEnabled = function(tab) {
			var visible = false;
			if(tab.xtype=='informecomercialactivo'){
				if (me.lookupController().getView().getViewModel().get('activo').data.isCarteraBankia 
						&& ($AU.userIsRol(CONST.PERFILES['HAYAGESTPUBL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']))
						&& $AU.userHasFunction('EDITAR_TAB_INFO_COMERCIAL_PUBLICACION')) {
					if (me.lookupController().getView().getViewModel().get('activo').data.situacionComercialCodigo != '05' 
						&& me.lookupController().getView().getViewModel().get('activo').data.aplicaComercializar) {
						visible = $AU.userHasFunction('EDITAR_TAB_INFO_COMERCIAL_PUBLICACION');
					}
				}else if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
					visible = (($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYAGESTPREC']) || $AU.userIsRol(CONST.PERFILES['HAYAGESTPUBL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
						 && $AU.userHasFunction('EDITAR_TAB_INFO_COMERCIAL_PUBLICACION'));
				}else{
					visible = $AU.userHasFunction('EDITAR_TAB_INFO_COMERCIAL_PUBLICACION');
				}
			}else if(tab.xtype=='datospublicacionactivo'){
				if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
					visible = (($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYAGESTPREC']) || $AU.userIsRol(CONST.PERFILES['HAYAGESTPUBL']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
						 && $AU.userHasFunction('EDITAR_TAB_DATOS_PUBLICACION'));
				}else{
					visible = $AU.userHasFunction('EDITAR_TAB_DATOS_PUBLICACION');
				}
				
				if(me.lookupController().getViewModel().get('activo').get('perteneceAgrupacionRestringidaVigente')){
					visible = false;
				}
			}else if(tab.xtype=='fasepublicacionactivo') {
				visible = me.lookupController().getViewModel().get('activo').get('mostrarEditarFasePublicacion');
			}
			me.down("[itemId=botoneditar]").setVisible(visible);
		}

		//HREOS-846 Si NO esta dentro del perimetro, no se habilitan los botones de editar
		if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="true"  && !me.lookupController().getViewModel().get('activo').get('isActivoEnTramite')) {
			// Si la pestaña recibida no tiene asignadas funciones de edicion 
			if(Ext.isEmpty(tab.funPermEdition)) {
	    		editionEnabled(tab);
	    	} else {
	    		$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
	    	} 
		}
    },

    initComponent: function () {
    	var me = this;
    	me.setTitle(HreRem.i18n('title.publicacion.activo'));

    	//HREOS-1964: Restringir los activos financieros (asistidos) para que solo puedan ser editables por los perfiles de IT y Gestoria PDV
		var ocultarInformecomercialactivo = false;		
		if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
			ocultarInformecomercialactivo = !(($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
				 && $AU.userHasFunction('TAB_INFO_COMERCIAL_PUBLICACION'));
		}else{
			ocultarInformecomercialactivo = !$AU.userHasFunction('TAB_INFO_COMERCIAL_PUBLICACION');
		}
		
		var ocultarDatospublicacionactivo = false;		
		if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
			ocultarDatospublicacionactivo = !(($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
				 && $AU.userHasFunction('TAB_DATOS_PUBLICACION'));
		}else{
			ocultarDatospublicacionactivo = !$AU.userHasFunction('TAB_DATOS_PUBLICACION');
		}
		
		var ocultarDatosFasePublicacion = false;
		var datosDeActivo = me.lookupController().getViewModel().get('activo');

		if(datosDeActivo.get('perteneceAgrupacionRestringidaVigente') && datosDeActivo.get('activoPrincipalRestringida') != datosDeActivo.get('numActivo')){
			ocultarDatosFasePublicacion = true;
		}
		
    	var items = [];
    	if(!$AU.userIsRol(CONST.PERFILES['CARTERA_BBVA'])) {
			$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'informecomercialactivo', ocultarBotonesEdicion: ocultarInformecomercialactivo})}, ['TAB_INFO_COMERCIAL_PUBLICACION']);
			$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'datospublicacionactivo', ocultarBotonesEdicion: ocultarDatospublicacionactivo})}, ['TAB_DATOS_PUBLICACION']);
			$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'fasepublicacionactivo', ocultarBotonesEdicion: ocultarDatosFasePublicacion})}, ['TAB_ACTIVO_PUBLICACION']);
			$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'calidaddatopublicacionactivo', ocultarBotonesEdicion: ocultarDatosFasePublicacion})}, ['TAB_ACTIVO_PUBLICACION']);
    	}else{
    		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'datospublicacionactivo', ocultarBotonesEdicion: true})}, ['TAB_DATOS_PUBLICACION']);
	    }
		
		me.addPlugin({ptype: 'lazyitems', items: items});
		me.callParent();
    },

    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.getActiveTab().funcionRecargar();
    }
});