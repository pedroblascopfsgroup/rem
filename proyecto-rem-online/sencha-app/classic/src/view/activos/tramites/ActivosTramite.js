Ext.define('HreRem.view.tramites.ActivosTramite', {
    extend: 'Ext.panel.Panel',
    xtype: 'activostramite',    
    cls	: 'panel-base shadow-panel',
	layout: 'fit',
    initComponent: function () {
    	
    	var me = this;
    	me.setTitle(HreRem.i18n('title.activos'));
    	
    	var items= [
    	   	
			{
			    xtype		: 'gridBaseEditableRow',
			    idPrincipal	: 'tramite.id',
			    reference: 'listadoActivosTramite',
				cls	: 'panel-base shadow-panel',
				bind: {
					title: '{tituloActivosTrabajo}',
					store: '{activosTramite}'
				},
				
				features: [{
				            id: 'summary',
				            ftype: 'summary',
				            hideGroupedHeader: true,
				            enableGroupingMenu: false,
				            dock: 'bottom'
				}],
				columns: [

					{
				        xtype: 'actioncolumn',
				        width: 30,
				        handler: 'onEnlaceActivosClick',
				        items: [{
				            tooltip: 'Ver Activo',
				            iconCls: 'app-list-ico ico-ver-activo'
				        }],
				        hideable: false
			    	},  
				    {   text: HreRem.i18n('header.numero.activo'),
			        	dataIndex: 'numActivo',
			        	flex: 1
			        },			        
				    {   text: HreRem.i18n('fieldlabel.id.activo.rem'),
			        	dataIndex: 'numActivoRem',
			        	flex: 1,
			        	hidden: true
			        },
				    {   text: HreRem.i18n('fieldlabel.id.activo.sareb'),
			        	dataIndex: 'idSareb',
			        	flex: 1,
			        	hidden: true
			        },
				    {   text: HreRem.i18n('fieldlabel.id.activo.uvem'),
			        	dataIndex: 'numActivoUvem',
			        	flex: 1,
			        	hidden: true
			        },
				    {   text: HreRem.i18n('fieldlabel.id.activo.recovery'),
			        	dataIndex: 'idRecovery',
			        	flex: 1,
			        	hidden: true
			        },			        
					{
					    dataIndex: 'entidadPropietariaDescripcion',
					    text: HreRem.i18n('header.propietario'),
					    flex: 1
					},		        
					{				
					    dataIndex: 'tipoActivoDescripcion',
					    text: HreRem.i18n('header.tipo'),
					    flex: 1
					},
					{
					    dataIndex: 'subtipoActivoDescripcion',
					    text: HreRem.i18n('header.subtipo'),
					    flex: 1
					},
					{
					    dataIndex: 'estadoActivoDescripcion',
					    text: HreRem.i18n('header.estado'),
					    flex: 1
					},
			        {   
			        	dataIndex: 'direccion',
			        	text: HreRem.i18n('header.direccion'),
			        	flex:1,
			        	hidden: true
					},
			        {   
			        	dataIndex: 'municipioDescripcion',
			        	text: HreRem.i18n('header.municipio'),
			        	flex:1,
			        	hidden: true
			        },
			        {   
			        	dataIndex: 'provinciaDescripcion',
			        	text: HreRem.i18n('header.provincia'),
			        	flex:1,
			        	hidden: true
					},
					{   
						dataIndex: 'tipoTituloDescripcion',
						text: HreRem.i18n('fieldlabel.tipo.titulo'),
						flex:1
					},
					{   
						dataIndex: 'subtipoTituloDescripcion',
						text: HreRem.i18n('fieldlabel.subtipo.titulo'),
						flex:1,
			        	hidden: true
					},
					{   
						dataIndex: 'ratingDescripcion',
						text: HreRem.i18n('header.rating'),
						flex:1,
			        	hidden: true
					}					

			    ],
			    
			    dockedItems : [
			        {
			            xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            displayInfo: true,
			            bind: {
			                store: '{activosTramite}'
			            }
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
		var listadoActivosTramite = me.down("[reference=listadoActivosTramite]");
		
		// FIXME ¿¿Deberiamos cargar la primera página??
		listadoActivosTramite.getStore().load();
    }
    
    
    
});
