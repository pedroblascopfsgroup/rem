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
									    idPrincipal : 'activo.id',
									    colspan: 3,
									    topBar: true,
									    removeButton: false,
									    reference: 'listadoEntidadesref',
										cls	: 'panel-base shadow-panel',
										bind: {
											store: '{storeEntidades}'
										},
										listeners : {
										    rowdblclick: 'onEntidadesListDobleClick'
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
											            hideable: false,
											            sortable: true
											       },
											       {    text: HreRem.i18n('header.subtipo'),
											        	dataIndex: 'subtipoProveedorDescripcion',
											        	flex: 1
											       },
											       {    text: HreRem.i18n('header.nif'),
											        	dataIndex: 'nifProveedor',
											        	flex: 1
											       },
											       {    text: HreRem.i18n('header.nombre'),
											        	dataIndex: 'nombreProveedor',
											        	flex: 1
											       },
											       {    text: HreRem.i18n('header.estado'),
											        	dataIndex: 'estadoProveedorDescripcion',
											        	flex: 1
											       },
											       {    text: HreRem.i18n('header.participacion'),
											        	dataIndex: 'participacion',
											        	flex: 1
											       },
											       {    text: HreRem.i18n('header.fecha.inclusion'),
											        	dataIndex: 'fechaInclusion',
											        	formatter: 'date("d/m/Y")',
											        	flex: 1
											       },
											       {    text: HreRem.i18n('header.fecha.exclusion'),
											        	dataIndex: 'fechaExclusion',
											        	formatter: 'date("d/m/Y")',
											        	flex: 1
											       },
											       {    text: HreRem.i18n('header.pagos.retenidos'),
											        	dataIndex: 'pagosRetenidos',
											        	flex: 1,
											        	renderer: function(value) {
											        		return value == 1? 'Si' : 'No';
											        	}
											       },
											       {    text: HreRem.i18n('header.observaciones'),
											        	dataIndex: 'observaciones',
											        	flex: 1
											       },
											       {
											       		dataIndex: 'idProveedor',
											       		hidden: true
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