Ext.define('HreRem.view.gastos.DatosGeneralesGasto', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'datosgeneralesgasto',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'datosgeneralesgastoref',
    scrollable	: 'y',
	recordName: "gasto",
	
	recordClass: "HreRem.model.GastoProveedor",
    
    requires: ['HreRem.model.GastoProveedor'],
    
    listeners: {
		boxready:'cargarTabData'
	},
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.gasto.datos.generales'));
        var items= [
       
	    						{   
									xtype:'fieldsettable',
									title: HreRem.i18n('title.gasto.datos.generales'),
									items :
										[
							                {
							                	xtype: 'textfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.gasto.id.gasto.haya'),
							                	bind:		'{gasto.numGastoHaya}',
							                	readOnly: true
					
							                },
							                {
												xtype: 'textfieldbase',
												fieldLabel:  HreRem.i18n('fieldlabel.gasto.codigo.rem.emisor'),
												name: 'buscadorCodigoRemEmisorField',
												flex: 2,
												bind: {
													value: '{gasto.buscadorCodigoProveedorRem}'
												},
												allowBlank: false,
												readOnly: $AU.userIsRol(CONST.PERFILES['PROVEEDOR']),
												triggers: {
													
														buscarEmisor: {
												            cls: Ext.baseCSSPrefix + 'form-search-trigger',
												             handler: 'buscarProveedor'
												        }
												        
												},
												cls: 'searchfield-input sf-con-borde',
												emptyText:  HreRem.i18n('txt.buscar.emisor'),
												enableKeyEvents: true,
										        listeners: {
											        	specialKey: function(field, e) {
											        		if (e.getKey() === e.ENTER) {
											        			field.lookupController().buscarProveedor(field);											        			
											        		}
											        	}
											        }
							                },
							                {
									        	xtype:'datefieldbase',
												formatter: 'date("d/m/Y")',
												reference: 'fechaEmision',
										       	fieldLabel: HreRem.i18n('fieldlabel.gasto.fecha.emision'),
										       	bind: '{gasto.fechaEmision}',
										       	maxValue: null,
										       	allowBlank: false
										    },
											{
												xtype: 'textfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.gasto.id.gestoria'),
												bind:		'{gasto.numGastoGestoria}',
												readOnly: true
											},
											{
												xtype: 'textfieldbase',
												name: 'nombreEmisor',
												fieldLabel: HreRem.i18n('fieldlabel.gasto.nombre.emisor'),
												bind:		'{gasto.nombreEmisor}',
												readOnly: true
											},
											{ 
												xtype: 'comboboxfieldbase',
								               	fieldLabel:  HreRem.i18n('fieldlabel.gasto.periodicidad'),
										      	bind: {
									           		store: '{comboPeriodicidad}',
									           		value: '{gasto.periodicidad}'
									         	}
										    },
											{
												xtype: 'textfieldbase',
												fieldLabel:  HreRem.i18n('fieldlabel.gasto.referencia.emisor'),
								                bind:		'{gasto.referenciaEmisor}',
								                allowBlank: false
											},
											{
												xtype: 'textfieldbase',
												name: 'codigoEmisor',
												fieldLabel: HreRem.i18n('fieldlabel.gasto.codigo.emisor'),
												bind:		'{gasto.codigoEmisor}',
												readOnly: true
											},
											{
												xtype: 'textfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.gasto.concepto'),
												bind:		'{gasto.concepto}',
												allowBlank: false
											},
										    { 
												xtype: 'comboboxfieldbase',
								               	fieldLabel:  HreRem.i18n('fieldlabel.gasto.destinatario'),
										      	bind: {
									           		store: '{comboDestinatarios}',
									           		value: '{gasto.destinatario}',
									           		hidden: '{conPropietario}'
									         	},
									         	listeners:{
									         		change: 'onHaCambiadoComboDestinatario'
									         	},
									         	allowBlank: false
										    },
										    {
												xtype: 'textfieldbase',
												name: 'docIdentificativo',
												fieldLabel: HreRem.i18n('fieldlabel.gasto.nif.emisor'),
												bind:		'{gasto.nifEmisor}',
												readOnly: true
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
											
											/*,
										   	{
												xtype: 'button',
												text: HreRem.i18n('fieldlabel.gasto.incluir.trabajos.rem'),
											    margin: '0 0 10 0',
											    handler: 'onClickBotonIncluirTrabajosGasto'
											}*/
											
										]
					           },
           
					           {   
									xtype:'fieldsettable',
									defaultType: 'textfieldbase',				
									title: HreRem.i18n('title.gasto.trabjos.incluidos.factura'),
									items :
										[
											{
										    xtype		: 'gridBase',
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
      														{itemId: 'removeButton',iconCls:'x-fa fa-minus', handler: 'onClickBotonDesasignarTrabajosGasto', bind: {hidden: '{ocultarBotonesTrabajos}'}}
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
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
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