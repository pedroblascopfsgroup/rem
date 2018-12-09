Ext.define('HreRem.view.expedientes.DiarioGestionesExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'diariogestionesexpediente', 
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'diariogestionesexpedienteref',
	layout: 'fit',

    initComponent: function () {

        var me = this;        
        me.setTitle(HreRem.i18n('title.diario.gestiones'));		         
        var items= [

			{
			    xtype		: 'gridBaseEditableRow',
			    idPrincipal : 'expediente.id',
			    topBar: $AU.userHasFunction(['EDITAR_TAB_DIARIO_GESTIONES_EXPEDIENTES']),
			    reference: 'listadoObservaciones',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeObservaciones}'
					//REMVIP-405 - Se pide que aunque el expediente este bloqueado se puedan añadir observaciones
					//, topBar: '{!esExpedienteBloqueado}'
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
			       },
			       {
			    	   flex: 2,
			    	   align: 'center',
			           renderer: function (v, m, r) {
			        	   var id = Ext.id();
			        	   Ext.defer(function () {
			        	       Ext.widget('button', {
			        	          renderTo: id, 
			        	          text: HreRem.i18n('title.diario.gestiones.enviar.comercializadora'),
					              tooltip: HreRem.i18n('title.diario.gestiones.enviar.comercializadora'), 
			        	          width: 200,
			        	          handler: function () {me.fireEvent('enviarComercializadora', r); }
			        	       });
			        	   }, 50);
			        	   return Ext.String.format('<div id="{0}"></div>', id);
			           },
			           bind: {
			            	hidden: '{esOfertaVenta}'
			           },
			           editRenderer: function(){
			        	   return '&#160;';
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