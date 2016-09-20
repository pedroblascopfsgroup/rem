Ext.define('HreRem.view.activos.detalle.ObservacionesActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'observacionesactivo',    
    reference: 'observacionesactivoref',
	layout: 'fit',
	
	listeners: { 	
    	boxready: function (tabPanel) { 
    		tabPanel.evaluarEdicion();
    	}
    },
    
    initComponent: function () {

        var me = this;
        me.setTitle(HreRem.i18n('title.observaciones'));	        
        var items= [

			{
			    xtype		: 'gridBaseEditableRow',
			    idPrincipal : 'activo.id',
			    topBar: true,
			    reference: 'listadoObservaciones',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeObservaciones}'
				},
				secButtons: {
					secFunPermToEnable : 'ACTIVO_OBSERVACIONES_ADD'
				},	
				
				
				columns: [
				   {    text: 'Usuario',
			        	dataIndex: 'nombreCompleto',
			        	flex: 2
			       },
				   {
			            text: 'Fecha',
			            dataIndex: 'fecha',
			            flex: 1,
			        	formatter: 'date("d/m/Y")'
			            
			       },
			       {   
			       		text: 'Observación',
			       	    dataIndex: 'observacion',
			       		flex: 6,
			       		editor: {
			       			xtype:'textarea'
			       		}
			       }
			       	        
			    ],
			    listeners : {
   	                beforeedit : function(editor, context, eOpts ) {
   	                    var idUsuario = context.record.get("idUsuario");
   	                	if (!Ext.isEmpty(idUsuario))
   	                	{
	   	                    var allowEdit = $AU.sameUserPermToEnable(idUsuario);
	   	                    this.editOnSelect = allowEdit;
	   	                    return allowEdit;
   	                	}
	                }
	            },
	            
	            onGridBaseSelectionChange: function (grid, records) {
	            	if(!records.length)
            		{
            			
            			me.down('#removeButton').setDisabled(true);
            			if (!me.down("gridBaseEditableRow").getPlugin("rowEditingPlugin").editing)
            			{
            				me.down('#addButton').setDisabled(false);
            			}
            		}
            		else
            		{
            			var idUsuario = records[0].get("idUsuario");
            			var allowRemove = $AU.sameUserPermToEnable(idUsuario);
            			if (!me.down("gridBaseEditableRow").getPlugin("rowEditingPlugin").editing)
            			{
            				me.down('#removeButton').setDisabled(!allowRemove);
            			}
            		}
	            },
	           
			    dockedItems : [
			        {
			            xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            displayInfo: true,
			            bind: {
			                store: '{storeObservaciones}'
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
    },
    
  //HREOS-846 Si NO esta dentro del perimetro, ocultamos del grid las opciones de agregar/elminar
    evaluarEdicion: function() {    	
		var me = this;
		
		if(me.lookupController().getViewModel().get('activo').get('dentroPerimetro')=="false") {
			me.down('[xtype=gridBaseEditableRow]').setTopBar(false);
		}
    }


    
});