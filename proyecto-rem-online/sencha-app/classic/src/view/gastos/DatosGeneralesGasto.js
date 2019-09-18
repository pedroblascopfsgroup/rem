Ext.define('HreRem.view.gastos.DatosGeneralesGasto', {
    extend			: 'HreRem.view.common.FormBase',
    xtype			: 'datosgeneralesgasto',    
    cls				: 'panel-base shadow-panel',
    collapsed		: false,
    disableValidation: false,
    reference		: 'datosgeneralesgastoref',
    scrollable		: 'y',
	recordName		: "gasto",
	recordClass		: "HreRem.model.GastoProveedor",
    requires		: ['HreRem.model.GastoProveedor'],
    
    listeners: {
		activate: function(me, eOpts) {
			var estadoGasto= me.lookupController().getViewModel().get('gasto').get('estadoGastoCodigo');
			var autorizado = me.lookupController().getViewModel().get('gasto').get('autorizado');
	    	var rechazado = me.lookupController().getViewModel().get('gasto').get('rechazado');
	    	var agrupado = me.lookupController().getViewModel().get('gasto').get('esGastoAgrupado');
	    	var gestoria = me.lookupController().getViewModel().get('gasto').get('nombreGestoria')!=null;
	    	var cartera = me.lookupController().getViewModel().get('gasto').get('cartera');
			if(this.lookupController().botonesEdicionGasto(estadoGasto,autorizado,rechazado,agrupado,gestoria,this)){
				this.up('tabpanel').down('tabbar').down('button[itemId=botoneditar]').show();
			}
			else{
				this.up('tabpanel').down('tabbar').down('button[itemId=botoneditar]').hide();
			}
		}
	},

    initComponent: function () {

        var me = this;
        
        var storeEmisoresGasto = new Ext.data.Store({  
    		model: 'HreRem.model.Proveedor',
			proxy: {
				type: 'uxproxy',
				actionMethods: {read: 'POST'},
				remoteUrl: 'gastosproveedor/searchProveedoresByNif'
			}   	
    	}); 

		me.setTitle(HreRem.i18n('title.gasto.datos.generales'));
        me.items = [
					{   
						xtype:'fieldsettable',
						title: HreRem.i18n('title.gasto.datos.generales'),
						items : [
							{
								xtype: 'fieldset',
								title: HreRem.i18n('title.identificacion'),
								height: 375,
								margin: '0 10 10 0',
								collapsible: false,
								layout: 'vbox',
								items: [
									{
					                	xtype: 'textfieldbase',
					                	fieldLabel:  HreRem.i18n('fieldlabel.gasto.id.gasto.haya'),
					                	bind:		'{gasto.numGastoHaya}',
					                	readOnly: true					
				                	},
				                	{
										xtype: 'textfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.gasto.id.gestoria'),
										bind:		'{gasto.numGastoGestoria}',
										readOnly: true
									},
									{
										xtype: 'textfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.gasto.id.gasto.destinatario'),
										name: 'numGastoDestinatario',
										bind:{
											value: '{gasto.numGastoDestinatario}'													
										}
									},
									{
										xtype: 'textfieldbase',
										fieldLabel:  HreRem.i18n('fieldlabel.gasto.referencia.emisor'),
						                bind:		'{gasto.referenciaEmisor}',
						                allowBlank: false
									},
									{ 
										xtype: 'comboboxfieldbase',
						               	fieldLabel:  HreRem.i18n('fieldlabel.gasto.subtipo.gasto'),
						               	reference: 'subtipoGastoCombo',
								      	bind: {
							           		store: '{comboSubtiposGasto}',
							           		value: '{gasto.subtipoGastoCodigo}',
							           		disabled: '{!gasto.tipoGastoCodigo}'
							         	},
							         	allowBlank: false
							    	},
							    	{ 
										xtype: 'comboboxfieldbase',
						               	fieldLabel:  HreRem.i18n('fieldlabel.gasto.tipo.gasto'),
						               	reference: 'tipoGasto',
		        						chainedStore: 'comboSubtipoGasto',
										chainedReference: 'subtipoGastoCombo',
								      	bind: {
							           		store: '{comboTiposGasto}',
							           		value: '{gasto.tipoGastoCodigo}'
							         	},
							         	listeners: {
						                	select: 'onChangeChainedCombo'
						            	},
							         	allowBlank: false
							    	}
								]
							},
							{
								xtype: 'fieldset',
								title: HreRem.i18n('title.sujetos'),
								layout: 'vbox',
								height: 375,
								margin: '0 10 10 0',
								collapsible: false,
								items: [
										{
											xtype: 'textfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.gasto.nif.emisor'),		
											reference: 'buscadorNifEmisorField',
											readOnly: $AU.userIsRol(CONST.PERFILES['PROVEEDOR']),
											bind: '{gasto.buscadorNifEmisor}',
											triggers: {														
													buscarEmisor: {
											            cls: Ext.baseCSSPrefix + 'form-search-trigger',
											            handler: 'buscarProveedor'
											        }
											        
											},
											cls: 'searchfield-input sf-con-borde',
											enableKeyEvents: true,
									        listeners: {
										        	specialKey: function(field, e) {
										        		if (e.getKey() === e.ENTER) {
										        			field.lookupController().buscarProveedor(field);											        			
										        		}
										        	},
										        	change: function(field, newValue, oldValue) {
										        		if(Ext.isEmpty(newValue)) {
										        			field.up("form").down("[reference=comboProveedores]").reset()
										        		} else if (Ext.isEmpty(oldValue)) {
										        			field.lookupController().buscarProveedor(field);
										        		}
										        	
										        	}
										    },
										    publishes: 'value'
						                },	
										{
											xtype: 'comboboxfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.gasto.emisor'),													
											reference: 'comboProveedores',
											allowBlank: false,
											editable: false,
											store: storeEmisoresGasto,
											emptyText: HreRem.i18n('txt.seleccionar.emisor'),
											valueField		: 'codigo',
											bind: {
												value: '{gasto.codigoProveedorRem}'
											},
											tpl: Ext.create('Ext.XTemplate',
							            		    '<tpl for=".">',
							            		        '<div class="x-boundlist-item">{codigo} - {nombreProveedor} - {subtipoProveedorDescripcion}</div>',
							            		    '</tpl>'
							            	),
							            	displayTpl:  Ext.create('Ext.XTemplate',
							            		    '<tpl for=".">',
							            		        '{codigo} - {nombreProveedor} - {subtipoProveedorDescripcion}',
							            		    '</tpl>'
							            	)
					            	    },
									 { 
										xtype: 'comboboxfieldbase',
						               	fieldLabel:  HreRem.i18n('fieldlabel.gasto.destinatario'),
						               	name: 'destinatarioField',
						               	reference: 'destGasto',
								      	bind: {
							           		store: '{comboDestinatarios}',
							           		value: '{gasto.destinatario}',
							           		readOnly: '{!isGastoRefacturable}'
							         	},
							         	
							         	
							         	allowBlank: false
							    	},								    
									{
										xtype: 'textfieldbase',
										fieldLabel:  HreRem.i18n('fieldlabel.gasto.nif.propietario'),
										name: 'buscadorNifPropietarioField',
										bind: {
											value: '{gasto.buscadorNifPropietario}'
										},
										allowBlank: false,
										triggers: {
											
												buscarEmisor: {
										            cls: Ext.baseCSSPrefix + 'form-search-trigger',
										             handler: 'buscarPropietario'
										        }
										},
										cls: 'searchfield-input sf-con-borde',
										emptyText:  HreRem.i18n('txt.buscar.propietario'),
										enableKeyEvents: true,
								        listeners: {
								        	specialKey: function(field, e) {
								        		if (e.getKey() === e.ENTER) {
								        			field.lookupController().buscarPropietario(field);											        			
								        		}
								        	},
								        	blur: function(field, e) {
												field.lookupController().buscarPropietario(field);
											}
								        }
				                	},
				                	{
										xtype: 'textfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.gasto.nombre.propietario'),
										name: 'nombrePropietario',
										bind:{
											value: '{gasto.nombrePropietario}'													
										},
										readOnly: true
									}
								]
							},	
							{
								xtype: 'fieldset',
								layout: 'vbox',
								height: 375,
								margin: '0 5 10 0',
								title: HreRem.i18n('title.datos'),
								collapsible: false,
								items: [
										{
								        	xtype:'datefieldbase',
								        	formatter: 'date("d/m/Y")',
											reference: 'fechaEmision',
									       	fieldLabel: HreRem.i18n('fieldlabel.gasto.fecha.emision')+' *',
									       	bind: '{gasto.fechaEmision}',
									       	maxValue: null,
									       	allowBlank: false
									    },
									    { 
											xtype: 'comboboxfieldbase',
							               	fieldLabel:  HreRem.i18n('fieldlabel.gasto.estado.gasto'),
									      	bind: {
								           		store: '{comboEstadosGasto}',
								           		value: '{gasto.estadoGastoCodigo}'
								         	},
								         	readOnly: true
									    },
						                { 
											xtype: 'comboboxfieldbase',
							               	fieldLabel:  HreRem.i18n('fieldlabel.gasto.periodicidad')+' *',
							               	reference: 'cboxPeriodicidad',
							               	//editable: true,
									      	bind: {
								           		store: '{comboPeriodicidad}',
								           		value: '{gasto.periodicidad}'
								         	}								         	
									    },
										{
											xtype: 'textfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.gasto.concepto')+' *',
											bind: '{gasto.concepto}'
										},
									    { 
											xtype: 'comboboxfieldbase',
							               	fieldLabel:  HreRem.i18n('fieldlabel.gasto.tipo.operacion')+' *',
									      	bind: {
								           		store: '{comboTipoOperacion}',
								           		value: '{gasto.tipoOperacionCodigo}'
								         	}
									    },
										{
											xtype: 'numberfieldbase',
											fieldLabel:  HreRem.i18n('fieldlabel.gasto.id.gasto.abonado'),
											name: 'numGastoAbonado',
											bind: {
												value: '{gasto.numGastoAbonado}'
											},
											triggers: {
													buscarEmisor: {
											            cls: Ext.baseCSSPrefix + 'form-search-trigger',
											             handler: 'buscarGasto'
											        }
											},
											cls: 'searchfield-input sf-con-borde',
											emptyText:  HreRem.i18n('txt.buscar.gasto'),
											enableKeyEvents: true,
									        listeners: {
									        	specialKey: function(field, e) {
									        		if (e.getKey() === e.ENTER) {
									        			field.lookupController().buscarGasto(field);											        			
									        		}
									        	}
										    }
						                },
						                {
											xtype: 'numberfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.gasto.id.gasto.abonado'),
											name: 'idGastoAbonado',
											bind:{
												value: '{gasto.idGastoAbonado}'													
											},
											hidden: true
										},
										{
								        	xtype:'datefieldbase',
								        	formatter: 'date("d/m/Y")',
											reference: 'fechaRecPropiedad',
									       	fieldLabel: HreRem.i18n('fieldlabel.gasto.fecha.recPropiedad')+' *',
									       	bind: '{gasto.fechaRecPropiedad}',
									       	maxValue: null,
									       	allowBlank: false
									    },
									    {
								        	xtype:'datefieldbase',
								        	formatter: 'date("d/m/Y")',
											reference: 'fechaRecGestoria',
									       	fieldLabel: HreRem.i18n('fieldlabel.gasto.fecha.recGestoria')+' *',
									       	bind: '{gasto.fechaRecGestoria}',
									       	maxValue: null,
									       	allowBlank: false
									    },
									    {
								        	xtype:'datefieldbase',
								        	formatter: 'date("d/m/Y")',
											reference: 'fechaRecHaya',
									       	fieldLabel: HreRem.i18n('fieldlabel.gasto.fecha.recHaya')+' *',
									       	bind: '{gasto.fechaRecHaya}',
									       	maxValue: null,
									       	allowBlank: false
									    }										
									]
								}
							]
			           },
			           {   
							xtype:'fieldsettable',
							defaultType: 'textfieldbase',
							title: HreRem.i18n('title.gasto.trabjos.incluidos.factura'),
							items: [
								{
								    xtype: 'gridBase',
								    reference: 'listadoTrabajosIncluidosFactura',
									cls	: 'panel-base shadow-panel',
									bind: {
										store: '{storeTrabajosAfectados}'
									},
									listeners: {
										rowdblclick: 'onRowDblClickListadoTrabajosGasto'
									},
									tbar : {
											xtype: 'toolbar',
											dock: 'top',
											items: [
													{itemId: 'addButton',iconCls:'x-fa fa-plus', handler: 'onClickBotonAsignarTrabajosGasto', bind: {hidden: '{ocultarBotonesTrabajos}'}},
													{itemId: 'removeButton',iconCls:'x-fa fa-minus', handler: 'onClickBotonDesasignarTrabajosGasto', bind: {hidden: '{ocultarBotonesTrabajos}'}},
													{itemId: 'downloadButton', iconCls:'x-fa fa-download', handler: 'onExportClickTrabajos'}
											]
									},
									columns: [
									   {    text: HreRem.i18n('header.gasto.id.trabajo'),
								        	dataIndex: 'idTrabajo',
								        	flex: 1,
								        	hidden: true,
									        hideable: false
								       },
								       {
							            	text	 : HreRem.i18n('header.numero.trabajo'),
							                flex	 : 1,
							                dataIndex: 'numTrabajo'
							           },  
									   {
								            text: HreRem.i18n('header.subtipo'),
								            dataIndex: 'descripcionSubtipo',
								            flex: 1
									   },
									   {
									   		text: HreRem.i18n('header.fecha.ejecutado'),
								            dataIndex: 'fechaEjecutado',
								            formatter: 'date("d/m/Y")',
								            flex: 1
									   },						   
									   {
									   		text: HreRem.i18n('header.gasto.cubierto.seguro'),
								            dataIndex: 'cubreSeguro',
								            flex: 1	
									   },
									   {
									   		text: HreRem.i18n('header.importe.total'),
								            dataIndex: 'importeTotal',
								            flex: 1						   
									   }
								    ]
								}
							]
			           }
    	];

	    me.callParent(); 
    },

    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;		
		me.lookupController().cargarTabData(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    }
});