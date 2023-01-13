Ext.define('HreRem.view.agrupaciones.detalle.ObservacionesAgrupacion', {
    extend: 'Ext.form.Panel',
    xtype: 'observacionesagrupacion',
	layout: 'fit',
	requires: ['HreRem.view.common.FieldSetTable', 'HreRem.model.ObservacionesAgrupacion'],

    initComponent: function () {

        var me = this;
		var agrupacionONDnd = me.lookupController().getViewModel().get('agrupacionficha.isObraNueva')
								&& me.lookupController().getViewModel().get('agrupacionficha.esONDnd');
        var habilitarTopBar = $AU.userHasFunction(['EDITAR_TAB_OBSERVACIONES_AGRUPACION']) && !agrupacionONDnd;
        me.setTitle('Observaciones');
        		         
        var items= [

			{
			    xtype		: 'gridBaseEditableRow',
			    topBar		: habilitarTopBar,
			    idPrincipal : 'agrupacionficha.id',
			   	secFunToEdit: 'EDITAR_AGRUPACION',				
				secButtons: {
					secFunPermToEnable : 'EDITAR_AGRUPACION'
				},
			    title		: 'Observaciones',
			    reference: 'listadoObservaciones',
				cls	: 'grid-editable-row',
				bind: {
					store: '{storeObservaciones}',
					topBar: '{agrupacionficha.esEditable}',
					editOnSelect: '{agrupacionficha.esEditable}'
				},
				columns: [
				   {    text: 'Gestor',
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
	   	                    return allowEdit;
   	                	}
	                }
	            },
	            
	            onGridBaseSelectionChange: function (grid, records) {
	            	if(!records.length)
            		{
            			
            			me.down('#removeButton').setDisabled(true);
            			me.down('#addButton').setDisabled(false);
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
		var listadoObservaciones = me.down("[reference=listadoObservaciones]");
		
		// FIXME ¿¿Deberiamos cargar la primera página??
		listadoObservaciones.getStore().load();
    }


    
});