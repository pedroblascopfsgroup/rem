Ext.define('HreRem.view.expedientes.GestionEconomicaExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'gestioneconomicaexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'gestionEconomicaExpediente',
    scrollable	: 'y',
    layout: 'fit',

    initComponent: function () {
        var me = this;
        var codigoTipoProveedorFilter= null;
        me.codigoTipoProveedorFilter=null;
        var storeProveedores=null;
        
		me.setTitle(HreRem.i18n('title.gestion.economica'));
        var items= [

			{
				
            	xtype: 'fieldset',
            	flex: 1,
            	layout: 'fit',
            	title:  HreRem.i18n('title.horonarios'),
            	items : [
            	
                	{
					    xtype: 'gridBaseEditableRow',
					    topBar: true,
					    reference: 'listadohoronarios',
					    idPrincipal : 'expediente.id',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeHoronarios}'
						},									
						
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
    									select: 'onSelectComboActivoHonorarios'
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
    								valueField: 'codigo'
					            },
					            renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {	
					        		var me = this,				        		
					        		comboEditor =  me.columns  && me.columns[colIndex].getEditor ? me.columns[colIndex].getEditor() : me.getEditor ? me.getEditor() : null;
					        		if(!Ext.isEmpty(comboEditor)) {
						        		var store = comboEditor.getStore(),							        		
						        		accion = store.findRecord("codigo", value);
						        		if(!Ext.isEmpty(accion)) {								        			
						        			return accion.get("descripcion");								        		
						        		} else if (!Ext.isEmpty(record)) {
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
						        		var store = comboEditor.getStore(),							        		
						        		tipo = store.findRecord("codigo", value);
						        		if(!Ext.isEmpty(tipo)) {								        			
						        			return tipo.get("descripcion");								        		
						        		} else if (!Ext.isEmpty(record)) {
						        			comboEditor.setValue(record.get("codigo"));	
						        			return record.get("descripcion");							        			
						        		}
					        		}
								}
						   },
						   {
						   		text: HreRem.i18n('header.proveedores.codigo.rem'),
					            dataIndex: 'idProveedor',
					            flex: 1,
					            editor: {
									xtype: 'textfield',
    								allowBlank: false,
    								reference: 'proveedorRef'
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
					            	xtype:'textfield',
					            	reference: 'honorarios'
					            },
					            renderer: Utils.rendererCurrency
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
            }
    	];
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;
		var listadoHonorarios = me.down("[reference=listadohoronarios]");
		
		// FIXME ¿¿Deberiamos cargar la primera página??
		listadoHonorarios.getStore().load();		
		
    }
});