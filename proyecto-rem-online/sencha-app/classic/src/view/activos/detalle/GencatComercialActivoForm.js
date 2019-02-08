Ext.define('HreRem.view.activos.detalle.GencatComercialActivoForm', {
	extend: 'HreRem.view.common.FormBase',
    xtype: 'gencatcomercialactivoform',
    
    cls: 'panel-base shadow-panel',
    refreshAfterSave: true,
    recordName: "gencat",
	recordClass: "HreRem.model.Gencat",
    requires	: [
    	'HreRem.model.Gencat',
    	'HreRem.model.GencatHistorico',
    	'HreRem.model.NotificacionGencat',
    	'HreRem.view.activos.detalle.OfertasAsociadasActivoList',
    	'HreRem.view.activos.detalle.HistoricoOfertasAsociadasActivoList',
    	'HreRem.view.activos.detalle.DocumentosComunicacionGencatList',
    	'HreRem.view.activos.detalle.DocumentosComunicacionHistoricoGencatList',
    	'HreRem.view.activos.detalle.ReclamacionesActivoList',
    	'HreRem.view.activos.detalle.HistoricoReclamacionesActivoList',
    	'HreRem.view.activos.detalle.NotificacionesActivoList',
    	'HreRem.view.activos.detalle.HistoricoNotificacionesActivoList'
    ],
    
    listeners: { 
		boxready:'cargarTabData'
    },
    
    data: {
    	formDeHistorico: false,
        idHComunicacion: -1
    },
    
    //url: $AC.getRemoteUrl("gencat/URL_GENCAT_GUARDAR_FORM"),
    url: $AC.getRemoteUrl("gencat/saveDatosComunicacion"),
        
    initComponent: function () {
        
        var me = this;
        
        var title;
        var ofertasasociadasactivolist;
        var reclamacionesactivolist;
        var documentoscomunicaciongencatlist;
        var notificacionactivolist;
        if (me.formDeHistorico) {
        	
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
        	
        }
        else {
        	
        	title = HreRem.i18n('title.comunicacion.actual');
        	
        	ofertasasociadasactivolist = {	
				xtype: 'ofertasasociadasactivolist',
				reference: 'ofertasasociadasactivolistref',
				width: '100%'
        	}
        	
        	reclamacionesactivolist = {	
				xtype: 'reclamacionesactivolist',
				reference: 'reclamacionesactivolistref',
				width: '100%'
    		}
        	
        	documentoscomunicaciongencatlist = {	
				xtype: 'documentoscomunicaciongencatlist',
				reference: 'documentoscomunicaciongencatlistref',
				width: '100%'
    		}
        	
        	notificacionactivolist = {	
				xtype: 'notificacionesactivolist',
				reference: 'notificacionesactivolistref',
				width: '100%'
    		}
        	
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
										value: '{gencat.fechaPreBloqueo}'										
									}
				    			},
				    			{
				    				xtype: "datefield",
				    				fieldLabel: HreRem.i18n('fieldlabel.fecha.comunicacion'),
				    				readOnly: true,
				    				name: 'fechaComunicacion',
				    				submitFormat:'Y-m-d',
									bind: {
										value: '{gencat.fechaComunicacion}'
										
									}
				    			},
				    			{
				    				xtype: "datefield",
				    				fieldLabel: HreRem.i18n('fieldlabel.fecha.prevista.sancion'),
				    				readOnly: true,
				    				name: 'fechaPrevistaSancion',
			    				 	submitFormat:'Y-m-d',
									bind: {										
										value: '{gencat.fechaPrevistaSancion}'										
									}
				    			},
				    			{
				    				xtype: "datefieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.fecha.sancion'),
				    				name: 'fechaSancion',
				    				submitFormat:'Y-m-d',
									bind: {
										readOnly: '{!gencat.IsUserAllowed}',
										value: '{gencat.fechaSancion}',
										disabled: '{gencat.fechaComunicacionVacia}'
									}
				    			},
				    			{
				    				xtype: "comboboxfieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.sancion'),
				    				colspan: 2,
				    				name: 'sancion',
									bind: {
										readOnly: '{!gencat.IsUserAllowed}',
										store: '{comboSancionGencat}',
										value: '{gencat.sancion}',
										disabled: '{gencat.fechaComunicacionVacia}'
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
												bind: {
													readOnly: '{!gencat.IsUserAllowed}',
													disabled: '{!gencat.estaActivadoCompradorNuevo}',
													value: '{gencat.nuevoCompradorNif}'													
												}
							    			},
							    			{
							    				fieldLabel: HreRem.i18n('fieldlabel.nombre'),
							    				name: 'nuevoCompradorNombre',
												bind: {
													readOnly: '{!gencat.IsUserAllowed}',
													disabled: '{!gencat.estaActivadoCompradorNuevo}',
													value: '{gencat.nuevoCompradorNombre}'													
												}
							    			},
							    			{
							    				fieldLabel: HreRem.i18n('fieldlabel.primer.apellido'),
							    				name: 'nuevoCompradorApellido1',
												bind: {
													readOnly: '{!gencat.IsUserAllowed}',
													disabled: '{!gencat.estaActivadoCompradorNuevo}',
													value: '{gencat.nuevoCompradorApellido1}'													
												}
							    			},
							    			{
							    				fieldLabel: HreRem.i18n('fieldlabel.segundo.apellido'),
							    				name: 'nuevoCompradorApellido2',
												bind: {
													readOnly: '{!gencat.IsUserAllowed}',
													disabled: '{!gencat.estaActivadoCompradorNuevo}',
													value: '{gencat.nuevoCompradorApellido2}'												
												}
							    			}
										]
				    			},
				    			{
				    				fieldLabel: HreRem.i18n('fieldlabel.oferta.gencat'),
				    				readOnly: true,
									bind: {
										value: '{gencat.ofertaGencat}',
										visible: '{gencat.usuarioCompleto}'
										
									},
									listeners: {
								        click: {
								            element: 'el', 
								            fn: 'onClickAbrirExpedienteComercial'
								        }
								    },
								    style:{
								    	cursor: 'pointer',
								    	'text-decoration': 'underline'
								    },
								    
				    			},
				    			{
				    				xtype: "comboboxfieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.estado.comunicacion'),
				    				readOnly: true,
				    				dataIndex: 'estadoComunicacion', // No borrar, aunque no es necesario para el modelo se usa en el calculo del boton anyadir notifiacion
				    				name : 'estadoComunicacion',
									bind: {
										store: '{comboEstadoComunicacionGencat}',
										value: '{estadoComunicacionField}'
									}
				    			},
				    			{
				    				xtype: "datefieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.fecha.anulacion'),
				    				colspan: 2,
				    				readOnly: true,
				    				name: 'fechaAnulacion',
				    				submitFormat:'Y-m-d',
									bind: {
										value: '{gencat.fechaAnulacion}'
									}
				    			},
				    			{
				    				xtype: "checkboxfieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.comunicado.anulacion.gencat'),
				    				name: 'comunicadoAnulacionAGencat',
									bind: {
										readOnly: '{esSoloLecturaCheckAnularGencat}',
										value: '{gencat.comunicadoAnulacionAGencat}'
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
										value: '{gencat.necesitaReforma}'
									}
				    			},
				    			{
				    				xtype: "currencyfieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.importe.reforma'),
				    				name: 'importeReforma',
				    				readOnly: true,
									bind: {
										value: '{gencat.importeReforma}'										
									}
				    			},
				    			{
				    				xtype: "datefield",
				    				fieldLabel: HreRem.i18n('fieldlabel.fecha.revision'),
				    				readOnly: true,
				    				name: 'fechaRevision',
				    				submitFormat:'Y-m-d',
									bind: {
										value: '{gencat.fechaRevision}'										
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
									value: '{gencat.idVisita}'									
								}
			    			},
			    			{
			    				xtype: "comboboxfieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.estado.visita'),
			    				readOnly: true,
			    				name: 'estadoVisita',
								bind: {
									store: '{comboEstadoVisita}',
									value: '{gencat.estadoVisita}'									
								}
			    			},
			    			{
			    				fieldLabel: HreRem.i18n('fieldlabel.api.realiza.visita'),
			    				readOnly: true,
			    				name: 'apiRealizaLaVisita',
								bind: {
									value: '{gencat.apiRealizaLaVisita}'									
								}
			    			},
			    			{
			    				xtype: "datefieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.fecha.realizacion.visita'),
			    				readOnly: true,
			    				name: 'fechaRealizacionVisita',
			    				submitFormat:'Y-m-d',
								bind: {
									value: '{gencat.fechaRealizacionVisita}'									
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
