	Ext.define('HreRem.view.activos.detalle.EvolucionActivoDetalle', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'evolucionactivo',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    refreshAfterSave: true,
    disableValidation: true,
    reference: 'evolucionactivoref',
    scrollable	: 'y',
    listeners: {
			boxready:'cargarTabData'		
	},

	recordName: "evolucion",
	
	recordClass: "HreRem.model.ActivoEvolucion",
	
	requires : ['HreRem.model.Activo'],
	
    initComponent: function () {
        var me = this;
        
        me.setTitle(HreRem.i18n('title.admision.evolucion'));

        var items= [

        	{
        		xtype: 'button',
        		text: HreRem.i18n('btn.exportar'),
        		handler: 'onClickDescargarExcelEvolucion'
        	},
        	{
                xtype : 'gridBase',
                reference : 'gridEvolucionActivo',
                topBar : false,
                cls : 'panel-base shadow-panel',
                bind : {
                  store : '{storeGridEvolucion}'
                },
                selModel : {
                  type : 'checkboxmodel'
                }, 
                listeners: {
				  rowdblclick: {fn: 'mostrarObservacionesGrid', extraArg: '{evolucion.observacionesEvolucion}'}
				},				        
                columns : [{
                      text : HreRem.i18n('header.evolucion.grid.estado'),
                      dataIndex : 'estadoEvolucion',
                      flex : 1
                      
                    },{
                      text : HreRem.i18n('header.evolucion.grid.subestado'),
                      dataIndex : 'subestadoEvolucion',
                      flex : 1
                    }, {
                      text : HreRem.i18n('header.evolucion.grid.fecha'),
                      flex : 1,
                      dataIndex : 'fechaEvolucion',
                      formatter: 'date("d/m/Y")',
                      editor: {
                    	  xtype: 'datefield',
                    	  cls: 'grid-no-seleccionable-field-editor'
                      }
                    }, {
                      text : HreRem.i18n('header.evolucion.grid.observaciones'),
                      flex : 1,
                      dataIndex : 'observacionesEvolucion',
                      reference: 'observacionesevolucionref'                
                    },{
                        text : HreRem.i18n('header.evolucion.grid.gestor'),
                        flex : 1,
                        dataIndex : 'gestorEvolucion'
                    }

                ],
                
                dockedItems : [{
                      xtype : 'pagingtoolbar',
                      dock : 'bottom',
                      displayInfo : true,
                      bind : {
                        store : '{storeGridEvolucion}'
                      }
                    }]
              }	
     ];
		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
    }, 

    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
			grid.getStore().load();
  		});
   }


});