Ext.define('HreRem.view.activos.detalle.AdmisionActivoTabPanel', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'admisionactivotabpanel',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    reference	: 'tabpanelAdmision',
    layout		: 'fit',
    requires	: ['HreRem.view.activos.detalle.AdmisionCheckInfoActivo', 'HreRem.view.activos.detalle.AdmisionCheckDocActivo'],
    listeners	: {
    	boxready: function (tabPanel) {
    		var tab = tabPanel.getActiveTab();

			// Si la pestaña necesita botones de edicion
			if(tab.ocultarBotonesEdicion) {
				tabPanel.down("[itemId=botoneditar]").setVisible(false);
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
        		}]
    },

	initComponent: function () {
	     var me = this;
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

	     me.items = [];
	     $AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'admisioncheckinfoactivo', ocultarBotonesEdicion: ocultarAdmisioncheckinfoactivo, title: HreRem.i18n('title.admision.check.inf.activo')})}, ['TAB_CHECKING_INFO_ADMISION']);
	     $AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'admisioncheckdocactivo', ocultarBotonesEdicion: ocultarAdmisioncheckdocactivo, title: HreRem.i18n('title.admision.check.doc.activo')})}, ['TAB_CHECKING_DOC_ADMISION']);

	     me.callParent();
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