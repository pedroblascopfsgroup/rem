Ext.define('HreRem.view.activos.detalle.AdministracionActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'administracionactivo',   
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'administracionactivoref',
//	layout: 'fit',
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
				    idPrincipal : 'id',
				    colspan: 3,
	//			    topBar: true,
				    reference: 'listadoproveedoresref',
					cls	: 'panel-base shadow-panel',
					bind: {
						store: '{storeProveedores}'
					},
					listeners : {
					    	rowclick: 'onProveedoresListClick'
					},
					viewConfig: { 
				        getRowClass: function(record) { 
				        	if(!Ext.isEmpty(record.get('fechaExclusion'))){
				        		return 'red-row-grid';
				        	}
				        } 
				    }, 
					
					columns: [
//						{    
//				        	dataIndex: 'id',
//				        	flex: 1
//				       },
					{	  
				        	xtype: 'actioncolumn',
				            dataIndex: 'codigoProveedorRem',
				            text: HreRem.i18n('title.activo.administracion.numProveedor'),
				            flex: 1,
				            items: [{
					            tooltip: HreRem.i18n('tooltip.ver.proveedor'),
					            getClass: function(v, metadata, record ) {
					            		//return 'ico-user'
					            		return 'fa-user blue-medium-color'
					            },
					            handler: 'abrirPestañaProveedor'
					        }],
					        renderer: function(value, metadata, record) {
					        	return '<div style="float:left; margin-top:3px; font-size: 11px; line-height: 1em;">'+ value+'</div>';
					        },
				            flex     : 1,            
				            align: 'right',
		//		            menuDisabled: true,
				            hideable: false,
				            sortable: true
				        },
//					   {    text: HreRem.i18n('title.activo.administracion.numProveedor'),
//				        	dataIndex: 'codigoProveedor',
//				        	flex: 1
//				       },
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
				       {    text: HreRem.i18n('title.activo.administracion.fecha.exclusion'),
				        	dataIndex: 'fechaExclusion',
				        	formatter: 'date("d/m/Y")',
				        	flex: 1
				       }
//				       {    text: HreRem.i18n('title.activo.administracion.porcentajeParticipacion'),
//				        	dataIndex: 'porcentajeParticipacion',
//				        	flex: 1,
//				        	hidden: true
//				       }
					  
				       
				       	        
				    ],

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
				    
				},
					
					
				{
					xtype: 'displayfieldbase',
					value: HreRem.i18n('title.activo.administracion.mensaje.proveedor.excluido'),
					fieldStyle: 'color: #FF0000;',
				    flex: 1
				}
			]
			},
			
			{
			xtype:'fieldsettable',
			title: HreRem.i18n('title.administracion.activo.listado.gastos'),
			collapsible: false,
//			scrollable: true,
			items :	[
			
			{
			    xtype		: 'gridBase',
			    idPrincipal : 'idGasto',
//			    topBar: true,
			    colspan: 3,
			    reference: 'listadogastosref',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeGastosProveedor}'
				},
				
				listeners: {
					rowdblclick: 'onClickAbrirGastoProveedor'	
				},
				
				columns: [
				
					{	  
				        	xtype: 'actioncolumn',
				            dataIndex: 'numGasto',
				            text: HreRem.i18n('title.activo.administracion.numGasto'),
				            flex: 1,
				            items: [{
					            tooltip: HreRem.i18n('tooltip.ver.gasto'),
					            getClass: function(v, metadata, record ) {
					            		return 'ico-pestana-gasto'
					            },
					            handler: 'onClickAbrirGastoProveedorIcono'
					        }],
					        renderer: function(value, metadata, record) {
					        	return '<div style="float:left; margin-top:3px; font-size: 11px; line-height: 1em;">'+ value+'</div>';
					        },
				            flex     : 1,            
				            align: 'right',
		//		            menuDisabled: true,
				            hideable: false,
				            sortable: true
				    },
				
//				   {    text: HreRem.i18n('title.activo.administracion.numGasto'),
//			        	dataIndex: 'numGasto',
//			        	flex: 1
//			       },
			       {    text: HreRem.i18n('title.activo.administracion.tipo'),
			        	dataIndex: 'tipoGastoDescripcion',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.subtipo'),
			        	dataIndex: 'subtipoGastoDescripcion',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.concepto'),
			        	dataIndex: 'conceptoGasto',
			        	flex: 1
			       },
//			       {    text: HreRem.i18n('title.activo.administracion.emisor'),
//			        	dataIndex: 'emisor',
//			        	flex: 1
//			       },
			       {    text: HreRem.i18n('title.activo.administracion.fecha.emision'),
			        	formatter: 'date("d/m/Y")',
			        	dataIndex: 'fechaEmisionGasto',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.periodicidad'),
			        	dataIndex: 'periodicidadGastoDescripcion',
			        	flex: 1
			       },
			        {    text: HreRem.i18n('title.activo.administracion.porcentajeParticipacion'),
			        	dataIndex: 'participacion',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.importe'),
			        	dataIndex: 'importeTotalGasto',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.estado'),
			        	dataIndex: 'estadoGastoDescripcion',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.fecha.pago'),
			        	formatter: 'date("d/m/Y")',
			        	dataIndex: 'fechaPagoGasto',
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.afecta.otros.activos'),
//			        	dataIndex: 'afectaOtrosActivos',
			        	renderer: function(val, meta, record){
						    if(!Ext.isEmpty(record.data.participacion) && record.data.participacion!="100.0"){
						    	return "SI";
						    }
						    return "NO";
						},
			        	flex: 1
			       },
			       {    text: HreRem.i18n('title.activo.administracion.observaciones'),
			        	dataIndex: 'observacionesGastos',
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