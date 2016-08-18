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
   					var tab = tabPanel.getActiveTab();
   					
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