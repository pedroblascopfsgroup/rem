Ext.define('HreRem.view.activos.detalle.CalidadDatoPublicacionActivo', {
	extend : 'HreRem.view.common.FormBase',
	xtype : 'calidaddatopublicacionactivo',
	reference : 'calidaddatopublicacionactivoref',
	cls : 'panel-base shadow-panel',
	scrollable : 'y',
	refreshAfterSave : true,
	disableValidation : false,
	recordName : "calidaddatopublicacionactivo",
	recordClass : "HreRem.model.CalidadDatoPublicacionActivo",
	requires	:['HreRem.view.common.FieldSetTable', 'HreRem.model.CalidadDatoPublicacionActivo'],
	listeners : {
		boxready : 'cargarTabData'
	},
	initComponent : function() {
		var me = this;
		me.setTitle(HreRem.i18n('publicacion.calidad.datos.titulo'));

		me.items = [
		{
			xtype:'fieldsettable',
			layout:'hbox',
			collapsible: false,
			border: false,
			style:{
				backgroundColor: 'white'
			},
			items: [{
					xtype: 'tbfill'
				},
				{
					xtype: 'tbfill'
				},
				{
				xtype : 'button',
				cls : 'boton-cabecera',
				iconCls : 'ico-refrescar',
	        	iconAlign: 'right',
				//handler	: me.funcionRecargar,
				tooltip : HreRem.i18n('btn.refrescar')
			}]
		
		},
		{
			xtype:'toolfieldset',
			title : HreRem.i18n('publicacion.calidad.datos.fase0'),
			collapsible : true,
			collapsed : false,
			items : [{
				xtype : 'fieldsettable',
				title : HreRem.i18n('publicacion.calidad.datos.datos.registrales'),
				items : [{
						xtype : 'fieldsettable',
						collapsible : false,
						colspan: 3,
						title :HreRem.i18n('publicacion.calidad.datos.idufir'),
									items : [{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.rem'),
									reference : 'drIdufirFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.drIdufirFase1}'
									}
								},{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.mensaje.dq'),
									reference : 'dqIdufirFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.dqIdufirFase1}'
									}
								}/*,{
				
									cls: 'no-pointer',
									title: HreRem.i18n('publicacion.calidad.datos.correcto'),
									reference : 'correctoIdufirFase1',
									bind: {
										iconCls:'{getIconClsDQCorrecto}',
										value : '{calidaddatopublicacionactivo.correctoIdufirFase1}'
									
									}
									
								}*/]
						},{
							xtype : 'fieldsettable',
							collapsible : false,
							colspan: 3,
							title :HreRem.i18n('publicacion.calidad.datos.finca.registral'),
								items : [{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.rem'),
									reference : 'drFincaRegistralFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.drFincaRegistralFase1}'
									}
								},{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.dq'),
									reference : 'dqFincaRegistralFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.dqFincaRegistralFase1}'
									}
								}/*,{
				
									cls: 'no-pointer',
									title: HreRem.i18n('publicacion.calidad.datos.correcto'),
									bind: {
										iconCls:'{getIconClsDQCorrecto}',
										value : '{calidaddatopublicacionactivo.correctoFincaRegistralFase1}'
									}																								
								}*/]
						
						},{
						xtype : 'fieldsettable',
						collapsible : false,
						colspan: 3,
						title :HreRem.i18n('publicacion.calidad.datos.tomo'),
								items : [{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.rem'),
									reference : 'drTomoFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.drTomoFase1}'
									}
								},{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.dq'),
									reference : 'dqTomoFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.dqTomoFase1}'
									}
								}/*,{
				
									
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.correcto'),
									reference : 'correctoTomoFase1',
									bind: {
										iconCls:'{getIconClsDQCorrecto}',
										value : '{calidaddatopublicacionactivo.correctoTomoFase1}'
									}	
								*
									
								}*/]
						
						},{
							xtype : 'fieldsettable',
						 collapsible : false,
						 colspan: 3,
						title :HreRem.i18n('publicacion.calidad.datos.libro'),
								items : [{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.rem'),
									reference : 'drLibroFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.drLibroFase1}'
									}
								},{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.dq'),
									reference : 'dqLibroFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.dqLibroFase1}'
									}
								}/*,{
				
									
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.correcto'),
									reference : 'correctoLibroFase1',
									bind: {
										iconCls:'{getIconClsDQCorrecto}',
										value : '{calidaddatopublicacionactivo.correctoLibroFase1}'
									}	
								
									
								}*/]
						
						},{
							xtype : 'fieldsettable',
							collapsible : false,
							colspan: 3,
							title :HreRem.i18n('publicacion.calidad.datos.folio'),
								items : [{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.rem'),
									reference : 'drFolioFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.drFolioFase1}'
									}
								},{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.dq'),
									reference : 'dqFolioFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.dqFolioFase1}'
									}
								}/*,{
				
									xtype : 'numberfield',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.correcto'),
									reference : 'correctoFolioFase1'
								
									
								}*/]
						
						},{
							xtype : 'fieldsettable',
						 collapsible : false,
						 colspan: 3,
						title :HreRem.i18n('publicacion.calidad.datos.uso.dominante'),
								items : [{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.rem'),
									reference : 'drUsoDominanteFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.drUsoDominanteFase1}'
									}
								},{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.dq'),
									reference : 'dqUsoDominanteFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.dqUsoDominanteFase1}'
									}
								}/*,{
				
									xtype : 'numberfield',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.correcto'),
									reference : 'correctoUsoDominanteFase1'
								
									
								}*/]
						
						}
						,{
							xtype : 'fieldsettable',
						 collapsible : false,
						 colspan: 3,
						title :HreRem.i18n('publicacion.calidad.datos.datos.del.registro'),
								items : [{
									xtype : 'fieldsettable',
									collapsible : false,
									colspan: 3,
									title :HreRem.i18n('publicacion.calidad.datos.datos.del.registro.municipio'),
									items : [{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.rem'),
									reference : 'drMunicipioDelRegistroFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.drMunicipioDelRegistroFase1}'
									}
								},{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.dq'),
									reference : 'dqMunicipioDelRegistroFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.dqMunicipioDelRegistroFase1}'
									}
								}/*,{
				
									xtype : 'numberfield',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.correcto'),
									reference : 'correctoMunicipioDelRegistroFase1'
								
									
								}*/]
									
									
								},{
									xtype : 'fieldsettable',
									collapsible : false,
									colspan: 3,
									title :HreRem.i18n('publicacion.calidad.datos.datos.del.registro.provincia'),
									items : [{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.rem'),
									reference : 'drProvinciaDelRegistroFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.drProvinciaDelRegistroFase1}'
									}
								},{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.dq'),
									reference : 'dqProvinciaDelRegistroFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.dqProvinciaDelRegistroFase1}'
									}
								}/*,{
				
									xtype : 'numberfield',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.correcto'),
									reference : 'correctoProvinciaDelRegistroFase1'

								}*/]
									
									
								},{
									xtype : 'fieldsettable',
									collapsible : false,
									colspan: 3,
									title :HreRem.i18n('publicacion.calidad.datos.datos.del.registro.numero'),
									items : [{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.rem'),
									reference : 'drNumeroDelRegistroFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.drNumeroDelRegistroFase1}'
									}
								},{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.dq'),
									reference : 'dqNumeroDelRegistroFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.dqNumeroDelRegistroFase1}'
									}
								}/*,{
				
									xtype : 'numberfield',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.correcto'),
									reference : 'correctoNumeroDelRegistroFase1'
								
								}*/]

								}
								]
						
						}
						,{
							xtype : 'fieldsettable',
						 collapsible : false,
						 colspan: 3,
						title :HreRem.i18n('publicacion.calidad.datos.vpo'),				
							items : [{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.rem'),
									reference : 'drVpoFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.drVpoFase1}'
									}
								},{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.dq'),
									reference : 'dqVpoFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.dqVpoFase1}'
									}
								}/*,{
				
									xtype : 'numberfield',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.correcto'),
									reference : 'correctoVpoFase1'
								
									
								}*/]
						
						},{
							xtype : 'fieldsettable',
						 collapsible : false,
						 colspan: 3,
						title :HreRem.i18n('publicacion.calidad.datos.anyo.construccion'),
							items : [{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.rem'),
									reference : 'drAnyoConstruccionFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.drAnyoConstruccionFase1}'
									}
								},{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.dq'),
									reference : 'dqAnyoConstruccionFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.dqAnyoConstruccionFase1}'
									}
								}/*,{
				
									xtype : 'numberfield',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.correcto'),
									reference : 'correctoAnyoConstruccionFase1'
								
									
								}*/]
						
						},{
							xtype : 'fieldsettable',
						 collapsible : false,
						 colspan: 3,
						title :HreRem.i18n('publicacion.calidad.datos.tipologia'),
								items : [{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.rem'),
									reference : 'drTipologianFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.drTipologianFase1}'
									}
								},{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.dq'),
									reference : 'dqTipologianFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.dqTipologiaFase1}'
									}
								}/*,{
				
									xtype : 'numberfield',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.correcto'),
									reference : 'correctoTipologianFase1'
								
									
								}*/]
						
						},{
							xtype : 'fieldsettable',
						 collapsible : false,
						 colspan: 3,
						title :HreRem.i18n('publicacion.calidad.datos.subtipologia'),
							items : [{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.rem'),
									reference : 'drSubtipologianFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.drSubtipologianFase1}'
									}
								},{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.dq'),
									reference : 'dqSubtipologianFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.dqSubtipologiaFase1}'
									}
								}/*,{
				
									xtype : 'numberfield',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.correcto'),
									reference : 'correctoSubtipologianFase1'
								
									
								}*/]
						
						},{
							xtype : 'fieldsettable',
						 collapsible : false,
						 colspan: 3,
						title :HreRem.i18n('publicacion.calidad.datos.informacion.cargas'),
								items : [{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.rem'),
									reference : 'drInformacionCargasFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.drInformacionCargasFase1}'
									}
								},{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.dq'),
									reference : 'dqInformacionCargasFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.dqInformacionCargasFase1}'
									}
								},/*,{
				
									xtype : 'numberfield',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.correcto'),
									reference : 'correctoInformacionCargasFase1'
								
									
								},*/{
				
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.descripcion.cargas'),
									reference : 'descripcionCargasInformacionCargasFase1',
									
									bind : {
										value : '{calidaddatopublicacionactivo.descripcionCargasInformacionCargasFase1}'
									}
								
									
								}]
						
						},{
							xtype : 'fieldsettable',
						 collapsible : false,
						 colspan: 3,
						title :HreRem.i18n('publicacion.calidad.datos.inscripcion.correcta'),
								items : [{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.rem'),
									reference : 'drInscripcionCorrectaFase1',
										bind : {
										value : '{calidaddatopublicacionactivo.drInscripcionCorrectaFase1}'
									}
								},{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.dq'),
									reference : 'dqInscripcionCorrectaFase1',
										bind : {
										value : '{calidaddatopublicacionactivo.dqInscripcionCorrectaFase1}'
									}
								}/*,{
				
									xtype : 'numberfield',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.correcto'),
									reference : 'correctoInscripcionCorrectaFase1'
								
									
								}*/]
						
						},{
							xtype : 'fieldsettable',
						 collapsible : false,
						 colspan: 3,
						title :HreRem.i18n('publicacion.calidad.datos.porcien.propiedad'),
									items : [{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.rem'),
									reference : 'drPor100PropiedadFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.drPor100PropiedadFase1}'
									}
								},{
									xtype : 'textfieldbase',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.dato.dq'),
									reference : 'dqPor100PropiedadFase1',
									bind : {
										value : '{calidaddatopublicacionactivo.dqPor100PropiedadFase1}'
									}
								}/*,{
				
									xtype : 'numberfield',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.correcto'),
									reference : 'correctoPor100PropiedadFase1'
								
									
								}*/]
						
						}
						
						]
				
			}]
		}, 
		{
			xtype:'toolfieldset',
			title : HreRem.i18n('publicacion.calidad.datos.fase3'),
			collapsible : true,
			collapsed : false,
			layout: {
		        type: 'table',
		        columns: 2,
		        tdAttrs: {width: '33%'},
		        tableAttrs: {
		            style: {
		                width: '100%'
					}
		        }
			},
			tools: [
				{
					xtype: 'button',
					cls: 'btn-tbfieldset delete-focus-bg no-pointer',
					bind: {
						iconCls:'{getIconClsDQCorrecto}'
					}
				}
			],
			items : [{
				xtype:'fieldsettable',
				title: HreRem.i18n('header.activos.afectados.referencia.catastral'),
				collapsible: false,
				collapsed : false,
				
				items: [{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.rem'),
							bind: '{calidaddatopublicacionactivo.drF3ReferenciaCatastral}',
							readOnly: true
						},
						{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.dq'),
							bind: '{calidaddatopublicacionactivo.dqF3ReferenciaCatastral}',
							readOnly: true
						},{
						cls: 'btn-tbfieldset delete-focus-bg no-pointer',
						bind: {
							iconCls:'{getIconClsDQCorrecto}'
						}
					}]
			},
			{
				xtype:'fieldsettable',
				title: HreRem.i18n('fieldlabel.superficie.construida'),
				collapsible: false,
				collapsed : false,
				layout: {
			        type: 'table',
			        columns: 2
				},
				
				items: [{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.rem'),
							bind: '{calidaddatopublicacionactivo.drF3SuperficieConstruida}',
							readOnly: true
						},
						{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.dq'),
							bind: '{calidaddatopublicacionactivo.dqF3SuperficieConstruida}',
							readOnly: true
						},{
						cls: 'btn-tbfieldset delete-focus-bg no-pointer',
						bind: {
							iconCls:'{getIconClsDQCorrecto}'
						}
					}
				]
			},
			{
				xtype:'fieldsettable',
				title: HreRem.i18n('fieldlabel.superficie.util'),
				collapsible: false,
				collapsed : false,
				layout: {
			        type: 'table',
			        columns: 2
				},
				items: [{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.rem'),
							bind: '{calidaddatopublicacionactivo.drF3SuperficieUtil}',
							readOnly: true
						},
						{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.dq'),
							bind: '{calidaddatopublicacionactivo.dqF3SuperficieUtil}',
							readOnly: true
						},{
						cls: 'btn-tbfieldset delete-focus-bg no-pointer',
						bind: {
							iconCls:'{getIconClsDQCorrecto}'
						}
					}]
			},
			{
				xtype:'fieldsettable',
				title: HreRem.i18n('fieldlabel.anyo.construccion'),
				collapsible: false,
				collapsed : false,
				layout: {
			        type: 'table',
			        columns: 2
				},
				
				items: [{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.rem'),
							bind: '{calidaddatopublicacionactivo.drF3AnyoConstruccion}',
							readOnly: true
						},
						{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.dq'),
							bind: '{calidaddatopublicacionactivo.dqF3AnyoConstruccion}',
							readOnly: true
						},{
						cls: 'btn-tbfieldset delete-focus-bg no-pointer',
						bind: {
							iconCls:'{getIconClsDQCorrecto}'
						}
					}]
			},
			{
				xtype:'fieldsettable',
				title: HreRem.i18n('header.direccion'),
				collapsible: false,
				collapsed : false,
				colspan: 2,
				items: [{
					xtype:'fieldsettable',
					title: HreRem.i18n('fieldlabel.tipo.via'),
					collapsible: false,
					colspan: 3,
					layout: {
				        type: 'table',
				        columns: 2
				       
					},
					items: [{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.rem'),
							bind: '{calidaddatopublicacionactivo.drF3TipoVia}',
							readOnly: true
						},
						{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.dq'),
							bind: '{calidaddatopublicacionactivo.dqF3TipoVia}',
							readOnly: true
						},{
						cls: 'btn-tbfieldset delete-focus-bg no-pointer',
						bind: {
							iconCls:'{getIconClsDQCorrecto}'
						}
					}]
				},
				{
					xtype:'fieldsettable',
					title: HreRem.i18n('publicacion.calidad.datos.nombre.calle'),
					collapsible: false,
					colspan: 3,
					layout: {
				        type: 'table',
				        columns: 2
				        
					},
					
					items: [{
								xtype: 'textfieldbase',
								fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.rem'),
								bind: '{calidaddatopublicacionactivo.drF3NomCalle}',
								readOnly: true
							},
							{
								xtype: 'textfieldbase',
								fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.dq'),
								bind: '{calidaddatopublicacionactivo.dqF3NomCalle}',
								readOnly: true
							},{
								xtype: 'textfieldbase',
								fieldLabel:  HreRem.i18n('publicacion.calidad.datos.probabilidad.calle.correcta'),
								bind: '{calidaddatopublicacionactivo.probabilidadCalleCorrecta}',
								readOnly: true
							},{
						cls: 'btn-tbfieldset delete-focus-bg no-pointer',
						bind: {
							iconCls:'{getIconClsDQCorrecto}'
						}
					}
					]
				},
				{
					xtype:'fieldsettable',
					title: HreRem.i18n('publicacion.calidad.datos.cp'),
					collapsible: false,
					colspan: 3,
					layout: {
				        type: 'table',
				        columns: 2
					},
					
					items: [{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.rem'),
							bind: '{calidaddatopublicacionactivo.drF3CP}',
							readOnly: true
						},
						{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.dq'),
							bind: '{calidaddatopublicacionactivo.dqF3CP}',
							readOnly: true
						},{
						cls: 'btn-tbfieldset delete-focus-bg no-pointer',
						bind: {
							iconCls:'{getIconClsDQCorrecto}'
						}
					}]
				},
				{
					xtype:'fieldsettable',
					title: HreRem.i18n('fieldlabel.municipio'),
					collapsible: false,
					colspan: 3,
					layout: {
				        type: 'table',
				        columns: 2
				        
					},
					items: [{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.rem'),
							bind: '{calidaddatopublicacionactivo.drF3Municipio}',
							readOnly: true
						},
						{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.dq'),
							bind: '{calidaddatopublicacionactivo.dqF3Municipio}',
							readOnly: true
						},{
						cls: 'btn-tbfieldset delete-focus-bg no-pointer',
						bind: {
							iconCls:'{getIconClsDQCorrecto}'
						}
					}]
				},
				{
					xtype:'fieldsettable',
					title: HreRem.i18n('fieldlabel.provincia'),
					collapsible: false,
					colspan: 3,
					layout: {
				        type: 'table',
				        columns: 2
					},
					
					items: [{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.rem'),
							bind: '{calidaddatopublicacionactivo.drF3Provincia}',
							readOnly: true
						},
						{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.dq'),
							bind: '{calidaddatopublicacionactivo.dqF3Provincia}',
							readOnly: true
						},{
						cls: 'btn-tbfieldset delete-focus-bg no-pointer',
						bind: {
							iconCls:'{getIconClsDQCorrecto}'
						}
					}]
				}]
			}]
		}, 	
		{
			xtype:'toolfieldset',
			title : HreRem.i18n('publicacion.calidad.datos.fase4'),
			collapsible : true,
			collapsed : true,
			tools: [
				{
					xtype: 'button',
					cls: 'btn-tbfieldset delete-focus-bg no-pointer',
					bind: {
						iconCls:'{getIconClsDQCorrecto}'
					}
				}
			],
			items : [
				{
					// Apartado Fotos
					xtype:'fieldsettable',
					title:HreRem.i18n('publicacion.calidad.datos.fase4.fotos'),
					defaultType:'textfieldbase',
					items : [{
						xtype:'textfieldbase',
						fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.fotos.numero.imagenes'),
						reference: 'numFotosRef',
						readOnly: true,
						bind: {
							value: '{calidaddatopublicacionactivo.numFotos}'
						}

					},{
						xtype:'textfieldbase',
						fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.fotos.numero.imagenes.exterior'),
						reference: 'numFotosExteriorRef',
						readOnly: true,
						bind: {
							value: '{calidaddatopublicacionactivo.numFotosExterior}'
						}					
					},{
						xtype:'textfieldbase',
						fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.fotos.numero.imagenes.interior'),
						reference: 'numFotosInteriorRef',
						readOnly: true,
						bind: {
							value: '{calidaddatopublicacionactivo.numFotosInterior}'
						}
					},{
						xtype:'textfieldbase',
						fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.fotos.numero.imagenes.obra'),
						reference: 'numFotosObraRef',
						readOnly: true,
						bind: {
							value: '{calidaddatopublicacionactivo.numFotosObra}'
						}					
					},{
						xtype:'textfieldbase',
						fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.fotos.numero.imagenes.minima.resolucion'),
						reference: 'numFotosMinimaRef',
						readOnly: true,
						bind: {
							value: '{calidaddatopublicacionactivo.numFotosMinimaResolucion}'
						}
					}, {
						xtype:'textfieldbase',
						fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.fotos.numero.imagenes.minima.resolucion.y'),
						reference: 'numFotosMinimaYRef',
						readOnly: true,
						bind: {
							value: '{calidaddatopublicacionactivo.numFotosMinimaResolucionY}'
						}
					}, {
						xtype:'textfieldbase',
						fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.fotos.numero.imagenes.minima.resolucion.x'),
						reference: 'numFotosMinimaXRef',
						readOnly: true,
						bind: {
							value: '{calidaddatopublicacionactivo.numFotosMinimaResolucionX}'
						}
					},
					{
						xtype:'image',
						fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.fotos.correcto'),
						reference: 'correctoRef',
						readOnly: true
						/*bind: {
							value: '{calidaddatopublicacionactivo.correctoFotos}'
						}*/
					},{
						xtype:'textfieldbase',
						fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.fotos.mensaje.dq'),
						reference: 'fotosMensajeDQRef',
						readOnly: true,
						bind: {
							value: '{calidaddatopublicacionactivo.mensajeDQFotos}'
						}
					}]
				},{
				// Apartado Descripcion
				xtype:'fieldsettable',
				title:HreRem.i18n('publicacion.calidad.datos.fase4.descripcion'),
				defaultType:'textfieldbase',
				items : [{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.descripcion.dato.rem'),
					reference: 'datoRemRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.drFase4Descripcion}'
					}					
				},{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.descripcion.dato.rq'),
					reference: 'datoDQRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.dqFase4Descripcion}'
					}
				},{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.fotos.correcto'),
					reference: 'descripcionCorrectoRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.correctoDescripcion}'
					}					
				},{
					xtype:'button',
					text: HreRem.i18n('publicacion.calidad.datos.fase4.descripcion.boton.aplicar'),
					reference: 'btnAplicaDescripcionRef',
					readOnly: true
				}]
			},{
				// Apartado Localicacion
				xtype:'fieldsettable',
				title:HreRem.i18n('publicacion.calidad.datos.fase4.localizacion'),
				defaultType:'textfieldbase',
				items : [{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.localizacion.latitud.rem'),
					reference: 'latitudRemRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.drf4LocalizacionLatitud}'
					}
					

				},{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.localizacion.latitud.dq'),
					reference: 'latitudDQRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.dqF4Localizacionlatitud}'
					}					
				},{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.localizacion.longitud.rem'),
					reference: 'longitudRemRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.drf4LocalizacionLongitud}'
					}
				},{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.localizacion.longitud.dq'),
					reference: 'longitudDQRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.dqf4LocalizacionLongitud}'
					}					
				},{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.fotos.correcto'),
					reference: 'localizacionCorrectoRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.correctoLocalizacion}'
					}
				}, {
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.localizacion.geodistancia.dq'),
					reference: 'geodistanciaRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.geodistanciaDQ}'
					}
				}]
			}, {
				// Apartado CEE
				xtype:'fieldsettable',
				title:HreRem.i18n('publicacion.calidad.datos.fase4.CEE'),
				defaultType:'textfieldbase',
				items : [
					{
						xtype:'textfieldbase',
						fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.CEE.etiqueta'),
						reference: 'ceeRef',
						readOnly: true,
						bind: {
							value: '{calidaddatopublicacionactivo.etiquetaCEERem}'
						}
						

					},
					{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.CEE.numero.etiqueta.dq.a'),
					reference: 'numTipoARef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.numEtiquetaA}'
					}
					
				},{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.CEE.numero.etiqueta.dq.b'),
					reference: 'numTipoBRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.numEtiquetaB}'
					}					
				},{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.CEE.numero.etiqueta.dq.c'),
					reference: 'numTipoCRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.numEtiquetaC}'
					}
				},{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.CEE.numero.etiqueta.dq.d'),
					reference: 'numTipoDRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.numEtiquetaD}'
					}					
				},{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.CEE.numero.etiqueta.dq.e'),
					reference: 'numTipoERef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.numEtiquetaE}'
					}
				}, {
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.CEE.numero.etiqueta.dq.f'),
					reference: 'numTipoFRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.numEtiquetaF}'
					}
				}, {
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.CEE.numero.etiqueta.dq.g'),
					reference: 'numTipoGRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.numEtiquetaG}'
					}
				},
				{
					xtype:'image',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.fotos.correcto'),
					reference: 'etiquetaCorrectoRef',
					readOnly: true
					/*bind: {
						value: '{calidaddatopublicacionactivo.correctoCEE}'
					}*/
				},{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.CEE.numero.etiqueta.mensaje.dq'),
					reference: 'etiquetaMensajeDQRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.mensajeDQCEE}'
					}
				}]
			}]
		} 
		];

		me.callParent();

	},

	funcionRecargar : function() {
		var me = this;
		me.recargar = false;
		me.lookupController().cargarTabData(me);
	}
});