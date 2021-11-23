Ext.define('HreRem.view.activos.detalle.PreciosActivo', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'preciosactivo',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    reference	: 'precios',
    layout		: 'fit',
    requires	: ['HreRem.view.activos.detalle.ValoresPreciosActivo', 'HreRem.view.activos.detalle.TasacionesActivo', 'HreRem.view.activos.detalle.PropuestasPreciosActivo'],
    listeners	: {
    	boxready: function (tabPanel) {
    		
    		var me = this;
			var tab = tabPanel.getActiveTab();
			if(!Ext.isDefined(tab)){
    			tab = tabPanel.items.items[0];
    			tabPanel.setActiveTab(tab);
    		}
			// Si la pestaña necesita botones de edicion
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
     	me.setTitle(HreRem.i18n('title.precios'));
     	//HREOS-1964: Restringir los activos financieros (asistidos) para que solo puedan ser editables por los perfiles de IT y Gestor�a PDV
		var ocultarValorespreciosactivo = false;		
		if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
		 ocultarValorespreciosactivo = !(($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
				 && $AU.userHasFunction('EDITAR_TAB_VALORACIONES_PRECIOS'));
		}else{
		 ocultarValorespreciosactivo = !$AU.userHasFunction('EDITAR_TAB_VALORACIONES_PRECIOS');
		}
		
		var ocultarEdicionTasacionesActivo = !(me.lookupController().getViewModel().get('activo').get('entidadPropietariaCodigo') == CONST.CARTERA['TITULIZADA'] 
					&& ($AU.userIsRol(CONST.PERFILES['GESTOR_PRECIOS']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['SUPERVISOR_PRECIOS'])));

     	var items = [];
     	$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'valorespreciosactivo', ocultarBotonesEdicion: ocultarValorespreciosactivo})}, ['TAB_VALORACIONES_PRECIOS']);
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'tasacionesactivo', ocultarBotonesEdicion: ocultarEdicionTasacionesActivo})}, ['TAB_TASACIONES']);
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'propuestaspreciosactivo', ocultarBotonesEdicion: true})}, ['TAB_PROPUESTAS_PRECIO']);
        me.addPlugin({ptype: 'lazyitems', items: items });
     	me.callParent();
     },

     funcionRecargar: function() {
 		var me = this;
 		me.recargar = false;
 		me.getActiveTab().funcionRecargar();
     },
     
     evaluarBotonesEdicion: function(tab) {    	
    	var me = this;
		me.down("[itemId=botoneditar]").setVisible(false);
		var editionEnabled = function() {
			//HREOS-1964: Restringir los activos financieros (asistidos) para que solo puedan ser editables por los perfiles de IT y Gestor�a PDV
			 var ocultarValorespreciosactivo = false;		
			 if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
				 ocultarValorespreciosactivo = (($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
						 && $AU.userHasFunction('EDITAR_TAB_VALORACIONES_PRECIOS'));
			 }else{
				 ocultarValorespreciosactivo = $AU.userHasFunction('EDITAR_TAB_VALORACIONES_PRECIOS');
			 }
			me.down("[itemId=botoneditar]").setVisible(ocultarValorespreciosactivo);
		}

		//HREOS-846 Si NO esta dentro del perimetro, no se habilitan los botones de editar
		if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="true" && !me.lookupController().getViewModel().get('activo').get('isActivoEnTramite')) {
			// Si la pestaña recibida no tiene asignados roles de edicion 
			if(Ext.isEmpty(tab.funPermEdition)) {
	    		editionEnabled();
	    	} else {
	    		$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
	    	}
		}
	 }
});