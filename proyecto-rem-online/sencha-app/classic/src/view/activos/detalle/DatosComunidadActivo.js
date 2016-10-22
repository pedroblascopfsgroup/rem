Ext.define('HreRem.view.activos.detalle.DatosComunidadActivo', {
      extend : 'HreRem.view.common.FormBase',
      xtype : 'datoscomunidadactivo',
      reference : 'datoscomunidadactivo',
      scrollable : 'y',
      
      initComponent : function() {

        var me = this;
        me.setTitle(HreRem.i18n('title.comunidades.entidades'));
        
        var items= [

        
			         {
						xtype:'fieldsettable',
						title: HreRem.i18n('title.listado.entidades.integra.activo'),
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
											store: '{storeEntidades}'
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
													{	  
											        	xtype: 'actioncolumn',
											            dataIndex: 'codigoProveedor',
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
									    ],

									    dockedItems : [
									        {
									            xtype: 'pagingtoolbar',
									            dock: 'bottom',
									            displayInfo: true,
									            bind: {
									                store: '{storeEntidades}'
									            }
									        }
									    ]
									}
						]
				}
			]
			
			me.addPlugin({ptype: 'lazyitems', items: items });
	        me.callParent();

      },
      
      funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		if(!me.disabled) {
			Ext.Array.each(me.query('grid'), function(grid) {
	  			grid.getStore().load();
	  		});
		}
  	  }
  });