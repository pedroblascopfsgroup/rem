Ext.define('HreRem.view.activos.detalle.TabDocumentosActivo', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'tabdocumentosactivo',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    reference	: 'tabdocumentosactivoref',
    layout		: 'fit',
	//requires	: ['HreRem.view.activos.detalle.AdmisionCheckInfoActivo', 'HreRem.view.activos.detalle.DocumentosActivo'],
	requires	: ['HreRem.view.activos.detalle.DocumentosActivo'],
    listeners	: {
    	boxready: function (tabPanel) {
    		var tab = tabPanel.getActiveTab();
    		if(!Ext.isDefined(tab)){
	    	  	tab = tabPanel.items.items[0];
	    	  	tabPanel.setActiveTab(tab);
	    	}
			// Si la pestaña necesita botones de edicion
    		/*if(Ext.isDefined(tab)){
				if(tab.ocultarBotonesEdicion) {
					tabPanel.down("[itemId=botoneditar]").setVisible(false);
				} else {
					tabPanel.evaluarBotonesEdicion(tab);
				}
    		}*/
		}
    },


	initComponent: function () {
	     var me = this;
	     me.setTitle(HreRem.i18n('title.documentos'));
	     
	     
		 var ocultarDocumentosCheckDocsActivo = false;		
		 if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
			 ocultarDocumentosCheckDocsActivo = !(($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
					 && $AU.userHasFunction('EDITAR_CHECKING_INFO_ADMISION'));
		 }else{
			 ocultarDocumentosCheckDocsActivo = !$AU.userHasFunction('EDITAR_CHECKING_INFO_ADMISION');
		 }
		 
		 var ocultarAdmisioncheckdocactivo = false;		
		 if(me.lookupController().getViewModel().get('activo').get('claseActivoCodigo')=='01'){
			 ocultarAdmisioncheckdocactivo = !(($AU.userIsRol(CONST.PERFILES['GESTOPDV']) || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['HAYACAL']) || $AU.userIsRol(CONST.PERFILES['HAYASUPCAL'])) 
					 && $AU.userHasFunction('EDITAR_CHECKING_DOC_ADMISION'));
		 }else{
			 ocultarAdmisioncheckdocactivo = !$AU.userHasFunction('EDITAR_CHECKING_DOC_ADMISION');
		 }

		 
	     var items = [];
	    
	     $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'documentosactivo', ocultarBotonesEdicion: ocultarDocumentosCheckDocsActivo, title: HreRem.i18n('title.documentos')})}, ['TAB_ACTIVO_DOCUMENTOS']);
	     $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'admisioncheckdocactivo', ocultarBotonesEdicion: ocultarAdmisioncheckdocactivo, title: HreRem.i18n('title.admision.check.doc.activo')})}, ['TAB_CHECKING_DOC_ADMISION']);
	     me.addPlugin({ptype: 'lazyitems', items: items });
	     me.callParent();
	 },
	 
	 funcionRecargar: function() {
			var me = this;
			me.recargar = false;
			me.getActiveTab().funcionRecargar();
	 }

});