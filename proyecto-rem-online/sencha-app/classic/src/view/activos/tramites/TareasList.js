Ext.define('HreRem.view.activos.tramites.TareasList', {
	extend		: 'Ext.panel.Panel',
    xtype		: 'tareaslist',
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    reference	: 'tareaslistref',
    layout		: 'fit',
    requires	: ['HreRem.view.activos.tramites.SolicitarProrroga', 'HreRem.view.activos.tramites.solicitarProrrogaModel'],

    initComponent: function () {
   		var me = this;

   		me.buttons = [
   			{ 
   				name: 'btnAutoprorroga',
            	itemId: 'btnAutoprorroga', 
            	text: 'Autoprórroga', 
            	handler: 'solicitarAutoprorroga',
            	bind: {
            		disabled: '{!listadoTareasTramite.selection}'
            	}
              },
              {
	           	 name: 'btnSaltoCE',
	           	 itemId: 'btnSvanzarCE',
	           	 text: 'Avanzar a Cierre Económico',
	          	 handler: 'saltoCierreEconomico',
	          	 bind: {
	          		 hidden: '{tramite.ocultarBotonCierre}'
	          	 }
             },
             {
	           	 name: 'btnSaltoRE',
	           	 itemId: 'btnSaltoRE',
	           	 text: 'Avanzar a Resolución Expediente',
	          	 handler: 'saltoResolucionExpediente',
	          	 bind: {
	          		 hidden: '{tramite.ocultarBotonResolucion}'
	          	 }
             }
   		];

   		me.buttonAlign = 'left';
   		me.setTitle(HreRem.i18n("title.tareas.activas"));

   		me.items= [
			{
			    xtype: 'gridBase',
			    reference: 'listadoTareasTramite',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{tareasTramite}'
				},
				listeners: {
					rowdblclick: 'onTareasListDobleClick'
				},
				minHeight: 200,
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
				            flex: 1,
				            formatter: 'date("d/m/Y")'
				        },
				        {
				            dataIndex: 'fechaVenc',
				            text: 'F. Vencimiento',
				            align: 'center',
				            flex: 1,
				            formatter: 'date("d/m/Y")'
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
				        },
				        {
				        	dataIndex: 'codigoTarea',
				        	text: 'Código Tarea',
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
			                store: '{tareasTramite}'
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
		var listadoTareasTramite= me.down("[reference=listadoTareasTramite]");

		// FIXME ¿¿Deberiamos cargar la primera página??
		listadoTareasTramite.getStore().load();
    }
});