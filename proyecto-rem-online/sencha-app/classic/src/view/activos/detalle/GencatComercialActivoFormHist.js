Ext.define('HreRem.view.activos.detalle.GencatComercialActivoFormHist', {
	extend: 'HreRem.view.common.FormBase',
    xtype: 'gencatcomercialactivoformhist',
    
    cls: 'panel-base shadow-panel',
    refreshAfterSave: true,
    recordName: "gencatHistorico",
	recordClass: "HreRem.model.GencatHistorico",
    requires	: [
    	'HreRem.model.GencatHistorico',
    	'HreRem.view.activos.detalle.HistoricoOfertasAsociadasActivoList',
    	'HreRem.view.activos.detalle.DocumentosComunicacionHistoricoGencatList',
    	'HreRem.view.activos.detalle.HistoricoReclamacionesActivoList',
    	'HreRem.view.activos.detalle.HistoricoNotificacionesActivoList'
    ],
    
    listeners: { 
		boxready:'cargarTabData'   
    },
    
    data: {
        idHComunicacion: -1
    },

    /*url: $AC.getRemoteUrl("gencat/saveDatosComunicacion"),*/
        
    initComponent: function () {
        
        var me = this;
        
        var title;
        var ofertasasociadasactivolist;
        var reclamacionesactivolist;
        var documentoscomunicaciongencatlist;
        var notificacionactivolist;
        	
    	title = HreRem.i18n('title.comunicacion.historico');
    	me.recordClass = 'HreRem.model.GencatHistorico';
    	me.getModelInstance().getProxy().setExtraParam('idHComunicacion', me.idHComunicacion);
    	
    	ofertasasociadasactivolist = {	
			xtype: 'historicoofertasasociadasactivolist',
			reference: 'historicoofertasasociadasactivolistref',
			idHComunicacion: me.idHComunicacion,
			width: '100%'
		}
    	
    	reclamacionesactivolist = {	
			xtype: 'historicoreclamacionesactivolist',
			reference: 'historicoreclamacionesactivolistref',
			idHComunicacion: me.idHComunicacion,
			width: '100%'
		}
    	
    	documentoscomunicaciongencatlist = {	
			xtype: 'documentoscomunicacionhistoricogencatlist',
			reference: 'documentoscomunicacionhistoricogencatlistref',
			idHComunicacion: me.idHComunicacion,
			width: '100%'
		}
    	
    	notificacionactivolist = {	
			xtype: 'historiconotificacionesactivolist',
			reference: 'historiconotificacionesactivolistref',
			idHComunicacion: me.idHComunicacion,
			width: '100%'
		}
        	

        var items = [
        	{
				xtype:'fieldsettable',
				title: title,
				
				collapsible: true,
				layout		: {
			        type: 'vbox',
			        align: 'stretch'
			    },
			    
				items: [
					
					{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.datos.comunicacion'),
						defaults: {
							width: 410
					    },
						items:
							[
								{
				    				xtype: "datefieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.fecha.prebloqueo'),
				    				readOnly: true,
				    				name: 'fechaPreBloqueo',
				    				submitFormat:'Y-m-d',
									bind: {
										value: '{gencatHistorico.fechaPreBloqueo}'										
									}
				    			},
				    			{
				    				xtype: "datefieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.fecha.comunicacion'),
				    				readOnly: true,
				    				name: 'fechaComunicacion',
				    				submitFormat:'Y-m-d',
									bind: {
										value: '{gencatHistorico.fechaComunicacion}'
										
									}
				    			},
				    			{
				    				xtype: "datefield",
				    				fieldLabel: HreRem.i18n('fieldlabel.fecha.prevista.sancion'),
				    				readOnly: true,
				    				name: 'fechaPrevistaSancion',
			    				 	submitFormat:'Y-m-d',
									bind: {										
										value: '{gencatHistorico.fechaPrevistaSancion}'										
									}
				    			},
				    			{
				    				xtype: "datefieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.fecha.sancion'),
				    				reference: 'fechaSancionRef',
				    				name: 'fechaSancion',
				    				submitFormat:'Y-m-d',
									bind: {
										value: '{gencatHistorico.fechaSancion}',
										disabled: '{gencatHistorico.fechaComunicacionVacia}'
									}
				    			},
				    			{
				    				fieldLabel: HreRem.i18n('fieldlabel.sancion'),
				    				colspan: 2,
				    				name: 'sancion',
				    				reference: 'sancionRef',
									bind: {
										value: '{gencatHistorico.sancion}',
										disabled: '{gencatHistorico.fechaComunicacionVacia}'
									},
									listeners: {
										change : 'comprobarCampoNifNombre'
									}
				    			},
				    			{
									xtype:'fieldsettable',
									defaultType: 'textfieldbase',
									title: HreRem.i18n('title.comprador.nuevo'),
									reference: 'compradornuevoref',
									colspan: 3,
									width: '100%',
									defaults: {
										width: 410
								    },
									items: 
										[
											{
							    				fieldLabel: HreRem.i18n('fieldlabel.nif'),
							    				name: 'nuevoCompradorNif',
							    				reference: 'nuevoCompradorNifref',
												bind: {
													value: '{gencatHistorico.nuevoCompradorNif}'													
												},
												listener:{
													blur:'comprobarFormatoNIF'
												}
							    			},
							    			{
							    				fieldLabel: HreRem.i18n('fieldlabel.nombre'),
							    				name: 'nuevoCompradorNombre',
							    				reference: 'nuevoCompradorNombreref',
												bind: {
													value: '{gencatHistorico.nuevoCompradorNombre}'													
												}
							    			},
							    			{
							    				fieldLabel: HreRem.i18n('fieldlabel.primer.apellido'),
							    				name: 'nuevoCompradorApellido1',
												bind: {
													value: '{gencatHistorico.nuevoCompradorApellido1}'													
												}
							    			},
							    			{
							    				fieldLabel: HreRem.i18n('fieldlabel.segundo.apellido'),
							    				name: 'nuevoCompradorApellido2',
												bind: {
													value: '{gencatHistorico.nuevoCompradorApellido2}'												
												}
							    			}
										]
				    			},
				    			{
				    				fieldLabel: HreRem.i18n('fieldlabel.oferta.gencat'),
				    				readOnly: true,
									bind: {
										value: '{gencatHistorico.ofertaGencat}',
										visible: '{gencatHistorico.usuarioCompleto}'
									},
									listeners: {
								        click: {
								            element: 'el', 
								            fn: 'onClickAbrirExpedienteComercialHistorico'
								        }
								    },
								    style:{
								    	cursor: 'pointer',
								    	'text-decoration': 'underline'
								    }
								    
				    			},
				    			{
				    				xtype: "comboboxfieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.estado.comunicacion'),
				    				readOnly: true,
				    				dataIndex: 'estadoComunicacion', // No borrar, aunque no es necesario para el modelo se usa en el calculo del boton anyadir notifiacion
				    				name : 'estadoComunicacion',
									bind: {
										value: '{estadoComunicacion}'
									}
				    			},
				    			{
				    				xtype: "datefield",
				    				fieldLabel: HreRem.i18n('fieldlabel.fecha.anulacion'),
				    				colspan: 2,
				    				readOnly: true,
				    				name: 'fechaAnulacion',
				    				submitFormat:'Y-m-d',
									bind: {
										value: '{gencatHistorico.fechaAnulacion}'
									}
				    			},
				    			{
				    				xtype: "checkboxfieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.comunicado.anulacion.gencat'),
				    				name: 'comunicadoAnulacionAGencat',
				    				reference:'checkComunicadoAnulacion',
				    				id: 'checkComunicadoAnulacion',
				    				listeners: {
				    					change : 'onExisteDocumentoAnulacion'
				    				},
									bind: {
										readOnly: '{esSoloLecturaCheckAnularGencat}',
										value: '{gencatHistorico.comunicadoAnulacionAGencat}'
									}
				    			}
				    		]
		        	},
		        	{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.adecuacion'),
						defaults: {
							width: 410
					    },
						items:
							[ 
								{
				    				xtype: "comboboxfieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.necesita.reforma'),
				    				readOnly: true,
				    				name: 'necesitaReforma',
									bind: {
										store: '{comboSiNo}',
										value: '{gencatHistorico.necesitaReforma}'
									}
				    			},
				    			{
				    				xtype: "currencyfieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.importe.reforma'),
				    				name: 'importeReforma',
				    				readOnly: true,
									bind: {
										value: '{gencatHistorico.importeReforma}'										
									}
				    			},
				    			{
				    				xtype: "datefield",
				    				fieldLabel: HreRem.i18n('fieldlabel.fecha.revision'),
				    				readOnly: true,
				    				name: 'fechaRevision',
				    				submitFormat:'Y-m-d',
									bind: {
										value: '{gencatHistorico.fechaRevision}'										
									}
				    			}
							]
		        	},
		        	{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.ofertas.asociadas'),
						defaults: {
							width: 410
					    },
					    layout: 'fit',
						items:
							[
								ofertasasociadasactivolist
							]
		        	},
		        	{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.visita'),
						defaults: {
							width: 410
					    },
						items: [
							{
			    				fieldLabel: HreRem.i18n('fieldlabel.id.visita'),
			    				readOnly: true,
			    				name: 'idVisita',
			    				bind: {
									value: '{gencatHistorico.idVisita}'									
								},
								listeners: {
							        click: {
							            element: 'el', 
							            fn: 'onClickAbrirVisitaActivo'
							        }        
							    },
							    style:{
							    	cursor: 'pointer',
							    	'text-decoration': 'underline'
							    }
			    			},
			    			{
			    				xtype: "comboboxfieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.estado.visita'),
			    				readOnly: true,
			    				name: 'estadoVisita',
								bind: {
									store: '{comboEstadoVisita}',
									value: '{gencatHistorico.estadoVisita}'									
								}
			    			},
			    			{
			    				fieldLabel: HreRem.i18n('fieldlabel.api.realiza.visita'),
			    				readOnly: true,
			    				name: 'apiRealizaLaVisita',
								bind: {
									value: '{gencatHistorico.apiRealizaLaVisita}'									
								}
			    			},
			    			{
			    				xtype: "datefieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.fecha.realizacion.visita'),
			    				readOnly: true,
			    				name: 'fechaRealizacionVisita',
			    				submitFormat:'Y-m-d',
								bind: {
									value: '{gencatHistorico.fechaRealizacionVisita}'									
								}
			    			},
			    			{ 
								text: HreRem.i18n('button.solicitar.visita'),
								xtype: 'button',
								width: 200,
								handler: 'onClickSolicitarVisita',
								bind: {
									disabled: me.formDeHistorico || '{!gencat.usuarioValido}'
								}
							}
						]
		        	},
		        	{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.notificacion'),
						defaults: {
							width: 410
					    },
					    layout: 'fit',
						items: [
							notificacionactivolist
						]
		        	},
		        	{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.documentos'),
						defaults: {
							width: 410
					    },
					    layout: 'fit',
						items:
							[
								documentoscomunicaciongencatlist
							]
		        	},
		        	{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.reclamaciones'),
						defaults: {
							width: 410
					    },
					    layout: 'fit',
						items:
							[
								reclamacionesactivolist
							]
		        	}
					
				]
        	}
        ];
        
        me.addPlugin({ptype: 'lazyitems', items: items });
		    
        me.callParent(); 
        
    }

});
