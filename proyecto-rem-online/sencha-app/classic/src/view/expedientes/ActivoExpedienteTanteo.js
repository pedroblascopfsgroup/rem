Ext.define('HreRem.view.expedientes.ActivoExpedienteTanteo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'activoexpedientetanteo',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    reference: 'activoexpedientetanteo',
    scrollable	: 'y',    
    requires: [],
    saveMultiple: false,
    disableValidation: true,
    
    listeners: {},
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.tanteo'));
        var items= [
			{
			    xtype: 'gridBaseEditableRow',
			    topBar: true,
			    reference: 'listadotanteos',
			    idPrincipal : 'activoExpedienteSeleccionado.idActivo',
			    idSecundaria : 'expediente.id',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeTanteosActivo}',
					topBar: '{!esExpedienteBloqueado}'
						
				},
				minHeight : 250,
				listeners: {
					rowclick: function(dataview,record) {
						this.up('form').setBindRecord(record.data);
						this.up('form').down('fieldsettable').setHidden(false);
						
						var me = this;
	     				var selection = me.getSelection();
	     				if(Ext.isEmpty(selection)) {
	     					return;
	     				}
	     				var fechaRespuesta = selection[0].getData().fechaRespuesta;
	     				

	     				if(!Ext.isEmpty(fechaRespuesta)) {
	     					me.disableRemoveButton(true);
	     				} else {
	     					me.disableRemoveButton(false);
	     				}
					}
					
				},
				saveSuccessFn: function() {
					var me = this;
			    	var activoExpedienteMain = me.up('activosexpediente');
					var grid = activoExpedienteMain.down('gridBaseEditableRow');
					if(grid){
						var store = grid.getStore();
						grid.expand();
						store.loadPage(1)
					}
			    	return true;
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
							allowBlank: false,
							maxValue: new Date(),
		                	minValue: null,
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
				   		dataIndex: 'solicitaVisitaCodigo',
			            flex: 1,
			            editor: {
				            xtype: 'combobox',
				            displayField: 'descripcion',
				            valueField: 'codigo',
				            bind: {
				            	store: '{comboSiNoRem}'
				            },
				            reference: 'solicitaVisitaCodigo'
				        },
				        renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {	
			        		var me = this,
			        		comboEditor =  me.columns  && me.columns[colIndex].getEditor ? me.columns[colIndex].getEditor() : me.getEditor ? me.getEditor() : null;

			        		if(!Ext.isEmpty(comboEditor)) {
				        		var store = comboEditor.getStore();
				        		if (!Ext.isEmpty(record)) {
				        			comboEditor.setValue(record.get("solicitaVisitaCodigo"));
				        			return record.get("solicitaVisita");
				        		}
			        		}
						}
				   },
				   {
				   		text: HreRem.i18n('fieldlabel.otyr.fecha.realizacion.visita'),
			            dataIndex: 'fechaVisita',
			            align: 'center',
			            formatter: 'date("d/m/Y")',
			            flex: 1,
			            editor: {
			            	xtype: 'datefield',
			            	allowBlank: true,
							reference: 'fechaVisita',
							maskRe: /[0-9.]/
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
			            	readOnly : true,
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
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.oferta.tanteo.retracto.detalle'),
				hidden: true,
				items :
					[
						{
							xtype: 'textfieldbase',
							name: 'idActivo',
							fieldLabel:  'Nº activo',
							readOnly: true,
							maxLength: 10,
							bind: {
								value: '{idActivo}'
							}
						},
						{ 
				        	xtype: 'comboboxfieldbase',
				        	readOnly: true,
				        	reference: 'comboTipoAdministracionRef',
					 		fieldLabel: HreRem.i18n('title.configuracion.administracion'),
					 		bind: {
			            		store: '{comboAdministracion}',
			            		value: '{codigoTipoAdministracion}'
			            	}
						},
			            {
		                	xtype:'datefieldbase',
		                	name: 'fechaFinTanteo',
							formatter: 'date("d/m/Y")',
		                	fieldLabel:  HreRem.i18n('fieldlabel.otyr.fecha.fin.tanteo'),
		                	readOnly: true,
		                	maxValue: null,
		                	minValue: null,
		                	bind:		'{fechaFinTanteo}'
		                },
		                {
		                	xtype: 'textfieldbase',
		                	name: 'condiciones',
		                	fieldLabel:  HreRem.i18n('fieldlabel.otyr.condiciones'),
		                	colspan: 3,
		                	defaultMaxWidth: '100%',
		                	maxLength: 1999,
		                	bind: {
								value: '{condiciones}'
							}
		                },
		                {
		                	xtype:'datefieldbase',
		                	name: 'fechaComunicacion',
							formatter: 'date("d/m/Y")',
		                	fieldLabel:  HreRem.i18n('fieldlabel.otyr.fecha.comunicacion'),
		                	bind:		'{fechaComunicacion}',
		                	maxValue: new Date(),
		                	minValue: null,
		                	allowBlank: false
		                		
		                },
		                {
		                	xtype:'datefieldbase',
		                	name: 'fechaRespuesta',
							formatter: 'date("d/m/Y")',
		                	fieldLabel:  HreRem.i18n('fieldlabel.otyr.fecha.contestacion'),
		                	bind:		'{fechaRespuesta}'
		                },
		                { 
							xtype: 'textfieldbase',
							name: 'numeroExpediente',
		                	fieldLabel:  HreRem.i18n('header.oferta.expediente'),
				        	bind: '{numeroExpediente}'
				        },
				        { 
				        	xtype: 'comboboxfieldbase',
				        	name: 'solicitaVisitaCodigo',
				        	fieldLabel: HreRem.i18n('header.solicita.visita'),
				        	bind: {
			            		store: '{comboSiNoRem}',
			            		value: '{solicitaVisitaCodigo}'			            		
			            	},
			            	displayField: 'descripcion',
    						valueField: 'codigo'
				        },
		                {
		                	xtype:'datefieldbase',
		                	name: 'fechaVisita',
							formatter: 'date("d/m/Y")',
		                	fieldLabel:  HreRem.i18n('fieldlabel.otyr.fecha.realizacion.visita'),
		                	bind:		'{fechaVisita}'
		                },
		                {
		                	xtype: 'comboboxfieldbase',
		                	name: 'codigoTipoResolucion',
		                	bind: {
								store: '{comboResultadoTanteo}',
								value: '{codigoTipoResolucion}'
							},
		                	fieldLabel:  HreRem.i18n('fieldlabel.otyr.resultado.tanteo')
		                },
		                {
		                	xtype:'datefieldbase',
		                	name: 'fechaResolucion',
							formatter: 'date("d/m/Y")',
		                	fieldLabel:  HreRem.i18n('header.fecha.resolucion'),
		                	bind:		'{fechaResolucion}',
		                	allowBlank: true,
							maskRe: /[0-9.]/
		                },
		                {
		                	xtype:'datefieldbase',
		                	name: 'fechaVencimiento',
							formatter: 'date("d/m/Y")',
		                	fieldLabel:  HreRem.i18n('header.fecha.vencimiento'),
		                	bind:		'{fechaVencimiento}',
		                	allowBlank: true,
							maskRe: /[0-9.]/
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
		//bloqueado = me.getViewModel().get('expediente.bloqueado');
		Ext.Array.each(me.query('grid'), function(grid) {
			grid.mask();
  			grid.getStore().load({callback: function() {grid.unmask();}});
  			//grid.setTopBar(!bloqueado)
  		});
    }
});