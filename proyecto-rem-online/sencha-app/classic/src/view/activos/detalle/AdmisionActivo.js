Ext.define('HreRem.view.activos.detalle.AdmisionActivo', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'admisionactivo',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    reference	: 'admision',
    layout		: 'fit',
    requires	: ['HreRem.view.activos.detalle.AdmisionCheckInfoActivo', 'HreRem.view.activos.detalle.AdmisionCheckDocActivo', 
    				'HreRem.view.activos.detalle.SaneamientoActivoDetalle', 'HreRem.view.activos.detalle.AdmisionRevisionTitulo', 'HreRem.view.activos.detalle.EvolucionActivoDetalle'],
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
        
       },
       tabchange: function (tabPanel, newCard, oldCard, eOpts) {
       		var targetTab = null;
       		var childs = newCard.items.items;
       		if ( childs.length > 0 ) {
	       		for (var i = 0; i < childs.length; i++) {
	       			var child = childs [i];
	       			for (var j = 0; j < child.items.items.length; j++ ) {
	       				if ("observacionesactivo".includes(child.items.items[j].xtype)){
	       					targetTab = child.items.items[j];
	       				}
	       			}
	       		}
	       		if ( targetTab  && typeof targetTab.buildStoreWithProxy === 'function') {
	       			targetTab.buildStoreWithProxy(targetTab);
	       		}
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
	     //HREOS-1964: Restringir los activos financieros (asistidos) para que solo puedan ser editables por los perfiles de IT y Gestor�a PDV
		 var ocultarAdmisioncheckinfoactivo = false;		
		 if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
			 ocultarAdmisioncheckinfoactivo = !(($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
					 && $AU.userHasFunction('EDITAR_CHECKING_INFO_ADMISION'));
		 }else{
			 ocultarAdmisioncheckinfoactivo = !$AU.userHasFunction('EDITAR_CHECKING_INFO_ADMISION');
		 }
		 
		 var ocultarAdmisioncheckdocactivo = false;		
		 if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
			 ocultarAdmisioncheckdocactivo = !(($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
					 && $AU.userHasFunction('EDITAR_CHECKING_DOC_ADMISION'));
		 }else{
			 ocultarAdmisioncheckdocactivo = !$AU.userHasFunction('EDITAR_CHECKING_DOC_ADMISION');
		 }
		 var ocultarSaneamientoCheckEdicion =!(($AU.userIsRol(CONST.PERFILES['HAYAGESTADM']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER'])));
//		 if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
//			 ocultarSaneamientoCheckEdicion = !(($AU.userIsRol(CONST.PERFILES['HAYAGESTADM']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER'])));
//		 }else{
//			 //pendiente de ver si se crea una funcion para esta pestaña.
//			 ocultarSaneamientoCheckEdicion = !(($AU.userIsRol(CONST.PERFILES['HAYAGESTADM']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER'])));
//		 }
		 var ocultarSaneamientoCheckEdicion =false;
		 if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
			 ocultarSaneamientoCheckEdicion = !(($AU.userIsRol(CONST.PERFILES['HAYAGESTADM']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER'])));
		 }
		 
	     var items = [];
	     $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'admisioncheckinfoactivo', ocultarBotonesEdicion: ocultarAdmisioncheckinfoactivo, title: HreRem.i18n('title.admision.check.inf.activo')})}, ['TAB_CHECKING_INFO_ADMISION']);
	     //$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'admisioncheckdocactivo', ocultarBotonesEdicion: ocultarAdmisioncheckdocactivo, title: HreRem.i18n('title.admision.check.doc.activo')})}, ['TAB_CHECKING_DOC_ADMISION']);
	     $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'saneamientoactivo',ocultarBotonesEdicion: ocultarSaneamientoCheckEdicion, title: HreRem.i18n('title.admision.check.inf.activo')})}, ['TAB_CHECKING_INFO_ADMISION']);
	     $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'evolucionactivo', ocultarBotonesEdicion: ocultarAdmisioncheckinfoactivo, title: HreRem.i18n('title.admision.check.inf.activo')})}, ['TAB_CHECKING_INFO_ADMISION']);
	     $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'admisionrevisiontitulo' ,ocultarBotonesEdicion: ocultarAdmisioncheckdocactivo, title: HreRem.i18n('title.admision.tab.revision.titulo')})}, ['TAB_CHECKING_INFO_ADMISION']);
	     
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
    }
});