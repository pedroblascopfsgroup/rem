Ext.define('HreRem.view.activos.detalle.AgrupacionesActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'agrupacionesactivo',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'agrupacionesactivoref',
    controller: 'agrupaciones',
    layout: 'fit',
	
	requires: ['HreRem.view.common.FieldSetTable', 'HreRem.model.AgrupacionesActivo'],	
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.agrupaciones'));	         
        var items= [

			{
			    xtype		: 'gridBase',
			    reference: 'listadoAgrupaciones',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeAgrupacionesActivo}'
				},
				listeners: {
			    	rowdblclick: function(grid,record) {
						var me = this;
						me.lookupController().onAgrupacionesListDobleClick(grid,record);

					}
			    },
				columns: [
			    
		  				{
			            	text	 : HreRem.i18n('header.numero.agrupacion'),
			                flex	 : 1,
			                dataIndex: 'numAgrupRem'
			            },
			            {
			            	text	 : HreRem.i18n('header.numero.agrupacion.uvem'),
			                flex	 : 1,
			                dataIndex: 'numAgrupUvem'
			            },
			            {
				            dataIndex: 'tipoAgrupacionDescripcion',
				            text: HreRem.i18n('header.tipologia'),
							flex	: 1
				            
				        },
			            {
			         		text	 : HreRem.i18n('header.nombre'),
			                flex	 : 1,
			                dataIndex: 'nombre'

			            },
			            {
			            	text	 : HreRem.i18n('header.descripcion'),
			                flex	 : 1,
			                dataIndex: 'descripcion'
			            },
			            {   
			            	text	 : HreRem.i18n('header.fecha.creacion.agrupacion'),
			                dataIndex: 'fechaAlta',
					        formatter: 'date("d/m/Y")',
					        flex	: 1
					    },
					    {   
			            	text	 : HreRem.i18n('header.fecha.baja.agrupacion'),
			                dataIndex: 'fechaBaja',
					        formatter: 'date("d/m/Y")',
					        flex	: 1
					    },
					    {   
			            	text	 : HreRem.i18n('header.fecha.inclusion.activo'),
			                dataIndex: 'fechaInclusion',
			                flex	: 1,
					        formatter: 'date("d/m/Y")'
					    },
					    {   
			            	text	 : HreRem.i18n('header.fecha.inicio.vigencia'),
			                dataIndex: 'fechaInicioVigencia',
			                flex	: 1,
					        formatter: 'date("d/m/Y")'
					    },
					    {   
			            	text	 : HreRem.i18n('header.fecha.fin.vigencia'),
			                dataIndex: 'fechaFinVigencia',
			                flex	: 1,
					        formatter: 'date("d/m/Y")'
					    },
					    {   
			            	text	 : HreRem.i18n('header.num.activos.agrupacion'),
			                dataIndex: 'numActivos',
			                flex	: 1
					    },
					    {   
			            	text	 : HreRem.i18n('header.num.activos.publicados'),
			                dataIndex: 'numActivosPublicados',
			                flex	: 1
					    }
		
			        ],
			    dockedItems : [
			        {
			            xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            displayInfo: true,
			            bind: {
			                store: '{storeAgrupacionesActivo}'
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
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    }


    
});