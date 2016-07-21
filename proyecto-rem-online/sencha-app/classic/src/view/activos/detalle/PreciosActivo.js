Ext.define('HreRem.view.activos.detalle.PreciosActivo', {
    extend: 'Ext.panel.Panel',
    xtype: 'preciosactivo',
    layout		: 'fit',
    requires: ['HreRem.view.activos.detalle.ValoresPreciosActivo', 'HreRem.view.activos.detalle.TasacionesActivo', 'HreRem.view.activos.detalle.PropuestasPreciosActivo'],    
    initComponent: function () {
    	
    	var me = this;
    	
    	var items = [
    	
    	
			{				
			    xtype		: 'tabpanel',
				cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
			    reference	: 'tabpanelPrecios',
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
			    layout: 'fit',
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
			    		
			    		{
			    			xtype: 'valorespreciosactivo'		    			
			    		},
			    		{
			    			xtype: 'tasacionesactivo',
			    			ocultarBotonesEdicion: true
			    		},
			    		{
			    			xtype: 'propuestaspreciosactivo',
			    			ocultarBotonesEdicion: true
			    		}	    		
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
			}   	
    	];

    	me.setTitle(HreRem.i18n('title.precios'));
		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
    },
    
    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.down('tabpanel').getActiveTab().funcionRecargar();
		
    }    
});