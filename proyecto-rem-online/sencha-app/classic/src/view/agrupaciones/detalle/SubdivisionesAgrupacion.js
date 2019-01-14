Ext.define('HreRem.view.agrupaciones.detalle.SubdivisionesAgrupacion', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'subdivisionesagrupacion',
    cls	: 'panel-base shadow-panel',
    //layout: 'fit',
    collapsed: false,
    scrollable	: 'y',
    listeners: {
			//beforerender:'cargarTabData'
	},
	requires: ['HreRem.model.Subdivisiones','HreRem.view.trabajos.detalle.ListaActivosSubdivisionGrid'],
    
    initComponent: function () {
    	
    	var me = this;
    	me.setTitle(HreRem.i18n('title.datos.basicos'));
    	
    	me.items= [

       	 	{
				xtype: 'gridBase',
				title:HreRem.i18n('title.subdivisiones'),
			    minHeight: 100,
				cls	: 'panel-base shadow-panel',
				reference: 'listadoSubdivisionesAgrupacion',
				
				bind: {
					store: '{storeSubdivisiones}'
				},
				listeners : [
				    {rowclick: 'onSubdivisionesAgrupacionListClick'}
				],
				
				columns: [
				
				    {   
						text: HreRem.i18n('header.nombre'),
			        	dataIndex: 'descripcion',
						flex: 1
			        },
			        {   
						text: HreRem.i18n('header.num.plantas'),
			        	dataIndex: 'plantas',
						flex: 0.2
			        },
			        {   
						text: HreRem.i18n('header.num.dormitorios'),
			        	dataIndex: 'dormitorios',
						flex: 0.2
			        },
			        {
						text: HreRem.i18n('header.numero.activos.incluidos'),
			        	dataIndex: 'numActivos',
			        	flex: 0.2
			        }
			       	        
			    ]
			},
			{
			    xtype: 'listaActivosSubdivisionGrid'
			}
		];
    	
    	
    	
    	me.callParent();
    	
    },   
      
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;

		var listadoSubdivisionesAgrupacion = me.down("[reference=listadoSubdivisionesAgrupacion]");
		var listaActivosSubdivisionGrid = me.down("[reference=listaActivosSubdivisionGrid]");
		var selectedRecords = listadoSubdivisionesAgrupacion.getSelection();		
		
		listadoSubdivisionesAgrupacion.getStore().removeAll();
		listaActivosSubdivisionGrid.getStore().removeAll();
		listadoSubdivisionesAgrupacion.getStore().load();		
		
		if(!Ext.isEmpty(selectedRecords)) {
			listadoSubdivisionesAgrupacion.getSelectionModel().select(selectedRecords[0]);
			me.lookupController().onSubdivisionesAgrupacionListClick(listadoSubdivisionesAgrupacion,selectedRecords[0]);
		}
    }
    
    
    
    
    
});