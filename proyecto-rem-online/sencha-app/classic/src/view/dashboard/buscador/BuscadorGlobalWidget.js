Ext.define('HreRem.view.dashboard.buscador.BuscadorGlobalWidget', {
	extend		: 'Ext.form.Panel',
	xtype		: 'buscadorglobalwidget',
	reference	: 'buscadorGlobalWidget',
	padding		: '20 0 20 0',
	margin		: 10,
	layout		: 'hbox',
	controller 	: 'buscadorglobal',
    viewModel: {
        type: 'buscadorglobal'
    },
	
	initComponent: function() {
		
		var me = this;
		
		me.panelGlobalFilter = Ext.create('HreRem.view.dashboard.buscador.GlobalFilter');
		me.panelGlobalFilter.show();
		me.panelGlobalFilter.hide();
		
		me.items= [
		
					{
						xtype: 'button',
						cls: 'search-button-buscador',
						iconCls: 'app-buscador-ico ico-search',
						height: 35,
						width: 30,
						handler: 'onClickSearch'				
						
					},
		
		
		
					{			
						xtype: 'textfield',
						reference: 'buscadorGlobalField',
						flex: 2,
						cls: 'searchfield-input sf-con-borde',
						height: 33,
						emptyText: 'Buscar activos, ofertas, solicitudes.........',
						enableKeyEvents: true,
			            listeners: {
			                specialKey: 'onSpecialKey'
			            }
						//inputStyle:"border:none 0px transparent",
						/*triggers: {
							
							triggerfilter: {
						            cls: 'trigger-filter-searchfield',
						            border: 'none',
						            handler: function(textfield, btn) {
						            	var me = this;
						            	var panelGlobalFilter = me.up('buscadorglobalwidget').panelGlobalFilter;
						          		panelGlobalFilter.setWidth(me.getWidth()-2);
						            	panelGlobalFilter.setPosition(me.getXY()[0], me.getXY()[1] + me.getHeight()-1);
						            	debugger;
						            	
						            	if (panelGlobalFilter.hidden) {
						            		textfield.addCls("sf-sin-borde");
						            		textfield.removeCls("sf-con-borde");
						            		textfield.getTrigger("triggerfilter").el.addCls("trigger-filter-expanded");
						            		panelGlobalFilter.show();

						            	} else {
						            		textfield.addCls("sf-con-borde");
						            		textfield.removeCls("sf-sin-borde");
						            		textfield.getTrigger("triggerfilter").el.removeCls("trigger-filter-expanded");
						            		panelGlobalFilter.hide();
						            	}
						            },
						            listeners: {
								        render: function () {
								            var triggerEl = this.getTrigger('triggerfilter').el;
								            triggerEl.dom.setAttribute('data-qtip', 'Ver/Ocultar filtro avanzado');
								        }
								    }
						        }/*,	
							triggersearch: {
						            cls: 'trigger-search-searchfield',
						            tooltip: 'Buscar',
						            border: 'none',
						            handler: function() {
						                alert('Buscando...............')
						            },
						            listeners: {
							        render: function () {
							            var triggerEl = this.getTrigger('triggersearch').el;
							            triggerEl.dom.setAttribute('data-qtip', 'Buscar');
							        }
							    }
						    }			            	
						}*/
			            
					},
					{
					
						xtype: 'button',
						reference: 'btnGlobalFilter',
						cls: 'filter-button-buscador',
						iconCls: 'app-buscador-ico ico-chevron-down',
						height: 35,
						width: 30,
						handler: function(btn) {
							var me = this,
							buscador = me.up('buscadorglobalwidget'),
			            	panelGlobalFilter = buscador.panelGlobalFilter,
			            	textfield = buscador.down('textfield');
			            	
			          		panelGlobalFilter.setWidth(textfield.getWidth()-2);
			            	panelGlobalFilter.setPosition(textfield.getXY()[0], textfield.getXY()[1] + textfield.getHeight()-1);
			            	
			            	if (panelGlobalFilter.hidden) {
			            		//textfield.addCls("sf-sin-borde");
			            		//textfield.removeCls("sf-con-borde");
			            		me.addCls("trigger-filter-expanded");
			            		panelGlobalFilter.show();

			            	} else {
			            		//textfield.addCls("sf-con-borde");
			            		//textfield.removeCls("sf-sin-borde");
			            		me.removeCls("trigger-filter-expanded");
			            		panelGlobalFilter.hide();
			            	}
							
						}
					}
					
					
	
		];
		
		me.callParent();
		

	}

});