Ext.define('HreRem.view.administracion.gastos.GestionGastos', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'gestiongastos',
//    requires	: [],
//	layout: 'fit',
	scrollable: true,
	cls	: 'panel-base shadow-panel',
	scrollable	: 'y',
//	cls	: 'panel-base shadow-panel tabPanel-tercer-nivel',
    initComponent: function () {        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.gastos.gestion.gastos"));
        
        var items = [
        
	        {
	        	xtype:'fieldset',
	        	collapsible: true,
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.filtro.gastos'),
				flex: 1,
				layout: 'fit',
//				collapsed: true,
				scrollable	: 'y',
				items :
					[
		                 {
				        	xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							collapsed: true,
							title: HreRem.i18n('title.filtro.por.situacion.gasto'),
							items :
								[
					                
									
								]
				        	
				        },
				        {
				        	xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							collapsed: true,
							title: HreRem.i18n('title.filtro.por.gasto'),
							items :
								[
					                
									
								]
				        	
				        },
				        {
				        	xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							collapsed: true,
							title: HreRem.i18n('title.filtro.por.proveedor'),
							items :
								[
					                
									
								]
				        	
				        },
				        {
				        	xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							collapsed: true,
							title: HreRem.i18n('title.filtro.por.activo.agrupacion'),
							items :
								[
					                
									
								]
				        	
				        },
				        {
				        	xtype:'fieldset',
							border: false,
							collapsible: false,
							items :
								[
									{
										xtype: 'button',
										text: HreRem.i18n('fieldlabel.gasto.buscar'),
										margin: '0 0 10 0',
										//handler: 'onClickBotonFavoritos'
										disabled: true
									},
									{
										xtype: 'button',
										text: HreRem.i18n('fieldlabel.gasto.limpiar'),
										margin: '0 0 10 10',
										//handler: 'onClickBotonFavoritos'
										disabled: true
									}
								]
				        }
				        
				        
						
					]
	        	
	        },
        
        			
	        {xtype: 'gridBase',
    	           bind: {
    	           	store: '{gastosAdministracion}'
    	           },
    	           listeners:{
    	        	   rowdblclick: 'onClickAbrirGastoProveedor'
    	           },
    	           reference: 'listadoGastos',
    	           columns: [
	 							{   
	 								text: HreRem.i18n('header.id.gasto'),
						        	dataIndex: 'id',
						        	flex: 1,
						        	hidden: true,
						        	hideable: false
						       	},
						       	{   
						        	dataIndex: 'numGastoHaya',
						        	flex: 1,
						        	hidden: true,
						        	hideable: false
						       	},
	    	                     {
									text: HreRem.i18n('header.num.factura.liquidacion'),
									dataIndex: 'numFactura',
									flex: 1
							   },
	    	                     
	    	                     {
	    	                    	 text: HreRem.i18n('header.tipo.gasto'),
	    	                    	 flex: 1,
	    	                    	 dataIndex: 'tipo'
	    	                     },
	    	                     {
	    	                    	 text: HreRem.i18n('header.subtipo.gasto'),
	    	                    	 flex: 1,
	    	                    	 dataIndex: 'subtipo'
	    	                     },
	    	                     {
	    	                    	 text: HreRem.i18n('header.concepto.gasto'),
	    	                    	 flex: 1,
	    	                    	 dataIndex: 'concepto'
	    	                     },
	    	                     {
	    	                    	 text: HreRem.i18n('header.proveedor.gasto'),
	    	                    	 flex: 1,
	    	                    	 dataIndex: 'codigoProveedor'
	    	                     },
	    	                     {
	    	                     	text: HreRem.i18n('header.fecha.emision.gasto'),
	    	                     	flex: 1,
	    	                    	dataIndex: 'fechaEmision',
		   	                    	formatter: 'date("d/m/Y")'	
	    	                     },
	    	                     {
	    	                    	 text: HreRem.i18n('header.importe.gasto'),
	    	                    	 flex: 1,
	    	                    	 dataIndex: 'importeTotal'
	    	                     },
	    	                     {
	    	                     	text: HreRem.i18n('header.fecha.tope.pago.gasto'),
	    	                     	flex: 1,
	    	                    	dataIndex: 'fechaTopePago',
	    	                    	formatter: 'date("d/m/Y")'	
	    	                     },
	    	                     {
	    	                     	text: HreRem.i18n('header.fecha.pago.gasto'),
	    	                     	flex: 1,
	    	                    	dataIndex: 'fechaPago',
	    	                    	formatter: 'date("d/m/Y")'	
	    	                     },
	    	                     {
	    	                    	 text: HreRem.i18n('header.periodicidad.gasto'),
	    	                    	 flex: 1,
	    	                    	 dataIndex: 'periodicidad'
	    	                     },
	    	                     {
	    	                    	 text: HreRem.i18n('header.destinatario.gasto'),
	    	                    	 flex: 1,
	    	                    	 dataIndex: 'destinatario'
	    	                     }
    	                    ],
    	                     dockedItems : [
					        {
					            xtype: 'pagingtoolbar',
					            dock: 'bottom',
					            displayInfo: true,
					            bind: {
					                store: '{gastosAdministracion}'
					            }
					        }
					    ]}
        
        ];
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent(); 
        
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().loadPage(1);
  		});
    } 


});