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
			    reference: 'listadohoronarios',
			    idPrincipal : 'expediente.id',
				cls	: 'panel-base shadow-panel',
				bind: {
					store: '{storeHoronarios}'
				},									
				listeners: {
					beforeedit: function(editor){
						// Siempre que se vaya a entrar en modo edición filtrar o limpiar el combo 'Tipo proveedor'.
						if (editor.editing) {
			        		// Si se está editando impedir filtrar erroneamente.
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
						text : HreRem.i18n('header.numero.activo'),
			        	dataIndex: 'idActivo',
			            flex     : 1,
			            editor: {
			            	xtype: 'combobox',	
							reference: 'comboActivoRef',
							allowBlank: false,
							store: new Ext.data.Store({
								model: 'HreRem.model.ComboBase',
								proxy: {
									type: 'uxproxy',
									remoteUrl: 'expedientecomercial/getComboActivos',
									extraParams: {idExpediente: me.lookupController().getViewModel().get("expediente.id")}
								},
								autoLoad: true
							}),
							displayField: 'numActivo',
							valueField: 'idActivo',
							listeners: {
								beforeselect: 'onSelectComboActivoHonorarios'
							}
			            },
			            renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {	
			        		var me = this,				        		
			        		comboEditor =  me.columns  && me.columns[colIndex].getEditor ? me.columns[colIndex].getEditor() : me.getEditor ? me.getEditor() : null;
			        		if(!Ext.isEmpty(comboEditor)) {
				        		var store = comboEditor.getStore(),							        		
				        		activo = store.findRecord("idActivo", value);
				        		if(!Ext.isEmpty(activo)) {								        			
				        			return activo.get("numActivo");								        		
				        		} else if (!Ext.isEmpty(record)) {
				        			comboEditor.setValue(record.get("idActivo"));	
				        			return record.get("numActivo");							        			
				        		}
			        		}
						}
					},
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
							valueField: 'codigo',
							listeners: {
								select: 'changeComboTipoProveedor'
							}
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
									remoteUrl: 'generic/getDiccionario',
									extraParams: {diccionario: 'tiposCalculo'}
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
			            renderer: Utils.rendererCurrency,
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