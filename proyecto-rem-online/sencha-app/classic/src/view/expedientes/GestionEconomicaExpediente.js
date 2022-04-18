Ext.define('HreRem.view.expedientes.GestionEconomicaExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'gestioneconomicaexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'gestionEconomicaExpediente',
    scrollable	: 'y',
    recordName: 'expedientecomercialgestioneconomica',	
    recordClass: 'HreRem.model.ExpedienteComercialGestionEconomica',    
    requires: ['HreRem.model.ExpedienteComercialGestionEconomica'],
    listeners: {
    	show: function () {
    		var me = this;
    		me.lookupController().checkVisibilidadBotonAuditoriaDesbloqueo(me.viewWithModel.getViewModel("expedientedetalle"));
    	},
    	boxready:'cargarTabData'
    },
    initComponent: function () {
        var me = this;
        var isGridDesbloqueado = false;
        var codigoTipoProveedorFilter= null;
        me.codigoTipoProveedorFilter=null;
        var storeProveedores=null;
       

        
		me.setTitle(HreRem.i18n('title.gestion.economica'));
        var items= [
			  {
				  xtype:'fieldsettable',
					title: 'Controller',
					items :
					 [
						{ 
							xtype: 'comboboxfieldbase',
							editable: true,
							fieldLabel: 'Revisado por Controllers',
							bind: {
						        store: '{comboSiNoRem}',
						        value: '{expedientecomercialgestioneconomica.revisadoPorControllers}'
						    },
						    readOnly:  $AU.userIsRol("HAYASUPER") || $AU.userIsRol("PERFGCONTROLLER") ? false : true, 
						    allowBlank: false,
						    listeners: { 
					           change: 'onChangeComboRevisadoControllers' 
						    }
				        },
						{ 
				            xtype: 'datefieldbase',
					        fieldLabel:  'Fecha Revisión',
					        reference: 'fechaRevisionref',
					        formatter: 'date("d/m/Y")',
					        bind: {
					        	value: '{expedientecomercialgestioneconomica.fechaRevision}',
					        	readOnly: true
					        },
					        allowBlank: false
						}
					]
			},
        	{   
				xtype:'fieldsettable',
				title: HreRem.i18n('fieldlabel.canal.origen.lead'),
				items :
					[
						{
							xtype: 'origenDelLeadGrid',
							reference: 'listaOrigenLead',
							margin: '10 40 5 10'
						}
					]
        	},
			{
				
            	xtype: 'fieldset',
            	title:  HreRem.i18n('title.horonarios'),
            	items : [
					{
						xtype : 'button',
						reference : 'btnRecalcularHonorarios',
						text : HreRem.i18n('btn.recalcular.honorarios'),
						handler : 'recalcularHonorarios',
						margin : '10 10 10 10',
						hidden: true
					},
            		{
						xtype: 'button',
						text: HreRem.i18n('btn.enviar.honorarios'),
						handler: 'enviarHonorariosUvem',
						margin: '10 40 5 10',
						bind:{
							hidden: '{!esCarteraBankia}'
						}
					},
                	{
					    xtype: 'gridBaseEditableRow',
					    topBar: true,
					    reference: 'listadohoronarios',
					    idPrincipal : 'expediente.id',
						cls	: 'panel-base shadow-panel',
						//secFunToEdit: 'EDITAR_GRID_GESTION_ECONOMICA_EXPEDIENTE',
						bind: {
							store: '{storeHoronarios}'
						},									
						listeners: {
							beforeedit: function(editor){
								
								if(!me.edicionHabilitada(me)){
									return false;									
								}
								// Siempre que se vaya a entrar en modo ediciÃ³n filtrar o limpiar el combo 'Tipo proveedor'.
								if (editor.editing) {
					        		// Si se estÃ¡ editando impedir filtrar erroneamente.
									return false;
					        	}

								var comboTipoProveedor = me.up('expedientedetallemain').lookupReference('tipoProveedorRef');
								var storeTipoProveedor = comboTipoProveedor.getStore();
								var grid = me.up('expedientedetallemain').lookupReference('listadohoronarios');
								var ultimaSeleccion = grid.selModel.lastSelected;

								if(Ext.isEmpty(ultimaSeleccion)) {
									return true;
								}

								var tipoComision = ultimaSeleccion.get('codigoTipoComision');

								if(!Ext.isEmpty(tipoComision) && tipoComision == CONST.ACCION_GASTOS['COLABORACION']) {
									storeTipoProveedor.clearFilter();
									storeTipoProveedor.filter([{
						                filterFn: function(rec){
						                    if (rec.get('codigo') == CONST.TIPO_PROVEEDOR_HONORARIO['MEDIADOR'] || rec.get('codigo') == CONST.TIPO_PROVEEDOR_HONORARIO['FVD']){
						                        return true;
						                    }
						                    return false;
						                }
						            }]);
								} else {
									storeTipoProveedor.clearFilter();
								}
							},
					        selectionchange: function (grid, records) {
					        	this.onGridBaseSelectionChange(grid, records);
					    		me.evaluarBotonAdd(me);
					    		me.evaluarBotonRemove(me);
					        }
					        ,render: function(){
					        	me.evaluarBotonAdd(me);
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
					            text: HreRem.i18n('fieldlabel.tipoComision'),
					            dataIndex: 'codigoTipoComision',
					            flex: 1,
					            editor: {
									xtype: 'combobox',	
									reference: 'comboParticipacionRef',
									allowBlank: false,
									store: new Ext.data.Store({
										model: 'HreRem.model.ComboBase',
										proxy: {
											type: 'uxproxy',
											remoteUrl: 'generic/getDiccionario',
											extraParams: {diccionario: 'accionesGasto'}
										},
										autoLoad: true
									}),
									displayField: 'descripcion',
    								valueField: 'codigo',
    								listeners: {
    									select: 'onTipoComisionSelect'
    								}
					            },
					            renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {	
					        		var me = this,
					        		comboEditor =  me.columns  && me.columns[colIndex].getEditor ? me.columns[colIndex].getEditor() : me.getEditor ? me.getEditor() : null;

					        		if(!Ext.isEmpty(comboEditor)) {
						        		var store = comboEditor.getStore();
						        		if (!Ext.isEmpty(record)) {
						        			comboEditor.setValue(record.get("codigoTipoComision"));
						        			return record.get("descripcionTipoComision");
						        		}
					        		}
								}
						   },
						   {
						   		text: HreRem.i18n('header.tipo.proveedor'),
					            dataIndex: 'codigoTipoProveedor',
					            reference: 'tipoProveedorVistaRef',
					            flex: 1,
					            editor: {
									xtype: 'combobox',	
									reference: 'tipoProveedorRef',
									store: new Ext.data.Store({
										model: 'HreRem.model.ComboBase',
										proxy: {
											type: 'uxproxy',
											remoteUrl: 'generic/getDiccionario',
											extraParams: {diccionario: 'tiposProveedorHonorario'}
										},
										autoLoad: true
									}),
									editable: false,
									allowBlank: false,
									displayField: 'descripcion',
    								valueField: 'codigo'
/*    								REMVIP-254. Se prevee que se tenga que volver a modificar
 * 									listeners: {
    									select: 'changeComboTipoProveedor'
    								}*/
								},
								renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {
									var me = this,				        		
					        		comboEditor =  me.columns  && me.columns[colIndex].getEditor ? me.columns[colIndex].getEditor() : me.getEditor ? me.getEditor() : null;
					        		if(!Ext.isEmpty(comboEditor)) {
						        		var store = comboEditor.getStore();
						        		if (!Ext.isEmpty(record)) {
						        			comboEditor.setValue(record.get("codigoTipoProveedor"));	
						        			return record.get("tipoProveedor");							        			
						        		}
					        		}
								}
						   },
						   {
						   		text: HreRem.i18n('header.proveedores.codigo.rem'),
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
						   		text: HreRem.i18n('fieldlabel.proveedor'),
					            dataIndex: 'proveedor',
					            flex: 1
								
						   },
						   {
						   		text: HreRem.i18n('header.tipo.calculo'),
					            dataIndex: 'codigoTipoCalculo',
					            flex: 1,
					            editor: {
									xtype: 'combobox',	
									reference: 'tipoCalculoHonorario',
									store: new Ext.data.Store({
										model: 'HreRem.model.ComboBase',
										proxy: {
											type: 'uxproxy',
											remoteUrl: 'expedientecomercial/getComboTipoCalculo',
											extraParams: {idExpediente: me.lookupController().getViewModel().get("expediente.id")}
										},
										autoLoad: true
									}),
									displayField: 'descripcion',
    								valueField: 'codigo',
    								allowBlank: false,
    								listeners:{
					            		change: 'onHaCambiadoImporteCalculo'
					           		}
								},
								renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {								        		
					        		var me = this;					        		
					        		var comboEditor =  me.columns  && me.columns[colIndex].getEditor ? me.columns[colIndex].getEditor() : me.getEditor ? me.getEditor() : null;
					        		if(!Ext.isEmpty(comboEditor)) {
						        		var store = comboEditor.getStore(),							        		
						        		tipo = store.findRecord("codigoTipoCalculo", value);
						        		if(!Ext.isEmpty(tipo)) {								        			
						        			return tipo.get("tipoCalculo");								        		
						        		} else if (!Ext.isEmpty(record)) {
						        			comboEditor.setValue(record.get("codigoTipoCalculo"));	
						        			return record.get("tipoCalculo");							        			
						        		}
					        		}
								}
						   },
						   {
						   		xtype: 'numbercolumn',
						   		text: HreRem.i18n('header.importe.calculo'),
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
						   		text: HreRem.i18n('fieldlabel.honorarios'),
					            dataIndex: 'honorarios',
					            flex: 1,
					            editor: {
					            	editable: false,
					            	reference: 'honorarios'
					            },
					            renderer: function (value, meta, record) {
						    		var importeOriginal = record.get('importeOriginal');
						    		if(value){
							    		if (importeOriginal != null && importeOriginal != value && value > 5000) {
							    			return '<span style="font-weight: bold;">('+Utils.rendererCurrency(value)+')</span> '
							    			+ '<span style="color: #DF0101; text-decoration: line-through; font-weight: bold;">'+Utils.rendererCurrency(importeOriginal)+'</span>';
							    		} else {
							    			return Utils.rendererCurrency(value);
							    		}
						    		} else {
							    		return '-';
							    	}
						    	},
					            summaryType: 'sum',
				            	summaryRenderer: function(value, summaryData, dataIndex) {
					            	var suma = 0;
					            	var store = this.up('grid').store;

					            	for(var i=0; i< store.data.length; i++){
					            		if(store.data.items[i].data.honorarios != null){
					            			suma += parseFloat(store.data.items[i].data.honorarios);
					            		}
					            	}
					            	suma = Ext.util.Format.number(suma, '0.00');
					            	var msg = HreRem.i18n("grid.honorarios.total.honorarios") + " " + suma + " \u20AC";		
					            	return msg;
					            }
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.observaciones'),
					            dataIndex: 'observaciones',
					            flex: 1,
					            editor: {
					            	xtype:'textarea',
					            	reference: 'observaciones'
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
					}
            	]
            }, {
				xtype: 'button',
				text: HreRem.i18n('btn.editar.desbloqueo.honorarios'),
				reference:"botonAuditoriaDesbloqueo" ,
				handler: function () {
						var me = this;
						me.lookupController().editarAuditoriaDesbloqueo(me.up());
				},
				margin: '10 40 5 10',
				bind:{ 
					hidden: '{!visibleBotonAuditoriaDesbloqueo}'
				}
			},
            {   
				xtype:'fieldsettable',
				title: HreRem.i18n('fieldlabel.nombre.auditoria.desbloqueo'),
				items :
					[
						{
							xtype: 'auditoriaDesbloqueoGrid',
							reference: 'listaAuditoriaDesbloqueo',
							margin: '10 40 5 10'
						}
					]
        	}
    	];
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    evaluarBotonAdd: function(me){
    	me.down("[reference=listadohoronarios]").setDisabledAddBtn(!me.edicionHabilitada(me));
    },
    evaluarBotonRemove: function(me){
       me.down("[reference=listadohoronarios]").setDisabledDeleteBtn(!me.edicionHabilitada(me));       
    },
    edicionHabilitada: function(me) {
    	var userHasFunction = $AU.userHasFunction(['EDITAR_TAB_GESTION_ECONOMICA_EXPEDIENTES']);
    	var isFinalizadoCierreEconomico = me.up('expedientedetallemain').getViewModel().get('expediente.finalizadoCierreEconomico');
    	
		return  (userHasFunction && !isFinalizadoCierreEconomico) || me.isGridDesbloqueado; 
    },
    habilitarGrid: function() {
    	var me = this;
    	var gridHonorarios = me.down("[reference=listadohoronarios]");
    	gridHonorarios.setDisabledAddBtn(false);
    	gridHonorarios.setDisabledDeleteBtn(false);
    	me.isGridDesbloqueado = true;
    },
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
		var listadoHonorarios = me.down("[reference=listadohoronarios]");
		var listaOrigenLead = me.down("[reference=listaOrigenLead]");
		var listaAuditoriaDesbloqueo = me.down("[reference=listaAuditoriaDesbloqueo]");
		var botonAuditoriaDesbloqueo = me.down("[reference=botonAuditoriaDesbloqueo]");
		// FIXME Â¿Â¿Deberiamos cargar la primera pÃ¡gina??
		listadoHonorarios.getStore().load();	
		listaOrigenLead.getStore().load();
		listaAuditoriaDesbloqueo.getStore().load();
		listadoHonorarios.setDisabledAddBtn(!me.edicionHabilitada(me));
		me.lookupController().checkVisibilidadBotonAuditoriaDesbloqueo(me.viewWithModel.getViewModel("expedientedetalle"));
    }
});