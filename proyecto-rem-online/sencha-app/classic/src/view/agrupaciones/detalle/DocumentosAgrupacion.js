Ext.define('HreRem.view.agrupaciones.detalle.DocumentosAgrupacion', {
    extend: 'Ext.form.Panel',
    xtype: 'documentosagrupacion',
	layout: 'fit',
	requires: ['HreRem.view.common.FieldSetTable', 'HreRem.model.DocumentosAgrupacion'],

    initComponent: function () {

        var me = this;
        
        me.setTitle('Documentos');
        		         
        var items= [

			{
			    xtype		: 'gridBaseEditableRow',
			    topBar		: $AU.userHasFunction(['EDITAR_TAB_DOCUMENTOS_AGRUPACION']),
			    idPrincipal : 'agrupacionficha.id',
			   	secFunToEdit: 'EDITAR_AGRUPACION',				
				secButtons: {
					secFunPermToEnable : 'EDITAR_AGRUPACION'
				},
				cls	: 'grid-editable-row',
				bind: {
					topBar: '{agrupacionficha.esEditable}',
					editOnSelect: '{agrupacionficha.esEditable}'
				},
				columns: [
				   {    text: 'Nombre del documento',
			        	dataIndex: 'nombreDocumento',
			        	flex: 2
			       },
			       {    text: 'Tipo',
			        	dataIndex: 'tipoDocumento',
			        	flex: 2
			       },
			       {   
			       		text: 'Descripción',
			       	    dataIndex: 'descripcion',
			       		flex: 2,
			       		editor: {
			       			xtype:'textarea'
			       		}
			       },
			       {    text: 'Tamaño',
			        	dataIndex: 'tamanoDocumento',
			        	flex: 2
			       },
				   {
			            text: 'Fecha subida',
			            dataIndex: 'fechaSubida',
			            flex: 2,
			        	formatter: 'date("d/m/Y")'
			            
			       },
			       {    text: 'Gestor',
			        	dataIndex: 'nombreCompleto',
			        	flex: 2
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
			            displayInfo: true
			        }
			    ]
			    
			}
            
            
        ];
		me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    	
    }

});