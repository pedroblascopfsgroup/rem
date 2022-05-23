Ext.define('HreRem.view.activos.detalle.AdmisionActivo', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'admisionactivo',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    reference	: 'admision',
    layout		: 'fit',
	//requires	: ['HreRem.view.activos.detalle.AdmisionCheckInfoActivo', 'HreRem.view.activos.detalle.AdmisionCheckDocActivo', 
	//				'HreRem.view.activos.detalle.SaneamientoActivoDetalle', 'HreRem.view.activos.detalle.AdmisionRevisionTitulo', 'HreRem.view.activos.detalle.EvolucionActivoDetalle'],
	requires	: ['HreRem.view.activos.detalle.AdmisionCheckDocActivo', 'HreRem.view.activos.detalle.SaneamientoActivoDetalle', 'HreRem.view.activos.detalle.AdmisionRevisionTitulo', 
		'HreRem.view.activos.detalle.EvolucionActivoDetalle'],
    listeners	: {
    	boxready: function (tabPanel) {
    		var tab = tabPanel.getActiveTab();
    		if(!Ext.isDefined(tab)){
	    	  	tab = tabPanel.items.items[0];
	    	  	tabPanel.setActiveTab(tab);
	    	}
			// Si la pestaña necesita botones de edicion
    		if(Ext.isDefined(tab)){
				if(tab.ocultarBotonesEdicion) {
					tabPanel.down("[itemId=botoneditar]").setVisible(false);
				} else {
					tabPanel.evaluarBotonesEdicion(tab);
				}
    		}
		},
		show: function () {
			var me = this;
			if ( me.getActiveTab() ) {
				me.verifyProxyObservaciones(me.getActiveTab());
			}
		},
       tabchange: function (tabPanel, newCard, oldCard, eOpts) {
       		var me = this;
       		me.verifyProxyObservaciones(newCard);
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
        		}]
    },

	initComponent: function () {
	     var me = this;
	     me.setTitle(HreRem.i18n('title.admision'));

		 var ocultarAdmisionCheckEdicion = (!$AU.userIsRol(CONST.PERFILES['GESTOR_ADMISION']) || $AU.userIsRol(CONST.PERFILES['CARTERA_BBVA']));
		 ocultarAdmisionCheckEdicion = ($AU.userIsRol(CONST.PERFILES['HAYASUPER'])) ? false : ocultarAdmisionCheckEdicion;

	     var items = [];
	     //$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'admisioncheckdocactivo', ocultarBotonesEdicion: ocultarAdmisioncheckdocactivo, title: HreRem.i18n('title.admision.check.doc.activo')})}, ['TAB_CHECKING_DOC_ADMISION']);
	     $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'admisionrevisiontitulo' ,ocultarBotonesEdicion: ocultarAdmisionCheckEdicion, title: HreRem.i18n('title.admision.tab.revision.titulo')})}, ['TAB_CHECKING_INFO_ADMISION']);
	     $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'saneamientoactivo',ocultarBotonesEdicion: ocultarAdmisionCheckEdicion, title: HreRem.i18n('title.admision.check.inf.activo')})}, ['TAB_CHECKING_INFO_ADMISION']);
	     $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'evolucionactivo', ocultarBotonesEdicion: ocultarAdmisionCheckEdicion, title: HreRem.i18n('title.admision.check.inf.activo')})}, ['TAB_CHECKING_INFO_ADMISION']);
	     
	     
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
			me.down("[itemId=botoneditar]").setVisible(true);
/*			//HREOS-1964: Restringir los activos financieros (asistidos) para que solo puedan ser editables por los perfiles de IT y Gestor�a PDV
			 var ocultarAdmisioncheckinfoactivo = false;		
			 if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
				 ocultarAdmisioncheckinfoactivo = (($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER'])) 
						 && $AU.userHasFunction('EDITAR_CHECKING_INFO_ADMISION'));
			 }else{
				 ocultarAdmisioncheckinfoactivo = $AU.userHasFunction('EDITAR_CHECKING_INFO_ADMISION');
			 }
			me.down("[itemId=botoneditar]").setVisible(ocultarAdmisioncheckinfoactivo);
			*/
		}
		//HREOS-846 Si NO esta dentro del perimetro, no se habilitan los botones de editar
		if(me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="true"  && !me.lookupController().getViewModel().get('activo').get('isActivoEnTramite')) {
			// Si la pestaña recibida no tiene asignados roles de edicion 
			if(Ext.isEmpty(tab.funPermEdition)) {
	    		editionEnabled();
	    	} else {
	    		$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
	    	}
		}
    },
    
    verifyProxyObservaciones: function ( tab ) {
       		var observacionesGrid = null;
       		var childs = tab.items.items;
       		var evolucionactivo = "evolucionactivo";
       		if ( childs.length > 0 ) {
	       		for (var i = 0; i < childs.length; i++) {
	       			var child = childs [i];
	       			if(!evolucionactivo.includes(tab.config.xtype.valueOf())){
	       				for (var j = 0; j < child.items.items.length; j++ ) {
	       					if ("observacionesactivo".includes(child.items.items[j].xtype)){
	       						observacionesGrid = child.items.items[j];
	       					}
	       				}
	       			}

	       		}
	       		if ( observacionesGrid  && typeof observacionesGrid.buildStoreWithProxy === 'function') {
	       			observacionesGrid.buildStoreWithProxy(observacionesGrid);
	       		}
       		}
    }
    
   
});