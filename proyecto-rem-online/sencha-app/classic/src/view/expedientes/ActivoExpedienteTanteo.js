Ext.define('HreRem.view.expedientes.ActivoExpedienteTanteo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'activoexpedientetanteo',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'activoexpedientetanteo',
    scrollable	: 'y',    
    requires: [],
    
    listeners: {},
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.tanteo'));
        var items= [
			{
			    xtype: 'gridBaseEditableRow',
			    topBar: $AU.userHasFunction(['EDITAR_TAB_GESTION_ECONOMICA_EXPEDIENTES']),
			    reference: 'listadotanteos',
			    idPrincipal : 'activoExpedienteSeleccionado.idActivo',
			    idSecundaria : 'expediente.id',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeTanteosActivo}'
				},									
				listeners: {
					beforeedit: function(editor){
						
					}
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
			            text: HreRem.i18n('title.configuracion.administracion'),
			            dataIndex: 'codigoTipoAdministracion',
			            flex: 1,
			            editor: {
							xtype: 'combobox',	
							reference: 'comboTipoAdministracionRef',
							allowBlank: false,
							store: new Ext.data.Store({
								model: 'HreRem.model.ComboBase',
								proxy: {
									type: 'uxproxy',
									remoteUrl: 'generic/getDiccionario',
									extraParams: {diccionario: 'administracion'}
								},
								autoLoad: true
							}),
							displayField: 'descripcion',
							valueField: 'codigo'
			            },
			            renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {	
			        		var me = this,
			        		comboEditor =  me.columns  && me.columns[colIndex].getEditor ? me.columns[colIndex].getEditor() : me.getEditor ? me.getEditor() : null;

			        		if(!Ext.isEmpty(comboEditor)) {
				        		var store = comboEditor.getStore();
				        		if (!Ext.isEmpty(record)) {
				        			comboEditor.setValue(record.get("codigoTipoAdministracion"));
				        			return record.get("descTipoAdministracion");
				        		}
			        		}
						}
				   },
				   {
				   		text: HreRem.i18n('fieldlabel.fecha.comunicacion'),
			            dataIndex: 'fechaComunicacion',
			            align: 'center',
			            formatter: 'date("d/m/Y")',
			            flex: 1,
			            editor: {
			            	xtype: 'datefield',
							allowBlank: true,
							reference: 'fechaComunicacion',
							maskRe: /[0-9.]/
						}
				   },
				   {
				   		text: HreRem.i18n('fieldlabel.fecha.contestacion'),
			            dataIndex: 'fechaRespuesta',
			            align: 'center',
			            formatter: 'date("d/m/Y")',
			            flex: 1,
			            editor: {
							xtype: 'datefield',
							allowBlank: true,
							reference: 'fechaRespuesta',
							maskRe: /[0-9.]/
						}
				   },
				   {
				   		text: HreRem.i18n('header.oferta.expediente'),
			            dataIndex: 'numeroExpediente',
			            flex: 1,
			            editor: {
							xtype: 'textfield',
							allowBlank: true,
							reference: 'numeroExpediente'
						}
				   },
				   {
				   		text: HreRem.i18n('header.solicita.visita'),
				   		dataIndex: 'solicitaVisita',
			            flex: 1,
			            editor: {
				            xtype: 'combobox',
				            displayField: 'descripcion',
				            valueField: 'descripcion',
				            bind: {
				            	store: '{comboSiNoRem}'
				            },
				            reference: 'solicitaVisita'
				        }
				   },
				   {
				   		text: HreRem.i18n('header.fecha.fin.tanteo'),
			            dataIndex: 'fechaFinTanteo',
			            align: 'center',
			            formatter: 'date("d/m/Y")',
			            flex: 1,
			            editor: {
			            	xtype: 'datefield',
							allowBlank: true,
							reference: 'fechaFinTanteo',
							maskRe: /[0-9.]/
						}
				   },
				   {
				   		text: HreRem.i18n('title.resolucion'),
				   		dataIndex: 'codigoTipoResolucion',
			            flex: 1,
			            editor: {
							xtype: 'combobox',	
							reference: 'comboTipoResolucionRef',
							allowBlank: true,
							store: new Ext.data.Store({
								model: 'HreRem.model.ComboBase',
								proxy: {
									type: 'uxproxy',
									remoteUrl: 'generic/getDiccionario',
									extraParams: {diccionario: 'resultadoTanteo'}
								},
								autoLoad: true
							}),
							displayField: 'descripcion',
							valueField: 'codigo'
			            },
			            renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {	
			        		var me = this,
			        		comboEditor =  me.columns  && me.columns[colIndex].getEditor ? me.columns[colIndex].getEditor() : me.getEditor ? me.getEditor() : null;

			        		if(!Ext.isEmpty(comboEditor)) {
				        		var store = comboEditor.getStore();
				        		if (!Ext.isEmpty(record)) {
				        			comboEditor.setValue(record.get("codigoTipoResolucion"));
				        			return record.get("descTipoResolucion");
				        		}
			        		}
						}
				   },
				   {
				   		text: HreRem.i18n('header.fecha.vencimiento'),
			            dataIndex: 'fechaVencimiento',
			            formatter: 'date("d/m/Y")',
			            flex: 1,
			            editor: {
			            	xtype: 'datefield',
							allowBlank: true,
							reference: 'fechaVencimiento',
							maskRe: /[0-9.]/
						}
				   }
				   
			    ]/*,
			    dockedItems : [
			        {
			            xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            displayInfo: true,
			            bind: {
			                store: '{storeHoronarios}'
			            }
			        }
	    		]*/
			},
			{
				xtype : 'fieldsettable',
				defaultType : 'textfieldbase',

				title : HreRem.i18n('title.situacion.real.activo'),
				items : [
							{ 
					        	xtype: 'comboboxfieldbase',				        	
						 		fieldLabel: HreRem.i18n('fieldlabel.situacion.titulo'),
					        	bind: {
				            		store: '{comboEstadoTitulo}',
				            		value: '{datosRegistrales.estadoTitulo}'
				            	}
							},
							{ 
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.con.posesion.inicial'),
					        	bind: {
				            		store: '{comboSiNoRem}',
				            		value: '{condiciones.posesionInicial}'			            		
				            	},
				            	displayField: 'descripcion',
	    						valueField: 'codigo'
					        },
					        { 
					        	xtype: 'comboboxfieldbase',
//					        	editable: false,
					        	fieldLabel: HreRem.i18n('fieldlabel.situacion.posesoria'),
					        	bind: {
				            		store: '{comboSituacionPosesoria}',
				            		value: '{condiciones.situacionPosesoriaCodigo}'			            		
				            	},
				            	displayField: 'descripcion',
	    						valueField: 'codigo',
	    						editable: true
					        }
						]
			}
		];
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    
    funcionRecargar: function() {
		
    }
});