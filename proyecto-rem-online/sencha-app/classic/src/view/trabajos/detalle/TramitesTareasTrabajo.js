Ext.define('HreRem.view.trabajos.detalle.TramitesTareasTrabajo', {
    extend: 'Ext.panel.Panel',
    xtype: 'tramitestareastrabajo',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'tramitestareastrabajoref',
    layout: 'fit',
    initComponent: function () {
    	
    	var me = this;
    	me.setTitle(HreRem.i18n('title.tramites.tareas'));
    	var items= [
    	
			{
			    xtype		: 'gridBase',
			    reference: 'listadoTareasTramiteTrabajo',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{tareasTramiteTrabajo}'
				},
				
				listeners: {
					rowdblclick: 'onListadoTramitesTareasTrabajoDobleClick'
				},
				
				columns: [
						  /*
				        {
				            dataIndex: 'idTramite',
				            text: HreRem.i18n("header.tramite"),
				            flex: 1
				        }, */ 
				        {
				            dataIndex: 'tipoTramite',
				            text: HreRem.i18n("header.tipo.tramite"),
				            flex: 1
				        },
				        {
				            dataIndex: 'tipoTarea',
				            text: HreRem.i18n("header.tarea"),
				            flex: 3
				        },
				        {
				            dataIndex: 'fechaInicio',
				            text: HreRem.i18n("header.fecha.inicio"),
				            align: 'center',
				            formatter: 'date("d/m/Y")',
				            flex: 1
				        },
				        {
				            dataIndex: 'fechaVenc',
				            text: HreRem.i18n("header.fecha.vencimiento"),
				            align: 'center',
				            formatter: 'date("d/m/Y")',
				            flex: 1
				        },
				        {
				            dataIndex: 'gestor',
				            text: HreRem.i18n("header.destinatario"),
				            flex: 2
				        },
				        {
				            dataIndex: 'fechaFin',
				            text: 'F. Fin',
				            align: 'center',
				            formatter: 'date("d/m/Y")',
				            flex: 1
				        }
				],
				
			    dockedItems : [
			        {
			            xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            displayInfo: true,
			            bind: {
			                store: '{tareasTramiteTrabajo}'
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
		var listadoTareasTramiteTrabajo = me.down("[reference=listadoTareasTramiteTrabajo]");
		
		// FIXME ¿¿Deberiamos cargar la primera página??
		listadoTareasTramiteTrabajo.getStore().load();
    }
    
    
});
