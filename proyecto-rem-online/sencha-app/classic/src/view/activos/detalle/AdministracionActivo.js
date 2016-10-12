Ext.define('HreRem.view.activos.detalle.AdministracionActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'administracionactivo',    
    reference: 'administracionactivoref',
	layout: 'fit',
	scrollable	: 'y',
	
//	listeners: { 	
//    	boxready: function (tabPanel) { 
//    		tabPanel.evaluarEdicion();
//    	}
//    },
    
    initComponent: function () {

        var me = this;
        me.setTitle(HreRem.i18n('title.administracion.activo'));	        
        var items= [

        
         {
			xtype:'fieldsettable',
			title: HreRem.i18n('title.administracion.activo.proveedores'),
			collapsible: false,
			items :	[
				{
				    xtype		: 'gridBase',
				    idPrincipal : 'activo.id',
				    minHeight: 260,
	//			    topBar: true,
				    reference: 'listadoproveedoresref',
					cls	: 'panel-base shadow-panel',
					bind: {
						store: '{storeProveedores}'
					},
					
					columns: [
					   {    text: HreRem.i18n('title.activo.administracion.numProveedor'),
				        	dataIndex: 'codigoProveedor',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.tipo'),
				        	dataIndex: 'tipoProveedorDescripcion',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.subtipo'),
				        	dataIndex: 'subtipo',
				        	hidden: true,
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.nif'),
				        	dataIndex: 'numDocumentoProveedor',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.nombre'),
				        	dataIndex: 'nombreProveedor',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.estado'),
				        	dataIndex: 'estadoProveedorDescripcion',
				        	flex: 1
				       },
				       {    text: HreRem.i18n('title.activo.administracion.porcentajeParticipacion'),
				        	dataIndex: 'porcentajeParticipacion',
				        	flex: 1,
				        	hidden: true
				       }
					  
				       
				       	        
				    ],
	//			    listeners : {
	//   	                beforeedit : function(editor, context, eOpts ) {
	//   	                    var idUsuario = context.record.get("idUsuario");
	//   	                	if (!Ext.isEmpty(idUsuario))
	//   	                	{
	//	   	                    var allowEdit = $AU.sameUserPermToEnable(idUsuario);
	//	   	                    this.editOnSelect = allowEdit;
	//	   	                    return allowEdit;
	//   	                	}
	//	                }
	//	            },
		            
	//	            onGridBaseSelectionChange: function (grid, records) {
	//	            	if(!records.length)
	//            		{
	//            			
	//            			me.down('#removeButton').setDisabled(true);
	//            			if (!me.down("gridBaseEditableRow").getPlugin("rowEditingPlugin").editing)
	//            			{
	//            				me.down('#addButton').setDisabled(false);
	//            			}
	//            		}
	//            		else
	//            		{
	//            			var idUsuario = records[0].get("idUsuario");
	//            			var allowRemove = $AU.sameUserPermToEnable(idUsuario);
	//            			if (!me.down("gridBaseEditableRow").getPlugin("rowEditingPlugin").editing)
	//            			{
	//            				me.down('#removeButton').setDisabled(!allowRemove);
	//            			}
	//            		}
	//	            },
	//	           
				    dockedItems : [
				        {
				            xtype: 'pagingtoolbar',
				            dock: 'bottom',
				            displayInfo: true,
				            bind: {
				                store: '{storeProveedores}'
				            }
				        }
				    ]
				    
				}
			]
			},
			
			{
			xtype:'fieldsettable',
			title: HreRem.i18n('title.administracion.activo.listado.gastos'),
			collapsible: false,
			items :	[
			{
			    xtype		: 'gridBase',
			    idPrincipal : 'activo.id',
			    minHeight: 260,
//			    topBar: true,
			    reference: 'listadogastosref',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeGastosProveedor}'
				},
				
				columns: [
				   {    text: HreRem.i18n('title.activo.administracion.numGasto'),
			        	dataIndex: 'numGasto',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.tipo'),
			        	dataIndex: 'tipo',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.subtipo'),
			        	dataIndex: 'subtipo',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.concepto'),
			        	dataIndex: 'concepto',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.emisor'),
			        	dataIndex: 'emisor',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.fecha.emision'),
			        	formatter: 'date("d/m/Y")',
			        	dataIndex: 'fechaEmision',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.periodicidad'),
			        	dataIndex: 'periodicidad',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.importe'),
			        	dataIndex: 'importe',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.estado'),
			        	dataIndex: 'estado',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.fecha.pago'),
			        	formatter: 'date("d/m/Y")',
			        	dataIndex: 'fechaPago',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.afecta.otros.activos'),
			        	dataIndex: 'afectaOtrosActivos',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.observaciones'),
			        	dataIndex: 'observaciones',
			        	flex: 1
			       }
				  				       
			       	        
			    ],
//			    listeners : {
//   	                beforeedit : function(editor, context, eOpts ) {
//   	                    var idUsuario = context.record.get("idUsuario");
//   	                	if (!Ext.isEmpty(idUsuario))
//   	                	{
//	   	                    var allowEdit = $AU.sameUserPermToEnable(idUsuario);
//	   	                    this.editOnSelect = allowEdit;
//	   	                    return allowEdit;
//   	                	}
//	                }
//	            },
	            
//	            onGridBaseSelectionChange: function (grid, records) {
//	            	if(!records.length)
//            		{
//            			
//            			me.down('#removeButton').setDisabled(true);
//            			if (!me.down("gridBaseEditableRow").getPlugin("rowEditingPlugin").editing)
//            			{
//            				me.down('#addButton').setDisabled(false);
//            			}
//            		}
//            		else
//            		{
//            			var idUsuario = records[0].get("idUsuario");
//            			var allowRemove = $AU.sameUserPermToEnable(idUsuario);
//            			if (!me.down("gridBaseEditableRow").getPlugin("rowEditingPlugin").editing)
//            			{
//            				me.down('#removeButton').setDisabled(!allowRemove);
//            			}
//            		}
//	            },
//	           
			    dockedItems : [
			        {
			            xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            displayInfo: true,
			            bind: {
			                store: '{storeGastosProveedor}'
			            }
			        }
			    ]
			    
			}
			]
		}
            
            
        ];
        
		me.addPlugin({ptype: 'lazyitems', items: items });
		
    	me.callParent();
    	
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    }
    
    


    
});