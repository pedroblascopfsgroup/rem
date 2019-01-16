Ext.define('HreRem.view.expedientes.DatosBasicosOferta', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'datosbasicosoferta',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'datosbasicosoferta',
    scrollable	: 'y',

	recordName: "datosbasicosoferta",
	
	recordClass: "HreRem.model.DatosBasicosOferta",
    
    requires: ['HreRem.model.DatosBasicosOferta','HreRem.view.activos.detalle.ActivoDetalleModel'],
    
    listeners: {
			boxready:'cargarTabData',
			beforeedit: 'numVisitaIsEditable'
	},
    
    initComponent: function () {

        var me = this;
        
        /*var storeNecesitaFinanciacion = Ext.create('Ext.data.Store', {
			data : [
				{"codigo":"1", "descripcion":eval(String.fromCharCode(34,83,237,34))},
		        {"codigo":"0", "descripcion":"No"}
			]
		});*/
        
		me.setTitle(HreRem.i18n('title.datos.basicos'));
        var items= [

			{   
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.detalle.oferta'),
				items :
					[
		                {
		                	fieldLabel:  HreRem.i18n('fieldlabel.num.oferta'),
		                	bind:		'{datosbasicosoferta.numOferta}'

		                },
		                {
		                	xtype: 'comboboxfieldbase',
		                	readOnly: true,
		                	bind: {
								store: '{comboTipoOferta}',
								value: '{datosbasicosoferta.tipoOfertaCodigo}'
							},
		                	fieldLabel:  HreRem.i18n('fieldlabel.tipo')
		                },
		                {
		                	xtype:'datefieldbase',
							formatter: 'date("d/m/Y")',
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.alta'),
		                	bind:		'{datosbasicosoferta.fechaAlta}'
		                },
		                {
		                	xtype: 'comboboxfieldbase',
		                	bind: {
								store: '{comboEstadoOferta}',
								value: '{datosbasicosoferta.estadoCodigo}'
							},
							readOnly: !$AU.userIsRol("HAYASUPER"),
		                	fieldLabel:  HreRem.i18n('fieldlabel.estado')
		                },
		                {	
		                	xtype: 'textfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.prescriptor'),
		                	bind: {
								value: '{datosbasicosoferta.prescriptor}'
							},
							readOnly: true
		                },
		                {
		                	xtype: 'textfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.canal.prescripcion'),
		                	bind: '{datosbasicosoferta.canalPrescripcionDescripcion}',
							readOnly: true
		                },
		                {
		                	xtype: 'currencyfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.importe.inicial.oferta'),
		                	bind:		'{datosbasicosoferta.importeOferta}'
		                },
		                {	
		                	xtype: 'currencyfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.importe.contraoferta'),
		                	bind:		{
		                		value: '{datosbasicosoferta.importeContraOferta}'
		                		//,readOnly: '{esCarteraSareb}'
		                	}
		                },
		                {	
		                	xtype: 'textfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.venta.cartera'),
		                	bind:		{
		                		value: '{datosbasicosoferta.ventaCartera}'
		                		,readOnly: 'true',
		                		hidden: '{esTipoAlquiler}'
		                	}		                	
		                },
		                {	
		                	xtype: 'comboboxfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.tipo.alquiler'),
		                	bind: {
		                		store: '{comboTipoAlquiler}',
		                		value: '{datosbasicosoferta.tipoAlquilerCodigo}',
		                		hidden: '{!esTipoAlquiler}'
		                	}		                	
		                },
		                {	
		                	xtype: 'comboboxfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.tipo.inquilino'),
		                	bind: {
		                		store: '{comboTiposInquilino}',
		                		value: '{datosbasicosoferta.tipoInquilinoCodigo}',
		                		hidden: '{!esTipoAlquiler}'
		                	}		                	
		                },
		                {	
		                	xtype: 'textfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.num.contrato.prinex'),
		                	bind: {
		                		value: '{datosbasicosoferta.numContratoPrinex}',
		                		hidden: '{!esTipoAlquiler}'
		                	}		                	
		                },
		                {	
		                	xtype: 'textfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.ref.circuito.cliente'),
		                	colspan: 3,
		                	bind: {
		                		value: '{datosbasicosoferta.refCircuitoCliente}',
		                		hidden: '{!esTipoAlquiler}'
		                	}		                	
		                },
		                {
		                	xtype: 'fieldset',
		                	title:  HreRem.i18n('title.comite.sancionador'),
		                	colspan: 2,
		                	margin: '0 10 10 0',
		                	height: 90,
		                	layout: 'vbox',
		                	items: [
						                {
						                	xtype: 'comboboxfieldbase',
						                	fieldLabel:  HreRem.i18n('fieldlabel.comite.seleccionado'),
						                	reference: 'comboComiteSeleccionado',
						                	readOnly: false,
						                	bind: {
												store: '{comboComites}',
												value: '{datosbasicosoferta.comiteSancionadorCodigo}',
												readOnly: '{comiteSancionadorNoEditable}',
												hidden: '{esOfertaAlquiler}'
												
											},
											// TODO Sobreescribimos la función porque está dando problemas la carga del store. A veces llega null.
											setStore: function(store) {
												if(!Ext.isEmpty(store)) {
													this.bindStore(store);
												}
											}
						                },
						                {
						                	xtype: 'comboboxfieldbase',
						                	fieldLabel:  HreRem.i18n('fieldlabel.comite.alquiler'),
						                	reference: 'comboComiteSeleccionadoAlquiler',
						                	readOnly: false,
						                	bind: {
												store: '{comboComitesAlquiler}',
												value: '{datosbasicosoferta.comiteSancionadorCodigoAlquiler}',
												readOnly: '{comiteSancionadorNoEditable}',
												hidden: '{!esOfertaAlquiler}'
												
											},
											// TODO Sobreescribimos la función porque está dando problemas la carga del store. A veces llega null.
											setStore: function(store) {
												if(!Ext.isEmpty(store)) {
													this.bindStore(store);
												}
											}
						                },
						                {
						                	xtype: 'container',
						                	bind: { 
						                		hidden: '{!esCarteraBankia}'
						                	},
						                	layout: 'hbox',
						                	items: [
						                	    
								                {
								                	xtype: 'comboboxfieldbase',
								                	fieldLabel:  HreRem.i18n('fieldlabel.comite.propuesto'),
								                	reference: 'comboComitePropuesto',
								                	readOnly: true,								                	
								                	bind: {
														store: '{comboComitesPropuestos}',
														value: '{datosbasicosoferta.comitePropuestoCodigo}',
														disabled: '{!esCarteraBankia}'
													},
													// TODO Sobreescribimos la función porque está dando problemas la carga del store. A veces llega null.
													setStore: function(store) {
														if(!Ext.isEmpty(store)) {
															this.bindStore(store);
														}
													}
								                },
								                {
							                		xtype: 'button',
							                		text: HreRem.i18n('btn.consultar.comite'),
							                		handler: 'consultarComiteSancionador',
							                		margin: '0 40 0 0',
							                		disabled: true,
							                		bind: {
							                			disabled: '{!editing}'
							                		}
					                			}
						                	]
						                	
						                }

		                	]
		                		
		                	
		                },
		                {
		                	xtype: 'fieldset',
		                	margin: '0 10 10 0',
		                	height: 90,
		                	title:  HreRem.i18n('title.visita'),
		                	layout: 'vbox',
		                	items: [
										{ 
											xtype: 'comboboxfieldbase',
											reference: 'comboEstadosVisita',
								        	fieldLabel:  HreRem.i18n('fieldlabel.estado'),
								        	bind: {
							            		store: '{comboEstadosVisitaOferta}',
							            		value: '{datosbasicosoferta.estadoVisitaOfertaCodigo}'
							            	},
					                		listeners: {change: 'numVisitaIsEditable'}
								        },	
		                				{
		                					xtype: 'container',
		                					layout: 'hbox',
			                				items: [
							                	{
							                		xtype: 'button',
							                		text: HreRem.i18n('fieldlabel.asignar.visita'),
							                		margin: '0 10 0 0',
							                		hidden: true
							                		
							                	},
							                	{
							                		xtype: 'numberfieldbase',
							                		fieldLabel:  HreRem.i18n('fieldlabel.numero.visita'),
							                		reference: 'numVistaFromOfertaRef',
							                		bind: {
							                			value : '{datosbasicosoferta.numVisita}'
							                		}
							                		
							                	}
							                ]
			                			}
		                	]
		                		
		                	
		                },
		    			{
		                    xtype: 'fieldsettable',
		                    title: HreRem.i18n('title.comerical.oferta'),
		                    /*bind: {
		                        hidden: '{!esCarteraCajamar}'
		                    },*/
		                    colspan: 3,
		                    items: [
		                    		{
										xtype: "textfield",
										fieldLabel: HreRem.i18n('fieldlabel.comerical.oferta.detalle.cajamar.ofertaExpress'),
										bind: {
											value: '{datosbasicosoferta.ofertaExpress}',
												hidden: '{esTipoAlquiler}'
										},
					    				readOnly: true,
					    				width: 410
					    			},
					    			{
										xtype: "textareafieldbase",
										fieldLabel: HreRem.i18n('fieldlabel.comerical.oferta.detalle.cajamar.observaciones'),
										bind: {
											value: '{datosbasicosoferta.observaciones}'
										},
										height: 30,
					    				width: 410,
					    				colspan: 2
					    			},
					    			{
					    				xtype: 'comboboxfieldbase',
					                	bind: {
								            store: '{comboSiNo}',
								            value: '{datosbasicosoferta.necesitaFinanciacion}'
										},
										fieldLabel: HreRem.i18n('fieldlabel.comerical.oferta.detalle.cajamar.necesitaFinanciacion')
					    			}
					    			
					    			
		                    ]
                		},
                		{
                			xtype: "container",
                			layout: "hbox",
                			items: [
                				{
        		                	xtype: 'button',
        		                	reference: 'btnSendPropuesta',
        		        		   // bind: {hidden: '{!datosbasicosoferta.permiteProponer}'},
        		                	rowspan: 2,
        		                	text: HreRem.i18n('btn.propuesta.oferta'),
        		                	handler: 'onClickGeneraOfertarHojaExcel'
        		                },
        		                {
        		                	xtype: 'button',
        		                	reference: 'btnSendAprobacion',
        		        		    bind: {
        		        		    	hidden: '{!esTipoAlquiler}',
        		        		    	disabled: '{!esOfertaTramitada}'
        		        		    },
        		                	text: HreRem.i18n('btn.enviar.mail.aprobacion'),
        		                	handler: 'onClickEnviarMailAprobacion'
        		                }
                			]
                		}
		        ]
			},
			{
				
            	xtype: 'fieldset',
            	title:  HreRem.i18n('title.textos'),
            	items : [
                	{
					    xtype		: 'gridBaseEditableRow',
					    idPrincipal : 'expediente.id',
					    topBar: false,
					    reference: 'listadoTextosOferta',
						cls	: 'panel-base shadow-panel',
						secFunToEdit: 'EDITAR_GRID_TEXTOS_OFERTA_EXPEDIENTE',
						bind: {
							store: '{storeTextosOferta}'
						},									
						
						columns: [
						   {    text: HreRem.i18n('header.campo'),
					        	dataIndex: 'campoDescripcion',
					        	flex: 1
					       },
						   {
					            text: HreRem.i18n('header.texto'),
					            dataIndex: 'texto',
					            flex: 4,
					            editor: {
			       					xtype:'textarea'
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
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});		
		
    }
});