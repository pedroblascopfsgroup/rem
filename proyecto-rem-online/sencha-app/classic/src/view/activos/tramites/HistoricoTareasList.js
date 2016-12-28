Ext.define('HreRem.view.activos.tramites.HistoricoTareasList', {
	extend		: 'Ext.panel.Panel',
    xtype		: 'historicotareaslist', 
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    reference	: 'historicotareaslistref',
    layout		: 'fit',
    requires	: ['HreRem.view.agenda.TareaProrroga'],

    initComponent: function() {
    	var me = this;

    	me.setTitle(HreRem.i18n("title.historico.tareas"));

    	me.items= [
    		{
    			xtype		: 'label',
    			reference	: 'historicoTareasAclaracion',
    			html		: HreRem.i18n("aclaracion.historico.tareas")
    		},
			{
			    xtype		: 'gridBase',
			    reference: 'historicoTareasTramite',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{historicoTareas}'
				},
				
				listeners: {
					rowdblclick: 'onTareasListDobleClickHistorico'
				},
				
				columns: [
				        {
				            dataIndex: 'id',
				            text: 'Id Tarea',
				            hidden: true,
				            flex: 1
				        },
				        {
				            dataIndex: 'idTareaExterna',
				            text: 'Id Tarea Externa',
				            hidden: true,
				            flex: 1
				        },
				        {
				            dataIndex: 'tipoTarea',
				            text: 'Tarea',
				            flex: 3
				        },
				        {
				            dataIndex: 'idActivo',
				            hidden: true,
				            text: 'Id Activo',
				            flex: 1
				        },       
				        {
				            dataIndex: 'fechaInicio',
				            text: 'F. Inicio',
				            align: 'center',
				            formatter: 'date("d/m/Y")',
				            flex: 1
				        },
				        {
				            dataIndex: 'fechaFin',
				            text: 'F. Ejecución',
				            align: 'center',
				            formatter: 'date("d/m/Y")',
				            flex: 1
				        },
				        {
				            dataIndex: 'idGestor',
				            text: 'Id Gestor',
				            hidden: true,
				            flex: 1
				        },
				        {
				            dataIndex: 'gestor',
				            text: 'Destinatario',
				            flex: 2
				        },
				        {
				        	dataIndex: 'subtipoTareaCodigoSubtarea',
				        	text: 'Subtipo Tarea',
				        	hidden: true,
				        	flex: 1
				        }
	    		],

	    		dockedItems: [
				      {
				          xtype: 'pagingtoolbar',
				          dock: 'bottom',
				          displayInfo: true,
				          bind: {
				              store: '{historicoTareas}'
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
		var historicoTareasTramite= me.down("[reference=historicoTareasTramite]");

		// FIXME ¿¿Deberiamos cargar la primera página??
		historicoTareasTramite.getStore().load();
    }
});