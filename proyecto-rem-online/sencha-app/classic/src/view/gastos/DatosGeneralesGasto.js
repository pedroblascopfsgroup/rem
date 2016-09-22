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
							                	bind:		'{gasto.idGastoHaya}',
							                	editable: false
					
							                },
							                {
							                	xtype: 'textfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.gasto.nif.emisor'),
							                	bind:		'{gasto.nifEmisor}',
							                	editable: false
					
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
												bind:		'{gasto.idGastoGestoria}',
												editable: false
											},
											{
												xtype: 'textfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.gasto.nombre.emisor'),
												bind:		'{gasto.nombreEmisor}',
												editable: false
											},
											{ 
												xtype: 'comboboxfieldbase',
								               	fieldLabel:  HreRem.i18n('fieldlabel.gasto.periodicidad'),
										      	bind: {
									           		store: '{comboPeriodicidad}',
									           		value: '{gasto.periodicidad}'
									         	},
									         	allowBlank: false
										    },
											{
												xtype: 'textfieldbase',
												fieldLabel:  HreRem.i18n('fieldlabel.gasto.referencia.emisor'),
								                bind:		'{gasto.referenciaEmisor}',
								                allowBlank: false
											},
											{
												xtype: 'textfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.gasto.id.emisor'),
												bind:		'{gasto.idEmisor}',
												editable: false
											},
											{
												xtype: 'textfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.gasto.concepto'),
												bind:		'{gasto.concepto}',
												allowBlank: false
											},
											{ 
												xtype: 'comboboxfieldbase',
								               	fieldLabel:  HreRem.i18n('fieldlabel.gasto.tipo.gasto'),
										      	bind: {
									           		store: '{comboTiposGasto}',
									           		value: '{gasto.tiposGasto}'
									         	},
									         	allowBlank: false
										    },
										    { 
												xtype: 'comboboxfieldbase',
								               	fieldLabel:  HreRem.i18n('fieldlabel.gasto.subtipo.gasto'),
										      	bind: {
									           		store: '{comboSubtiposGasto}',
									           		value: '{gasto.subtiposGasto}'
									         	},
									         	allowBlank: false
										    },
										    { 
												xtype: 'comboboxfieldbase',
								               	fieldLabel:  HreRem.i18n('fieldlabel.gasto.destinatario'),
										      	bind: {
									           		store: '{comboDestinatarios}',
									           		value: '{gasto.destinatario}'
									         	},
									         	allowBlank: false
										    },
										    
//										    { 
//												xtype: 'comboboxfieldbase',
//								               	fieldLabel:  HreRem.i18n('fieldlabel.gasto.propietario'),
//										      	bind: {
//									           		store: '{comboPropietarios}',
//									           		value: '{gasto.propietario}'
//									         	},
//									         	listeners: {
//									         		change: 'onHaCambiadoComboPropietario'
//									         	},
//									         	editable: true
//										    },
										    {
												xtype: 'textfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.gasto.propietario'),
												bind:		'{gasto.propietario}',
												editable: true,
												listeners: {
									         		change: 'onHaCambiadoComboPropietario'
									         	}
											},
										    {
												xtype: 'textfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.gasto.nif.propietario'),
												bind:		'{gasto.nifPropietario}',
												reference: 'nifPropietarioRef',
												disabled: true
											},
										    {
												xtype: 'textfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.gasto.nombre.propietario'),
												bind:		'{gasto.nombrePropietario}',
												reference: 'nombrePropietarioRef',
												disabled: true
											},
										    {
										    	
										    },
										    {
										    	
										    },
										   	{
												xtype: 'button',
												text: HreRem.i18n('fieldlabel.gasto.incluir.trabajos.rem'),
											    margin: '0 0 10 0',
						//					    handler: 'onClickBotonFavoritos'
											    disabled: true
											}
											
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
					//					    title: HreRem.i18n('title.notario'),
										    reference: 'listadoTrabajosIncluidosFactura',
											cls	: 'panel-base shadow-panel',
											bind: {
												store: '{storeTrabajosIncluidosFactura}'
											},									
											
											columns: [
											   {    text: HreRem.i18n('header.gasto.id.trabajo'),
										        	dataIndex: 'idTrabajo',
										        	flex: 1,
										        	hidden: true,
											        hideable: false
										       },
											   {
										            text: HreRem.i18n('header.gasto.subtipo.trabajo'),
										            dataIndex: 'subtipoTrabajo',
										            flex: 1
											   },
											   {
											   		text: HreRem.i18n('header.gasto.fecha.ejecucion'),
										            dataIndex: 'fechaEjecucion',
										            flex: 1
											   },						   
											   {
											   		text: HreRem.i18n('header.gasto.cubierto.seguro'),
										            dataIndex: 'cubiertoSeguro',
										            flex: 1	
											   },
											   {
											   		text: HreRem.i18n('header.gasto.importe.tarifa'),
										            dataIndex: 'importeTarifa',
										            flex: 1						   
											   },
											   {
											   		text: HreRem.i18n('header.gasto.importe.penalizacion'),
										            dataIndex: 'importePenalizacion',
										            flex: 1						   
											   },
											   {
											   		text: HreRem.i18n('header.gasto.importe.recargo'),
										            dataIndex: 'importeRecargo',
										            flex: 1						   
											   },
											   {
											   		text: HreRem.i18n('header.gasto.provisiones.suplidos'),
										            dataIndex: 'provisionesSuplidos',
										            flex: 1						   
											   }
										    ],
										    dockedItems : [
										        {
										            xtype: 'pagingtoolbar',
										            dock: 'bottom',
										            displayInfo: true,
										            bind: {
										                store: '{storeTrabajosIncluidosFactura}'
										            }
										        }
										    ]
					//					    listeners: {
					//					    	rowdblclick: 'onNotarioDblClick'
					//					    }
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
    	
    }
});