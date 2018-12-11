Ext.define('HreRem.view.activos.detalle.GencatComercialActivoForm', {
	extend: 'HreRem.view.common.FormBase',
    xtype: 'gencatcomercialactivoform',
    
    refreshAfterSave: true,
    recordName: "gencat",
	recordClass: "HreRem.model.Gencat",
    requires	: [
    	'HreRem.model.Gencat',
    	'HreRem.model.GencatHistorico',
    	'HreRem.view.activos.detalle.OfertasAsociadasActivoList',
    	'HreRem.view.activos.detalle.HistoricoOfertasAsociadasActivoList',
    	'HreRem.view.activos.detalle.DocumentosActivoGencatList',
    	'HreRem.view.activos.detalle.ReclamacionesActivoList',
    	'HreRem.view.activos.detalle.HistoricoReclamacionesActivoList'
    ],
    
    listeners: { 
		boxready:'cargarTabData'
    },
    
    data: {
    	formDeHistorico: false,
        idHComunicacion: -1
    },
        
    initComponent: function () {
        
        var me = this;
        
        var title;
        var ofertasasociadasactivolist;
        var reclamacionesactivolist;
        if (me.formDeHistorico) {
        	
        	title = HreRem.i18n('title.comunicacion.historico');
        	me.recordClass = 'HreRem.model.GencatHistorico';
        	me.getModelInstance().getProxy().setExtraParam('idHComunicacion', me.idHComunicacion);
        	
        	ofertasasociadasactivolist = {	
				xtype: 'historicoofertasasociadasactivolist',
				reference: 'historicoofertasasociadasactivolistref',
				width: '100%',
				idHComunicacion: me.idHComunicacion
			}
        	
        	reclamacionesactivolist = {	
				xtype: 'historicoreclamacionesactivolist',
				reference: 'historicoreclamacionesactivolistref',
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
									bind: {
										value: '{gencat.fechaPreBloqueo}'
									}
				    			},
				    			{
				    				xtype: "datefieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.fecha.comunicacion'),
				    				readOnly: true,
									bind: {
										value: '{gencat.fechaComunicacion}'
									}
				    			},
				    			{
				    				xtype: "datefieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.fecha.prevista.sancion'),
									bind: {
										readOnly: me.formDeHistorico,
										value: '{gencat.fechaPrevistaSancion}'
									}
				    			},
				    			{
				    				xtype: "datefieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.fecha.sancion'),
				    				readOnly: true,
									bind: {
										value: '{gencat.fechaSancion}'
									}
				    			},
				    			{
				    				xtype: "comboboxfieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.sancion'),
				    				colspan: 2,
									bind: {
										readOnly: me.formDeHistorico,
										store: '{comboSancionGencat}',
										value: '{gencat.sancion}'
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
												bind: {
													readOnly: me.formDeHistorico,
													disabled: '{!gencat.estaActivadoCompradorNuevo}',
													value: '{gencat.nuevoCompradorNif}'
												}
							    			},
							    			{
							    				fieldLabel: HreRem.i18n('fieldlabel.nombre'),
												bind: {
													readOnly: me.formDeHistorico,
													disabled: '{!gencat.estaActivadoCompradorNuevo}',
													value: '{gencat.nuevoCompradorNombre}'
												}
							    			},
							    			{
							    				fieldLabel: HreRem.i18n('fieldlabel.primer.apellido'),
												bind: {
													readOnly: me.formDeHistorico,
													disabled: '{!gencat.estaActivadoCompradorNuevo}',
													value: '{gencat.nuevoCompradorApellido1}'
												}
							    			},
							    			{
							    				fieldLabel: HreRem.i18n('fieldlabel.segundo.apellido'),
												bind: {
													readOnly: me.formDeHistorico,
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
										value: '{gencat.ofertaGencat}'
									}
				    			},
				    			{
				    				xtype: "comboboxfieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.estado.comunicacion'),
				    				readOnly: true,
									bind: {
										store: '{comboEstadoComunicacionGencat}',
										value: '{gencat.estadoComunicacion}'
									}
				    			},
				    			{
				    				xtype: "datefieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.fecha.anulacion'),
				    				readOnly: true,
									bind: {
										value: '{gencat.fechaAnulacion}'
									}
				    			},
				    			{
				    				xtype: "checkboxfieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.comunicado.anulacion.gencat'),
									bind: {
										readOnly: me.formDeHistorico,
										value: '{gencat.comunicadoAnulacionAGencat}'
									}/*,
									listeners: {
										change: 'onChkbxPerimetroChange'
									}*/
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
									bind: {
										store: '{comboSiNo}',
										value: '{gencat.necesitaReforma}'
									}
				    			},
				    			{
				    				xtype: "currencyfieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.importe.reforma'),
				    				readOnly: true,
									bind: {
										value: '{gencat.importeReforma}'
									}
				    			},
				    			{
				    				xtype: "datefieldbase",
				    				fieldLabel: HreRem.i18n('fieldlabel.fecha.revision'),
				    				readOnly: true,
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
								bind: {
									value: '{gencat.idVisita}'
								}
			    			},
			    			{
			    				xtype: "comboboxfieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.estado.visita'),
			    				readOnly: true,
								bind: {
									store: '{comboEstadoVisita}',
									value: '{gencat.estadoVisita}'
								}
			    			},
			    			{
			    				fieldLabel: HreRem.i18n('fieldlabel.api.realiza.visita'),
			    				readOnly: true,
								bind: {
									value: '{gencat.apiRealizaLaVisita}'
								}
			    			},
			    			{
			    				xtype: "datefieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.fecha.realizacion.visita'),
			    				readOnly: true,
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
									disabled: me.formDeHistorico || '{!gencat.estaComunicado}'
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
						items: [
							{
			    				xtype: "checkboxfieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.check.notificacion'),
								bind: {
									readOnly: me.formDeHistorico || '{!gencat.estaComunicado}',
									value: '{gencat.checkNotificacion}'
								}/*,
								listeners: {
									change: 'onChkbxNotificacion'
								}*/
			    			},
			    			{
			    				xtype: "datefieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.fecha.notificacion'),
								bind: {
									readOnly: me.formDeHistorico,
									disabled: '{!gencat.checkNotificacion}',
									value: '{gencat.fechaNotificacion}'
								}
			    			},
			    			{
			    				xtype: "comboboxfieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.motivo'),
								bind: {
									readOnly: me.formDeHistorico,
									disabled: '{!gencat.checkNotificacion}',
									store: '{comboNotificacionGencat}',
									value: '{gencat.motivoNotificacion}'
								}
			    			},
			    			{
			    				fieldLabel: HreRem.i18n('fieldlabel.documento.notificacion'),
			    				readOnly: true,
								bind: {
									//value: '{gencat.documentoNotificion}'
								}
			    				/*será un buscador de documento donde el nuevo gestor de formalización-administración 
			    				 * tendrá OBLIGATORIAMENTE que subir, si no lo sube no se grabará la notificación*/
			    			},
			    			{
			    				xtype: "datefieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.fecha.sancion.notificacion'),
								bind: {
									readOnly: me.formDeHistorico,
									disabled: '{!gencat.checkNotificacion}',
									value: '{gencat.fechaSancionNotificacion}'
								}
			    			},
			    			{
			    				xtype: "datefieldbase",
			    				fieldLabel: HreRem.i18n('fieldlabel.cierre.notificacion'),
								bind: {
									readOnly: me.formDeHistorico,
									disabled: '{!gencat.checkNotificacion}',
									value: '{gencat.cierreNotificacion}'
								}
			    			}
						]
		        	},
		        	{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.documentos'),
						defaults: {
							width: 410
					    },
						items:
							[
								{	
				    				xtype: 'documentosactivogencatlist',
				    				reference: 'documentosactivogencatlistref',
				    				width: '100%'
				    			}
							]
		        	},
		        	{
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.reclamaciones'),
						defaults: {
							width: 410
					    },
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