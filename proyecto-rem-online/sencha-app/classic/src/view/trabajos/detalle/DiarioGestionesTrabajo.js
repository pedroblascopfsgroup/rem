Ext.define('HreRem.view.trabajos.detalle.DiarioGestionesTrabajo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'diariogestionestrabajo', 
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'diariogestionestrabajoref',
	layout: 'fit',

    initComponent: function () {
        var me = this;  
        me.setTitle(HreRem.i18n('title.diario.gestiones'));	

        me.items= [
			{
			    xtype		: 'gridBaseEditableRow',
			    idPrincipal : 'trabajo.id',
			    topBar: true,
			    disabledDeleteBtn: true,
			    reference: 'listadoObservaciones',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeObservaciones}'
				},
				secButtons: {
					secFunPermToEnable : 'TRABAJO_DIARIO_ADD'
				},

				columns: [
				   {    text: HreRem.i18n("header.gestor"),
			        	dataIndex: 'nombreCompleto',
			        	flex:2
			       },
				   {
			            text: HreRem.i18n("header.fecha"),
			            dataIndex: 'fecha',
			            flex:1,
			        	formatter: 'date("d/m/Y")'
			            
			       },
			       {
			            text: HreRem.i18n("header.ultima.modificacion"),
			            dataIndex: 'fechaModificacion',
			            flex:1,
			        	formatter: 'date("d/m/Y")'
			            
			       },
			       {   
			       		text: HreRem.i18n("header.observacion"),
			       	    dataIndex: 'observacion',
			       		flex:6,
			       		editor: {xtype:'textarea'}
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