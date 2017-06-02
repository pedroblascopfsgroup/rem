Ext.define('HreRem.view.expedientes.ActivoExpedienteJuridico', {
	extend : 'HreRem.view.common.FormBase',
	xtype : 'activoexpedientejuridico',
	cls : 'panel-base shadow-panel',
	collapsed : false,
	reference : 'activoexpedientejuridico',
	scrollable : 'y',

	requires : [],

	listeners : {},

	initComponent : function() {

		var me = this;
		me.setTitle(HreRem.i18n('title.informe.juridico'));
		var items = [
			{
				xtype : 'fieldsettable',
				defaultType : 'textfieldbase',
			
			//	title : HreRem.i18n('title.situacion.activo.comunicada.comprador'),
				items : [
							{
						    	xtype: 'datefieldbase',
						    	fieldLabel: HreRem.i18n('label.fecha.emision'),
								bind:		'{gastoNuevo.fechaEmision}',
								allowBlank: false
							},
							{ 
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.proveedor.resultado'),
					        	bind: {
				            		store: '{comboSiNoRem}',
				            		value: '{condiciones.renunciaSaneamientoEviccion}'			            		
				            	},
				            	displayField: 'descripcion',
								valueField: 'codigo'
							}
						]
			},
			{
			    xtype: 'gridBaseEditableRow',
			    topBar: $AU.userHasFunction(['EDITAR_TAB_GESTION_ECONOMICA_EXPEDIENTES']),
			    reference: 'listadoBloqueosActivos',
			    idPrincipal : 'expediente.id',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeBloqueosActivo}'
				},									
				listeners: {
					beforeedit: function(editor){
						
					}
				},
				columns: [
				   {
				   		text: HreRem.i18n('header.area.bloqueo'),
			            dataIndex: 'codigoProveedorRem',
			            flex: 1,
			            editor: {
							xtype: 'textfield',
							allowBlank: false,
							reference: 'proveedorRef',
							maskRe: /[0-9.]/
						}
				   },
				   {
				   		text: HreRem.i18n('fieldlabel.tipo'),
			            dataIndex: 'proveedor',
			            flex: 1
						
				   },
				   {
				   		xtype: 'numbercolumn',
				   		text: HreRem.i18n('header.fecha.alta'),
			            dataIndex: 'importeCalculo',
			            flex: 1,
			            editor: {
			            	xtype:'numberfieldbase',
			            	addUxReadOnlyEditFieldPlugin: false,
			            	allowBlank: false,
			            	reference: 'importeCalculoHonorario',
			            	listeners:{
			            		change: 'onHaCambiadoImporteCalculo'
			           		}					           							            
			            }
				   },
				   {
				   		text: HreRem.i18n('title.publicaciones.condiciones.usuarioalta'),
			            dataIndex: 'observaciones',
			            flex: 1,
			            editor: {
			            	xtype:'textarea',
			            	reference: 'observaciones'
			            }
				   },
				   {
				   		text: HreRem.i18n('header.fecha.baja'),
			            dataIndex: 'observaciones',
			            flex: 1,
			            editor: {
			            	xtype:'textarea',
			            	reference: 'observaciones'
			            }
				   },
				   {
				   		text: HreRem.i18n('title.publicaciones.condiciones.usuariobaja'),
			            dataIndex: 'observaciones',
			            flex: 1,
			            editor: {
			            	xtype:'textarea',
			            	reference: 'observaciones'
			            }
				   }
			    ]
			}
		    

		];

		me.addPlugin({
			ptype : 'lazyitems',
			items : items
		});

		me.callParent();
	},

	funcionRecargar : function() {

	}
});