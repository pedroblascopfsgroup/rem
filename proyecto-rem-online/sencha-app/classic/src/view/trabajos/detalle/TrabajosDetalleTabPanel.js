Ext.define('HreRem.view.trabajos.detalle.TrabajosDetalleTabPanel', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'trabajosdetalletabpanel',
	cls			: 'panel-base shadow-panel tabPanel-segundo-nivel',
	flex		: 1,
	layout		: 'fit',
    requires 	: ['HreRem.view.trabajos.detalle.TrabajoDetalleController', 'HreRem.view.trabajos.detalle.TrabajoDetalleModel', 'HreRem.ux.button.BotonFavorito',
    			'HreRem.view.trabajos.detalle.FichaTrabajo', 'HreRem.view.trabajos.detalle.ActivosTrabajo', 'HreRem.view.trabajos.detalle.TramitesTareasTrabajo',
    			'HreRem.view.trabajos.detalle.DocumentosTrabajo', 'HreRem.view.trabajos.detalle.FotosTrabajo', 'HreRem.view.trabajos.detalle.DiarioGestionesTrabajo', 
    			'HreRem.view.trabajos.detalle.GestionEconomicaTrabajo'],
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

			var tipoTrabajoCodigo = tabPanel.lookupController().getViewModel().get("trabajo.tipoTrabajoCodigo");
			var tab = null;
			switch (tipoTrabajoCodigo) {
				case CONST.TIPOS_TRABAJO["PRECIOS"]:
					tab = tabPanel.down("[xtype='fotostrabajo']");
					if(!Ext.isEmpty(tab)) {tab.setDisabled(true);}
					tab = tabPanel.down("[xtype='gestioneconomicatrabajo']")
					if(!Ext.isEmpty(tab)) {tab.setDisabled(true);}
					break;
					
				case CONST.TIPOS_TRABAJO["PUBLICACIONES"]:
					tab = tabPanel.down("[xtype='fotostrabajo']");
					if(!Ext.isEmpty(tab)) {tab.setDisabled(true);}
					tab = tabPanel.down("[xtype='gestioneconomicatrabajo']");
					if(!Ext.isEmpty(tab)) {tab.setDisabled(true);}
					break;
					
				case CONST.TIPOS_TRABAJO["COMERCIALIZACION"]:
					tab = tabPanel.down("[xtype='fotostrabajo']")
					if(!Ext.isEmpty(tab)) {tab.setDisabled(true);}
					tab = tabPanel.down("[xtype='gestioneconomicatrabajo']")
					if(!Ext.isEmpty(tab)) {tab.setDisabled(true);}
					break;
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
    	$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'fichatrabajo', funPermEdition: ['EDITAR_FICHA_TRABAJO']})}, ['TAB_FICHA_TRABAJO']),
    	$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'activostrabajo', ocultarBotonesEdicion: true})}, ['TAB_ACTIVOS_TRABAJO']),
    	$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'tramitestareastrabajo', ocultarBotonesEdicion: true})}, ['TAB_TRAMITES_TRABAJO']),
    	$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'diariogestionestrabajo', ocultarBotonesEdicion: true})}, ['TAB_DIARIO_GESTIONES_TRABAJO']),
    	$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'fotostrabajo', ocultarBotonesEdicion: true})}, ['TAB_FOTOS_TRABAJO']),
    	$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'documentostrabajo', ocultarBotonesEdicion: true})}, ['TAB_DOCUMENTOS_TRABAJO']),
    	$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'gestioneconomicatrabajo', funPermEdition: ['EDITAR_GESTION_ECONOMICA_TRABAJO']})}, ['TAB_GESTION_ECONOMICA_TRABAJO'])

        me.addPlugin({ptype: 'lazyitems', items: items});
        me.callParent();
    },

    evaluarBotonesEdicion: function(tab) {    	
		var me = this;
		me.down("[itemId=botoneditar]").setVisible(false);
		var editionEnabled = function() {
			var visible = false;
			var notFechaEjecucionReal = Ext.isEmpty(me.lookupController().getViewModel().get('trabajo').get('fechaEjecucionReal'));
			var notFechaCierreEconomico = Ext.isEmpty(me.lookupController().getViewModel().get('trabajo').get('fechaCierreEconomico'));
			var notFechaEmisionFactura = Ext.isEmpty(me.lookupController().getViewModel().get('trabajo').get('fechaEmisionFactura'));
			var isRolProveedor = $AU.userIsRol(CONST.PERFILES['PROVEEDOR']);
			var isRolGesActivo = $AU.userIsRol('HAYAGESACT');
			var isRolGesAdmision = $AU.userIsRol('HAYAGESTADM');
			var isRolSupActivo = $AU.userIsRol('HAYASUPACT');
			var isRolSupAdmision = $AU.userIsRol('HAYASUPADM');
			var isRolSuper = $AU.userIsRol('HAYASUPER');
			var subtipoTrabajoCod = me.lookupController().getViewModel().get('trabajo').get('subtipoTrabajoCodigo');
			var subtiposPermitidosSupActivo = ["19", "21", "22", "23", "24", "25"]; //Subtipos de trabajo ODoc. con edicion permitida en gestion eco trabajo para superv. activo
			var subtiposPermitidosSupAdmision = ["13", "15", "17"]; //Subtipos de trabajo ODoc. con edicion permitida en gestion eco trabajo para superv. admision
			
			if((notFechaEjecucionReal && (isRolProveedor))
				|| (notFechaCierreEconomico && (isRolGesActivo || isRolGesAdmision))
				|| (notFechaEmisionFactura && (isRolSupActivo || isRolSupAdmision || isRolSuper)) ){
				visible = true;
			}
			
			// Obtencion Documental: Gestor Activo y Admision tienen designados cada uno un grupo de tipos de documentos,
			// por tanto la misma responsabilidad para editar la gestion eco del trabajo debe designarse a sus supervisores.
			// Gestor activo no debe trabajar con los tipos designados para el gestor de admision y por tanto el supervisor
			// de uno no debe operar con la gestion eco para trabajos del otro supervisor.
			if((isRolSupAdmision && subtiposPermitidosSupActivo.indexOf(subtipoTrabajoCod) > -1)
					||(isRolSupActivo && subtiposPermitidosSupAdmision.indexOf(subtipoTrabajoCod) > -1) ){
				visible = false;
			}
			
			me.down("[itemId=botoneditar]").setVisible(visible);
		}

		// Si la pestaña recibida no tiene asignados roles de edicion 
		if(Ext.isEmpty(tab.funPermEdition)) {
    		editionEnabled();
    	} else {
    		$AU.confirmFunToFunctionExecution(editionEnabled, tab.funPermEdition);
    	}
    }
});