Ext.define('HreRem.view.expedientes.PbcExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'pbcexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    refreshAfterSave: true,
    saveMultiple: false,
    reference: 'pbcexpedienteref',
    scrollable	: 'y',
    recordName: "ofertacaixapbc",
	recordClass: "HreRem.model.OfertaCaixaPbc",
	requires: ['HreRem.model.OfertaCaixaPbc'],
    listeners: {
    	boxready: 'cargarTabData'
    },
    initComponent: function () {
    	
    	var me = this;
		me.setTitle(HreRem.i18n('header.title.pbc'));
		
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
				title: HreRem.i18n('title.datos.operacion'),
				items: [
					{
						xtype: 'displayfieldbase',
						fieldLabel: HreRem.i18n('title.nivel.riesgo'),
						colspan: 1,
						bind:'{ofertacaixapbc.riesgoOperacion}'
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('title.operacion.sospechosa'),
						colspan: 1,
						bind: {
			            		store: '{comboSiNoBoolean}',
			            		value: '{ofertacaixapbc.ofertaSospechosa}'
			            }
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('title.deteccion.indicio'),
						colspan: 1,
						bind: {
			            	store: '{comboSiNoBoolean}',
			            	value: '{ofertacaixapbc.deteccionIndicio}'
			            }
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('title.cliente.intenta.ocultar.identidad'),
						colspan: 1,
						bind: {
							store: '{comboSiNoBoolean}',
			            	value: '{ofertacaixapbc.ocultaIdentidadTitular}'
			            }
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('title.cliente.muestra.actitud.incoherente'),
						colspan: 1,
						bind: {
							store: '{comboSiNoBoolean}',
				            value: '{ofertacaixapbc.actitudIncoherente}'
				        }
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('title.sociedad.mantiene.titulos.portador'),
						colspan: 1,
						bind: {
							store: '{comboSiNoBoolean}',
				            value: '{ofertacaixapbc.titulosPortador}'
				           }
					},
					{
			        	xtype: 		'textareafieldbase',
						fieldLabel: HreRem.i18n('title.motivo.compra'),
						colspan: 3,
				 		//height: 	200,
				 		//maxWidth:   550,
				 		//rowspan:	5,
		            	bind:'{ofertacaixapbc.motivoCompra}',
						readOnly: true,
				 		labelAlign: 'top'
					},
					{
			        	xtype: 		'textareafieldbase',
						fieldLabel: HreRem.i18n('title.finalidad.operacion'),
						colspan: 3,
				 		//height: 	200,
				 		//maxWidth:   550,
				 		//rowspan:	5,
		            	bind:'{ofertacaixapbc.finalidadOperacion}',
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
						fieldLabel: HreRem.i18n('Origen fondos propios'),
						colspan: 1,
						bind:'{ofertacaixapbc.fondosPropios}'
					},
					{
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('title.origen.fondos.propios'),
						colspan: 1,
						reference: 'fechaProcedenciaFondosPropiosRef',
	                	bind:		{
	                		value:'{ofertacaixapbc.procedenciaFondosPropios}',
	                		readOnly: true
	                	}
	                },
					{
						xtype: 'displayfieldbase',
						fieldLabel: HreRem.i18n('title.otra.procedencia.fondos.propios'),
						colspan: 1,
						bind:'{ofertacaixapbc.otraProcedenciaFondosPropios}'
					},
					{
						xtype: 'displayfieldbase',
						fieldLabel: HreRem.i18n('title.medio.pago.operacion.venta'),
						colspan: 1,
						bind:'{ofertacaixapbc.medioPago}'
					},
					{
	                	xtype:'comboboxfieldbase',
						fieldLabel: HreRem.i18n('title.propone.pago.a.traves.intermediario'),
						colspan: 1,
						reference: 'fechaPagoIntermediarioRef',
						bind: {
							store: '{comboSiNoBoolean}',
							value: '{ofertacaixapbc.pagoIntermediario}'
						}
	                },
					{
						xtype: 'displayfieldbase',
						fieldLabel: HreRem.i18n('title.pais.transferencia'),
						colspan: 1,
						bind:'{ofertacaixapbc.paisTransferencia}'
					},
					{
						xtype: 'displayfieldbase',
						fieldLabel: HreRem.i18n('title.origen.fondos.financiacion.bancaria'),
						colspan: 1,
						bind:'{ofertacaixapbc.fondosBanco}'
					}
				]	
        	},
        	{    
                xtype: 'fieldsettable',
				defaultType: 'displayfield',
				colspan: 3,
				title: HreRem.i18n('title.hitos.arras'),
				items: [
					{
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('title.fecha.solicitud.calculo.riesgo'),
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
						fieldLabel: HreRem.i18n('title.fecha.comunicacion.riesgo'),
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
						fieldLabel: HreRem.i18n('title.fecha.encio.documentacion.bc'),
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
						fieldLabel: HreRem.i18n('title.fecha.sancion.bc'),
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
				title: HreRem.i18n('title.hitos.venta'),
				items: [
					{
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('title.fecha.solicitud.calculo.riesgo'),
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
						fieldLabel: HreRem.i18n('title.fecha.comunicacion.riesgo'),
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
						fieldLabel: HreRem.i18n('title.fecha.encio.documentacion.bc'),
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
						fieldLabel: HreRem.i18n('title.fecha.sancion.bc'),
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
				title: HreRem.i18n('title.pbc.cumplimiento.normativo'),
				items: [
					{
	                	xtype: 'comboboxfieldbase',
						reference: 'aprobacionPBCArrasRef',
						colspan: 1,
	                	fieldLabel:  HreRem.i18n('title.aprobacion.pbc.cn'),
			        	bind: {
		            		store: '{comboSiNoRem}'
		            		//value: '{}'
		            	}
					},
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('title.fecha.sancion'),
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
				title: HreRem.i18n('title.pbc.arras'),
				items: [
					{
	                	xtype: 'comboboxfieldbase',
						reference: 'aprobacionPBCArrasRef',
						colspan: 1,
	                	fieldLabel:  HreRem.i18n('title.aprobacion.pbc.arras'),
			        	bind: {
		            		store: '{comboSiNoRem}'
		            		//value: '{}'
		            	}
					},
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('title.fecha.sancion'),
						colspan: 2,
						reference: 'fechaSancionArrasRef',
	                	bind:		{
	                		//value: '{}',
	                		//readOnly: true
	                	}
	                },
	                {
			        	xtype: 		'textareafieldbase',
						fieldLabel: HreRem.i18n('title.informe'),
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
				title: HreRem.i18n('title.pbc.venta'),
				items: [
					{
	                	xtype: 'comboboxfieldbase',
						reference: 'aprobacionPBCArrasRef',
						colspan: 1,
	                	fieldLabel:  HreRem.i18n('title.aprobacion.pbc.venta'),
			        	bind: {
		            		store: '{comboSiNoRem}'
		            		//value: '{}'
		            	}
					},
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('title.fecha.sancion'),
						colspan: 2,
						reference: 'fechaSancionArrasRef',
	                	bind:		{
	                		//value: '{}',
	                		//readOnly: true
	                	}
	                },
	                {
			        	xtype: 		'textareafieldbase',
						fieldLabel: HreRem.i18n('title.informe'),
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
									text: HreRem.i18n('fieldlabel.apellidos.cliente'),
									//dataIndex: '',
									flex: 1,
									renderer: coloredRender
							   },
							   {
							   		text: HreRem.i18n('header.tipo.documento'),
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
							   		text: HreRem.i18n('header.rol.oferta'),
						            //dataIndex: '',
						            flex: 1,
						            renderer: coloredRender
							   },
							   
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