Ext.define('HreRem.view.agrupaciones.detalle.ActivosAgrupacion', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'activosagrupacion',
    reference: 'activosagrupacion',
    layout: 'fit',
    scrollable	: 'y',
    
    requires: ['HreRem.view.common.GridBaseEditableRowSinEdicion', 'HreRem.model.ActivoAgrupacion', 'HreRem.view.agrupaciones.detalle.AgrupacionDetalleModel'],

    initComponent: function () {
     	
     	var me = this;    	
     	
     	me.setTitle(HreRem.i18n('title.activos'));
     	
	    
	    var items = [
	    	{
				title: 'Listado de Activos',
			    xtype: 'gridBaseEditableRow',
			    idPrincipal: 'agrupacionficha.id',
			    //selModel: { selType: 'rowmodel', mode   : 'MULTI'},
			    editOnSelect: false,
			    reference: 'listadoactivosagrupacion',
				cls	: 'panel-base shadow-panel',
				topBar: true,
				bind: {
					store: '{storeActivos}',
					topBar: '{!agrupacionficha.existeFechaBaja}'
				},
				colspan: 2,
				listeners: {
					// Listener para el doble click en la lista de activos
					rowdblclick: 'onActivosAgrupacionListDobleClick'
			    },
			    
				secFunToEdit: 'EDITAR_AGRUPACION',
				
				secButtons: {
					secFunPermToEnable : 'EDITAR_AGRUPACION'
				},
	    
				
				columns: [
				    {
				        xtype: 'actioncolumn',
				        reference: 'activoPrincipal',
				        bind: {
				        	hidden: '{esAgrupacionObraNueva}'
				        },
				        width: 30,
				        text: HreRem.i18n('header.principal'),
						hideable: false,
						items: [
						        	{
							            getClass: function(v, meta, rec) {
							                if (rec.get('activoPrincipal') != 1) {
							                	this.items[0].handler = 'onMarcarPrincipalClick';
							                    return 'fa fa-check';
							                } else {
					            				this.items[0].handler = 'onMarcarPrincipalClick';
							                    return 'fa fa-check green-color';
							                }
							            }
						        	}
						 ]
		    		},  		
				    {
			            dataIndex: 'numActivo',
			            text: HreRem.i18n('header.numero.activo.haya'),
			            flex: 0.5,
						editor: {xtype:'textfield'}

			        },
			        {   
		            	text	 : HreRem.i18n('header.fecha.alta'),
		                dataIndex: 'fechaInclusion',
				        formatter: 'date("d/m/Y")',
				        width: 130 
				    },
			        {
			            dataIndex: 'tipoActivoDescripcion',
			            text: HreRem.i18n('header.tipo'),
			            flex: 1
			        },
			        {
			            dataIndex: 'subtipoActivo',
			            text: HreRem.i18n('header.subtipo'),
			            flex: 0.5,
			            renderer: function (value) {
			            	return Ext.isEmpty(value) ? "" : value.descripcion;
			            }
			        },
			        {
			            dataIndex: 'subdivision',
			            text: HreRem.i18n('header.subdivision'),
			            hideable: false,
			            bind: {
				        	hidden: '{!esAgrupacionObraNueva}'
				        },
			            flex: 0.5
			        },
			        {
			            dataIndex: 'direccion',
			            text: HreRem.i18n('header.direccion'),
			            hideable: false,
			            bind: {
				        	hidden: '{esAgrupacionObraNueva}'
				        },
			            flex: 1
			        },
			        {
			            dataIndex: 'numFinca',
			            text: HreRem.i18n('header.finca.registral'),
			            hideable: false,
			            bind: {
				        	hidden: '{!esAgrupacionObraNueva}'
				        },
			            flex: 0.5
			        },
			        {
			            dataIndex: 'puerta',
			            text: HreRem.i18n('header.puerta'),
			            hideable: false,
			            bind: {
				        	hidden: '{!esAgrupacionObraNueva}'
				        },
			            flex: 0.5
			        },
			        {
			            dataIndex: 'publicado',
			            text: HreRem.i18n('header.publicado'),
			            flex: 0.5,
			            renderer: Utils.rendererBooleanToSiNo
			        },
			        {
			            dataIndex: 'situacionComercial',
			            text: HreRem.i18n('header.disponibilidad.comercial'),
			            flex: 1
			        },
			        {
			            dataIndex: 'importeMinimoAutorizado',
			            text: HreRem.i18n('header.valor.web'),
			            flex: 1,
			            renderer: function(value) {
			        		return Ext.util.Format.currency(value);
			        	},
			            sortable: false		            
			        },
			        {
			            dataIndex: 'importeAprobadoVenta',
			            text: HreRem.i18n('header.valor.aprobado.venta'),
			            flex: 1,
			            renderer: function(value) {
			        		return Ext.util.Format.currency(value);
			        	},
			            sortable: false		            
			        },
			        {
			            dataIndex: 'importeDescuentoPublicado',
			            text: HreRem.i18n('header.valor.descuento.publicado'),
			            flex: 1,
			            renderer: function(value) {
			        		return Ext.util.Format.currency(value);
			        	},
			            sortable: false		            
			        },
			        {
			            dataIndex: 'superficieConstruida',
			            hideable: false,
			            bind: {
				        	hidden: '{esAgrupacionObraNueva}'
				        },
			            text: HreRem.i18n('header.superficie.construida'),
			            flex: 1,
			            renderer: Ext.util.Format.numberRenderer('0,000.00'),
			            sortable: false      
			        }
			         	        
			    ],
			    
			    saveSuccessFn: function() {
			    	if (Ext.isFunction(me.lookupController().refrescarAgrupacion)) {
			    		me.lookupController().onClickBotonRefrescar();
			    	}
			    },
			    
			    deleteSuccessFn: function() {
			    	if (Ext.isFunction(me.lookupController().refrescarAgrupacion)) {
			    		me.lookupController().onClickBotonRefrescar();
			    	}
			    },
			    
				deleteFailureFn: function() {
			    	if (Ext.isFunction(me.lookupController().refrescarAgrupacion)) {
			    		me.lookupController().onClickBotonRefrescar();
			    	}
			    },
			    
			    dockedItems : [
			        {
			            xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            displayInfo: true,
			            bind: {
			                store: '{storeActivos}'
			            }
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
	var listadoActivosAgrupacion = me.down("[reference=listadoactivosagrupacion]");
	
	// FIXME ¿¿Deberiamos cargar la primera página??
	listadoActivosAgrupacion.getStore().loadPage(1);
  }
   
   
});
