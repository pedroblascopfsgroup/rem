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
	requires: ['HreRem.model.Subdivisiones'],
    
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
			    xtype: 'gridBase',
			    
			    loadAfterBind: false,
			    reference: 'listaActivosSubdivision',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeActivosSubdivision}',
					title: HreRem.i18n('title.activos.del.tipo') + ' ' + '{subdivision.descripcion}',
					hidden: '{!listadoSubdivisionesAgrupacion.selection}'
				},

				columns: [
				
				    {   
						text: HreRem.i18n('header.numero.activo.haya'),
			        	dataIndex: 'numActivo',
			        	flex: 1
			        },
			        {
						text: HreRem.i18n('header.finca.registral'),
			        	dataIndex: 'numFinca',
			        	flex: 0.5
			        },
			        {
						text: HreRem.i18n('header.tipo'),
			        	dataIndex: 'tipoActivo',
			        	flex: 0.5
			        },
			        {
						text: HreRem.i18n('header.subtipo'),
			        	dataIndex: 'subtipoActivo',
			        	flex: 0.5
			        },
			        {
						text: HreRem.i18n('header.dispone.informe.comercial'),
			        	dataIndex: 'fechaAceptacionInformeComercial',
			        	flex: 0.3,
			        	align: 'center',
			        	renderer: function(value) {
			        		return Ext.isEmpty(value) ? "" : '<span class="fa fa-check green-color"><span/>'
			        	}
			        }
			        
			       	        
			    ],
			    dockedItems : [
			        {
			            xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            displayInfo: true,
			            bind: {
			                store: '{storeActivosSubdivision}'
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

		var listadoSubdivisionesAgrupacion = me.down("[reference=listadoSubdivisionesAgrupacion]");
		var listaActivosSubdivision = me.down("[reference=listaActivosSubdivision]");
		var selectedRecords = listadoSubdivisionesAgrupacion.getSelection();		
		
		listadoSubdivisionesAgrupacion.getStore().removeAll();
		listaActivosSubdivision.getStore().removeAll();
		listadoSubdivisionesAgrupacion.getStore().load();		
		
		if(!Ext.isEmpty(selectedRecords)) {
			listadoSubdivisionesAgrupacion.getSelectionModel().select(selectedRecords[0]);
			me.lookupController().onSubdivisionesAgrupacionListDobleClick(listadoSubdivisionesAgrupacion,selectedRecords[0]);
		}
    }
    
    
    
    
    
});