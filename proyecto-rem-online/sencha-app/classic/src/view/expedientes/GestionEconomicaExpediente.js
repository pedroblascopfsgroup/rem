Ext.define('HreRem.view.expedientes.GestionEconomicaExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'gestioneconomicaexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'gestionEconomicaExpediente',
    scrollable	: 'y',
    

    initComponent: function () {
        var me = this;
        var codigoTipoProveedorFilter= null;
        me.codigoTipoProveedorFilter=null;
        var storeProveedores=null;
       	me.storeProveedores = new Ext.data.Store({
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'expedientecomercial/getComboProveedoresExpediente'
			},
			autoLoad: false
		});
        
		me.setTitle(HreRem.i18n('title.gestion.economica'));
        var items= [

			{
				
            	xtype: 'fieldset',
            	collapsible: true,
            	title:  HreRem.i18n('title.horonarios'),
            	items : [
            	
                	{
					    xtype		: 'gridBaseEditableRow',
					    topBar: true,
					    reference: 'listadohoronarios',
					    idPrincipal : 'expediente.id',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeHoronarios}'
						},									
						
						columns: [
						   {
					            text: HreRem.i18n('fieldlabel.participacion'),
					            dataIndex: 'participacion',
					            flex: 1,
					            editor: {
									xtype: 'combobox',	
									reference: 'comboParticipacionRef',
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
									chainedStore: me.storeProveedores,
									chainedReference: 'proveedorRef',
									displayField: 'descripcion',
    								valueField: 'codigo',
    								listeners: {
    									select: 'changeComboTipoProveedor'
    								}
								},
								renderer: function(value, a, record, e) {
									return record.data.tipoProveedor;
								}
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.proveedor'),
					            dataIndex: 'idProveedor',
					            reference: 'proveedorVistaRef',
					            flex: 1,
					            editor: {
									xtype: 'combobox',	
									reference: 'proveedorRef',
									store: me.storeProveedores,
									enableKeyEvents: true,
									displayField: 'nombre',
    								valueField: 'id',
    								
    								listeners: {
										'keyup': 'changeComboProveedor',
										'expand': 'expandeComboProveedor'
									}
								},
								renderer: function(value, a, record, e) {								        		
					        		var me = this;					        		
					        		var comboEditor = me.columns && me.down('gridcolumn[dataIndex=idProveedor]').getEditor ? me.down('gridcolumn[dataIndex=idProveedor]').getEditor() : me.getEditor ? me.getEditor():null;
					        		if(!Ext.isEmpty(comboEditor)) {
						        		var store = comboEditor.getStore(),							        		
						        		prov = store.findRecord("id", value);
						        		if(!Ext.isEmpty(prov)) {								        			
						        			return prov.get("descripcion");								        		
						        		} else if (!Ext.isEmpty(record)) {
						        			comboEditor.setValue(record.data.proveedor);	
						        			return record.data.proveedor;							        			
						        		}
					        		}
								}
								
						   },
//						   {
//						   		text: HreRem.i18n('fieldlabel.id'),
//					            dataIndex: 'codigoId',
//					            flex: 1						   
//						   },
						   {
						   		text: HreRem.i18n('header.tipo.calculo'),
					            dataIndex: 'tipoCalculo',
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
    								listeners:{
					            		change: 'onHaCambiadoImporteCalculo'
					           		}
								}
						   },
						   {
						   		text: HreRem.i18n('header.importe.calculo'),
					            dataIndex: 'importeCalculo',
					            flex: 1,
					            editor: {
					            	xtype:'numberfield',
					            	reference: 'importeCalculoHonorario',
					            	listeners:{
					            		change: 'onHaCambiadoImporteCalculo'
					           		},
					           		maxValue: null
					           							            
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
					    ],
					    dockedItems : [
					        {
					            xtype: 'pagingtoolbar',
					            dock: 'bottom',
					            displayInfo: true,
					            bind: {
					                store: '{storeHoronarios}'
					            }
					        }
			    		]
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