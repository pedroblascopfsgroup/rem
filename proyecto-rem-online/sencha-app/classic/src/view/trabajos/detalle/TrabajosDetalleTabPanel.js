Ext.define('HreRem.view.trabajos.detalle.TrabajosDetalleTabPanel', {
    extend		: 'Ext.tab.Panel',
    xtype		: 'trabajosdetalletabpanel',
	cls			: 'panel-base shadow-panel tabPanel-segundo-nivel',
	flex: 1,
	layout		: 'fit',
    requires : ['HreRem.view.trabajos.detalle.TrabajoDetalleController', 'HreRem.view.trabajos.detalle.TrabajoDetalleModel', 'HreRem.ux.button.BotonFavorito',
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
        		}]
    },
    items: [
    		
    		{	xtype: 'fichatrabajo', funPermEdition: ['EDITAR_FICHA_TRABAJO']},
    		{	xtype: 'activostrabajo',  ocultarBotonesEdicion: true},
    		{	xtype: 'tramitestareastrabajo', ocultarBotonesEdicion: true},
    		{	xtype: 'diariogestionestrabajo', ocultarBotonesEdicion: true},
    		{	xtype: 'fotostrabajo', ocultarBotonesEdicion: true},
    		{	xtype: 'documentostrabajo', ocultarBotonesEdicion: true},
    		{	xtype: 'gestioneconomicatrabajo',funPermEdition: ['EDITAR_GESTION_ECONOMICA_TRABAJO']}

    ],
    
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
    }
    
});