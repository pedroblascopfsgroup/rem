Ext.define('HreRem.view.expedientes.PbcExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'pbcexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    refreshAfterSave: true,
    saveMultiple: true,
    reference: 'pbcexpedienteref',
    scrollable	: 'y',
    //records: [''],	
    //recordsClass: [''],    
    //requires: [''],
    listeners: {
    	boxready: 'cargarTabData'
    },
    initComponent: function () {
    	
    	var me = this;
		me.setTitle(HreRem.i18n('PBC'));
		
		var coloredRender = function (value, meta, record) {
    		var borrado = record.get('borrado');
    		if(value){
	    		if (borrado) {
	    			/*if(meta.column.dataIndex==''){
	    				return '<span style="color: #DF0101;">'+Ext.util.Format.number(value, '0.00%')+'</span>';
	    			}*/
	    			return '<span style="color: #DF0101;">'+value+'</span>';
	    		} else {
	    			/*if(meta.column.dataIndex==''){
	    				return Ext.util.Format.number(value, '0.00%');
	    			}*/
	    			return value;
	    		}
    		} else {
    			if(borrado){
    				return '<span style="color: #DF0101;">-</span>';
    			}
	    		return '-';
	    	}
    	};

        var items = [
        	{    
                xtype: 'fieldsettable',
				defaultType: 'displayfield',
				colspan: 3,
				title: HreRem.i18n('Datos operación'),
				items: [
					{
						xtype: 'displayfieldbase',
						fieldLabel: HreRem.i18n('Nivel de riesgo'),
						colspan: 1
						//bind:		'{}'
					},
					{
						xtype: 'displayfieldbase',
						fieldLabel: HreRem.i18n('Operación sospechosa'),
						colspan: 1
						//bind:		'{}'
					},
					{
						xtype: 'displayfieldbase',
						fieldLabel: HreRem.i18n('Detección inicio BC/BT'),
						colspan: 1
						//bind:		'{}'
					},
					{
						xtype: 'displayfieldbase',
						fieldLabel: HreRem.i18n('El cliente intenta ocultar la identidad del titular'),
						colspan: 1
						//bind:		'{}'
					},
					{
						xtype: 'displayfieldbase',
						fieldLabel: HreRem.i18n('El cliente muestra actitud incoherente'),
						colspan: 1
						//bind:		'{}'
					},
					{
						xtype: 'displayfieldbase',
						fieldLabel: HreRem.i18n('LA sociedad mantiene titulos al portador'),
						colspan: 1
						//bind:		'{}'
					},
					{
			        	xtype: 		'textareafieldbase',
						fieldLabel: HreRem.i18n('Motivo de compra'),
						colspan: 3,
				 		//height: 	200,
				 		//maxWidth:   550,
				 		//rowspan:	5,
		            	//bind:		'{}',
						readOnly: true,
				 		labelAlign: 'top'
					},
					{
			        	xtype: 		'textareafieldbase',
						fieldLabel: HreRem.i18n('Finalidad de la operacion'),
						colspan: 3,
				 		//height: 	200,
				 		//maxWidth:   550,
				 		//rowspan:	5,
		            	//bind:		'{}',
						readOnly: true,
				 		labelAlign: 'top'
					}
				]	
        	},
        	{    
                xtype: 'fieldsettable',
				defaultType: 'displayfield',
				colspan: 3,
				title: HreRem.i18n('Datos de pago'),
				items: [
					{
						xtype: 'displayfieldbase',
						fieldLabel: HreRem.i18n('Origen fondos Fondos propios'),
						colspan: 1
						//bind:		'{}'
					},
					{
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('Procedencia fondos propios'),
						colspan: 1,
						reference: 'fechaProcedenciaFondosPropiosRef',
	                	bind:		{
	                		//value: '{}',
	                		//readOnly: true
	                	}
	                },
					{
						xtype: 'displayfieldbase',
						fieldLabel: HreRem.i18n('Otra procedencia fondos propios'),
						colspan: 1
						//bind:		'{}'
					},
					{
						xtype: 'displayfieldbase',
						fieldLabel: HreRem.i18n('Medios de pago Operación de Venta'),
						colspan: 1
						//bind:		'{}'
					},
					{
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('Se propone el pago a través de intermediario'),
						colspan: 1,
						reference: 'fechaPagoIntermediarioRef',
	                	bind:		{
	                		//value: '{}',
	                		//readOnly: true
	                	}
	                },
					{
						xtype: 'displayfieldbase',
						fieldLabel: HreRem.i18n('País transferencia'),
						colspan: 1
						//bind:		'{}'
					},
					{
						xtype: 'displayfieldbase',
						fieldLabel: HreRem.i18n('Origen fondos Financiación bancaria'),
						colspan: 1
						//bind:		'{}'
					}
				]	
        	},
        	{    
                xtype: 'fieldsettable',
				defaultType: 'displayfield',
				colspan: 3,
				title: HreRem.i18n('Hitos arras'),
				items: [
					{
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('Fecha solicitud cálculo de riesgo'),
						colspan: 1,
						reference: 'fechaSolicitudCalculoRiesgoRef',
	                	bind:		{
	                		//value: '{}',
	                		//readOnly: true
	                	}
	                },
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('Fechas comunicación del riesgo'),
						colspan: 2,
						reference: 'fechaComunicacionRiesgoRef',
	                	bind:		{
	                		//value: '{}',
	                		//readOnly: true
	                	}
	                },
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('Fecha envío documentación a BC'),
						colspan: 1,
						reference: 'fechaEnvioDocumentacionBCRef',
	                	bind:		{
	                		//value: '{}',
	                		//readOnly: true
	                	}
	                },
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('Fecha sanción BC'),
						colspan: 2,
						reference: 'fechaSancionBCRef',
	                	bind:		{
	                		//value: '{}',
	                		//readOnly: true
	                	}
	                }
				]	
        	},
        	,
        	{    
                xtype: 'fieldsettable',
				defaultType: 'displayfield',
				colspan: 3,
				title: HreRem.i18n('Hitos venta'),
				items: [
					{
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('Fecha solicitud cálculo de riesgo'),
						colspan: 1,
						reference: 'fechaSolicitudCalculoRiesgoRef',
	                	bind:		{
	                		//value: '{}',
	                		//readOnly: true
	                	}
	                },
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('Fechas comunicación del riesgo'),
						colspan: 2,
						reference: 'fechaComunicacionRiesgoRef',
	                	bind:		{
	                		//value: '{}',
	                		//readOnly: true
	                	}
	                },
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('Fecha envío documentación a BC'),
						colspan: 1,
						reference: 'fechaEnvioDocumentacionBCRef',
	                	bind:		{
	                		//value: '{}',
	                		//readOnly: true
	                	}
	                },
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('Fecha sanción BC'),
						colspan: 2,
						reference: 'fechaSancionBCRef',
	                	bind:		{
	                		//value: '{}',
	                		//readOnly: true
	                	}
	                }
				]	
        	},
        	{    
                xtype: 'fieldsettable',
				defaultType: 'displayfield',
				colspan: 3,
				title: HreRem.i18n('PBC Cumplimiento Normativo'),
				items: [
					{
	                	xtype: 'comboboxfieldbase',
						reference: 'aprobacionPBCArrasRef',
						colspan: 1,
	                	fieldLabel:  HreRem.i18n('Aprobación PBC CN'),
			        	bind: {
		            		store: '{comboSiNoRem}'
		            		//value: '{}'
		            	}
					},
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('Fecha Sanción'),
						colspan: 2,
						reference: 'fechaSancionCNRef',
	                	bind:		{
	                		//value: '{}',
	                		//readOnly: true
	                	}
	                }
				]	
        	},
        	{    
                xtype: 'fieldsettable',
				defaultType: 'displayfield',
				colspan: 3,
				title: HreRem.i18n('PBC Arras'),
				items: [
					{
	                	xtype: 'comboboxfieldbase',
						reference: 'aprobacionPBCArrasRef',
						colspan: 1,
	                	fieldLabel:  HreRem.i18n('Aprobación PBC Arras'),
			        	bind: {
		            		store: '{comboSiNoRem}'
		            		//value: '{}'
		            	}
					},
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('Fecha Sanción'),
						colspan: 2,
						reference: 'fechaSancionArrasRef',
	                	bind:		{
	                		//value: '{}',
	                		//readOnly: true
	                	}
	                },
	                {
			        	xtype: 		'textareafieldbase',
						fieldLabel: HreRem.i18n('Informe'),
						colspan: 3,
				 		//height: 	200,
				 		//maxWidth:   550,
				 		//rowspan:	5,
		            	//bind:		'{}',
						readOnly: true,
				 		labelAlign: 'top'
					}
				]	
           },
           {    
                xtype: 'fieldsettable',
				defaultType: 'displayfield',
				colspan: 3,
				title: HreRem.i18n('PBC Venta'),
				items: [
					{
	                	xtype: 'comboboxfieldbase',
						reference: 'aprobacionPBCArrasRef',
						colspan: 1,
	                	fieldLabel:  HreRem.i18n('Aprobación PBC Venta'),
			        	bind: {
		            		store: '{comboSiNoRem}'
		            		//value: '{}'
		            	}
					},
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('Fecha Sanción'),
						colspan: 2,
						reference: 'fechaSancionArrasRef',
	                	bind:		{
	                		//value: '{}',
	                		//readOnly: true
	                	}
	                },
	                {
			        	xtype: 		'textareafieldbase',
						fieldLabel: HreRem.i18n('Informe'),
						colspan: 3,
				 		//height: 	200,
				 		//maxWidth:   550,
				 		//rowspan:	5,
		            	//bind:		'{}',
						readOnly: true,
				 		labelAlign: 'top'
					}
				]	
           },
           {
				xtype: 'fieldsettable',
	           	title: HreRem.i18n('Intervinientes'),
	           	items : [
	               	{
						    xtype : 'gridBase',
						    topBar : false,
						    reference: 'listadoIntervinientesRef',
							cls	: 'panel-base shadow-panel',
							activateButton: true,
							bind: {
								//store: '{}'
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
							        xtype: 'actioncolumn',
							        reference: 'intervinientePrincipalRef',
							        width: 30,
							        text: HreRem.i18n('header.principal'),
									hideable: false,
									items: [
								        	{
									            getClass: function(v, meta, rec) {
									                /*if (rec.get('') != 1) {
									                	this.items[0].handler = 'onMarcarPrincipalClick';
									                    return 'fa fa-check';
									                } else {
							            				this.items[0].handler = 'onMarcarPrincipalClick';
									                    return 'fa fa-check green-color';
									                }*/
									            }
								        	}
									 ]
								}, 
							   {    text: HreRem.i18n('header.id.cliente'),
						        	//dataIndex: '',
						        	flex: 1,
						        	hidden: true,
						        	hideable: false
						       },
							   {
									text: HreRem.i18n('header.nombre.razon.social'),
									//dataIndex: '',
									flex: 1,
									renderer: coloredRender
							   },
							   {
							   		text: HreRem.i18n('header.numero.documento'),
						            //dataIndex: '',
						            flex: 1,
						            renderer: coloredRender
							   },						   
							   {
							   		text: HreRem.i18n('header.representante'),
						            //dataIndex: '',
						            flex: 1,
						            renderer: coloredRender
							   },
							   {    text: HreRem.i18n('header.numero.documento'),
						        	//dataIndex: '',
						        	flex: 1,
						        	renderer: coloredRender
						       },
							   {
									text:  HreRem.i18n('Porcentaje'),
									//dataIndex: '',
									flex: 1,
									renderer: coloredRender,
						            summaryType: 'sum',
						            summaryRenderer: function(value, summaryData, dataIndex) {
						            	var suma = this.up('grid').store.porcentajeCompra;
	
						            	suma = Ext.util.Format.number(suma, '0.00');
						            	
						            	var msg = msgPorcentajeTotal + " " + suma + "%";
						            	var style = "" 
						            	if(suma != Ext.util.Format.number(100.00,'0.00')) {
						            		msg = msgPorcentajeTotalError;		
						            		style = "style= 'color: red'" 
						            	}	
						            	
						            	return "<span "+style+ ">"+msg+"</span>"
						            	
						            }
							   },
							   {
							   		text: HreRem.i18n('fieldlabel.grado.propiedad'),
						            //dataIndex: '',
						            flex: 1,
						            renderer: coloredRender
							   },
							   {
							   		text: HreRem.i18n('header.telefono'),
						            //dataIndex: '',
						            flex: 1,
						            renderer: coloredRender
							   },						   
							   {
							   		text: HreRem.i18n('header.email'),
						            //dataIndex: '',
						            flex: 1,
						            renderer: coloredRender
							   },
							   {
							   		text: HreRem.i18n('fieldlabel.estado.pbc'),
						            //dataIndex: '',
						            flex: 1,
						            hidden: true,
						            renderer: coloredRender
							   },
							   {
							   		text: HreRem.i18n('fieldlabel.relacion.hre'),
						            //dataIndex: '',
						            flex: 1,
						            renderer: coloredRender
							   },
							   {
							   		text: HreRem.i18n('header.compradores.numero.factura'),
						            //dataIndex: '',
						            flex: 1,
						            renderer: coloredRender
							   },
							   {
							   		text: HreRem.i18n('header.compradores.fecha.factura'),
						            //dataIndex: '',
						            flex: 1,
						            formatter: 'date("d/m/Y")',
						            renderer: coloredRender
							   },
							   {
								   text: HreRem.i18n('header.numero.ursus'),
								   //dataIndex: '',
								   flex: 1,
						           renderer: coloredRender,
						           hidden: true,
						           hideable: false
							   },
							   {
								   xtype: 'actioncolumn',
								      width: 30,
								      flex: 1,
								      hideable: false,
								      text: HreRem.i18n('grid.documento.gdpr'),
								        items: [
								        	/*{
									           	iconCls: 'ico-download',
									           	tooltip: "Documento GDPR",
									            handler: function(grid, rowIndex) {
									            	var record = grid.getRecord(rowIndex);
										            var grid = me.down('gridBase');
										               
										             grid.fireEvent("download", grid, record);                
									            }
								        	}*/
								        ]
							   }, 
							   {
								   text: HreRem.i18n('header.problemas.ursus'),
								   //dataIndex: '',
								   flex: 1,
						           renderer: coloredRender,
						           hidden: true,
						           hideable: false
							   },
							   {
	
								   text: HreRem.i18n('header.fecha.acep.gpdr')
								   //dataIndex: ''
							   },
							   {
	
								   text: HreRem.i18n('header.estado.bc'),
								   //dataIndex: '',
								   flex: 1,
						           renderer: coloredRender
						          
							   }
							],
						    dockedItems : [
						        {
						            xtype: 'pagingtoolbar',
						            dock: 'bottom',
						            displayInfo: true,
						            bind: {
						                //store: '{}'
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
		me.lookupController().cargarTabData(me);
    	
    }
});