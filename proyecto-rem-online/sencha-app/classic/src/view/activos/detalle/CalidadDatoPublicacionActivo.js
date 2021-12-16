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
	requires	:['HreRem.view.common.FieldSetTable', 'HreRem.model.CalidadDatoPublicacionActivo','HreRem.view.activos.detalle.CalidadDatoFasesGrid'],
	listeners : {
		boxready : 'cargarTabDataCalidadDato'
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
				handler	: me.funcionRecargar,
				tooltip : HreRem.i18n('btn.refrescar')
			}]
		
		},
		{
			xtype:'toolfieldset',
			title : HreRem.i18n('publicacion.calidad.datos.fase0'),
			collapsible : true,
			reference: 'toolFieldFase0',
			collapsed : '{colapsarDesplegable}',
			tools: [
				{
					xtype: 'button',
								cls: 'no-pointer',
								style: 'background: transparent; border: none;',
								reference : 'correctoIdufirFase1',
								bind: {
										iconCls:'{getCorrectoDatosRegistralesFase0a2}'	
							}
					}
			],
			items:
				[
					{
						xtype : 'fieldsettable',
						title : HreRem.i18n('publicacion.calidad.datos.datos.registrales'),
						items : 
							[
								{
									xtype:'calidaddatofases',
									reference: 'fasedatosregistrales',
									idActivo:this.lookupController().getViewModel().get('activo').get('id'),
									codigoGrid: CONST.GRID_CALIDAD_DATO['DATOSREGISTRALES']
								}
							]
					},
					{
						xtype : 'fieldsettable',
						title :HreRem.i18n('publicacion.calidad.datos.datos.del.registro'),
						items : 
							[
								{
									xtype:'calidaddatofases',
									reference: 'fasedatosregistro',
									idActivo:this.lookupController().getViewModel().get('activo').get('id'),
									codigoGrid: CONST.GRID_CALIDAD_DATO['DATOSREGISTRO']
								}
							]
					}
				]
		},
		{
			xtype:'toolfieldset',
			title : HreRem.i18n('publicacion.calidad.datos.fase3'),
			reference: 'toolFieldFase1',
			collapsible : true,
			collapsed : '{colapsarDesplegable}',
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
					cls: 'no-pointer',
					style: 'background: transparent; border: none;',
					bind: {
						iconCls:'{getIconClsDQBloqueFase3}'
					}
				}
			],
			items : 
				[
					{
						xtype:'calidaddatofases',
						colspan: 3,
						reference: 'fasetrescalidaddato',
						idActivo:this.lookupController().getViewModel().get('activo').get('id'),
						codigoGrid: CONST.GRID_CALIDAD_DATO['DATFASE03']
					},
					{
						xtype:'fieldsettable',
						title: HreRem.i18n('header.direccion'),
						//collapsible: false,
						//collapsed : false,						
						items: [
							{
								xtype:'calidaddatofases',
								reference: 'fasecalidaddatodireccion',
								idActivo:this.lookupController().getViewModel().get('activo').get('id'),
								codigoGrid: CONST.GRID_CALIDAD_DATO['DATFASE03DIRECCION']
							}
								]
					}
				]
		},
		
		//
		/*{
			xtype:'toolfieldset',
			title : HreRem.i18n('publicacion.calidad.datos.fase0'),
			collapsible : true,
			reference: 'toolFieldFase0',
			collapsed : '{colapsarDesplegable}',
			tools: [
				{
					xtype: 'button',
								cls: 'no-pointer',
								style: 'background: transparent; border: none;',
								reference : 'correctoIdufirFase1',
								bind: {
										iconCls:'{getCorrectoDatosRegistralesFase0a2}'	
							}
					}
			],
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
								},{
								xtype: 'button',
									cls: 'no-pointer',
									style: 'background: transparent; border: none;',
									reference : 'correctoIdufirFase1',
									bind: {
										iconCls:'{getIconClsIdufirCorrecto}'									
									}									
								}]
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
								},{
									xtype: 'button',
									cls: 'no-pointer',
									style: 'background: transparent; border: none;',
									reference : 'correctoIdufirFase1',
									bind: {
										iconCls:'{getIconClsFincaRegistralCorrecto}'									
									}									
								}]
						
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
								},{
									xtype: 'button',
									cls: 'no-pointer',
									style: 'background: transparent; border: none;',
									reference : 'correctoIdufirFase1',
									bind: {
										iconCls:'{getIconClsTomoCorrecto}'									
									}									
								}]
						
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
								},{
									xtype: 'button',
									cls: 'no-pointer',
									style: 'background: transparent; border: none;',
									reference : 'correctoIdufirFase1',
									bind: {
										iconCls:'{getIconClsLibroCorrecto}'									
									}									
								}]
						
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
								},{
									xtype: 'button',
									cls: 'no-pointer',
									style: 'background: transparent; border: none;',
									reference : 'correctoIdufirFase1',
									bind: {
										iconCls:'{getIconClsFolioCorrecto}'									
									}									
								}]
						
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
								},{
									xtype: 'button',
									cls: 'no-pointer',
									style: 'background: transparent; border: none;',
									reference : 'correctoIdufirFase1',
									bind: {
										iconCls:'{getIconClsUsoDominanteCorrecto}'									
									}									
								}]
						
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
								},{
									xtype: 'button',
									cls: 'no-pointer',
									style: 'background: transparent; border: none;',
									reference : 'correctoIdufirFase1',
									bind: {
										iconCls:'{getIconClsMunicipioDelRegistroCorrecto}'									
									}									
								}]
									
									
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
								},{
									xtype: 'button',
									cls: 'no-pointer',
									style: 'background: transparent; border: none;',
									reference : 'correctoIdufirFase1',
									bind: {
										iconCls:'{getIconClsProvinciaDelRegistroCorrecto}'									
									}									
								}]
									
									
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
								},{
									xtype: 'button',
									cls: 'no-pointer',
									style: 'background: transparent; border: none;',
									reference : 'correctoIdufirFase1',
									bind: {
										iconCls:'{getIconClsProvinciaNumeroDelRegistroCorrecto}'									
									}									
								}]

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
								},{
									xtype: 'button',
									cls: 'no-pointer',
									style: 'background: transparent; border: none;',
									reference : 'correctoIdufirFase1',
									bind: {
										iconCls:'{getIconClsVPOCorrecto}'									
									}									
								}]
						
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
								},{
									xtype: 'button',
									cls: 'no-pointer',
									style: 'background: transparent; border: none;',
									reference : 'correctoIdufirFase1',
									bind: {
										iconCls:'{getIconClsAnyoConstruccionCorrecto}'									
									}									
								}]
						
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
								},{
									xtype: 'button',
									cls: 'no-pointer',
									style: 'background: transparent; border: none;',
									reference : 'correctoIdufirFase1',
									bind: {
										iconCls:'{getIconClsTipologiaCorrecto}'									
									}									
								}]
						
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
								},{
									xtype: 'button',
									cls: 'no-pointer',
									style: 'background: transparent; border: none;',
									reference : 'correctoIdufirFase1',
									bind: {
										iconCls:'{getIconClsSubtipologiaCorrecto}'									
									}									
								}]
						
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
								},{
				
									xtype: 'button',
									cls: 'no-pointer',
									style: 'background: transparent; border: none;',
									reference : 'correctoIdufirFase1',
									bind: {
										iconCls:'{getIconClsInformacionCargasCorrecto}'									
									}
								
									
								},{
				
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
								},{
									xtype: 'button',
									cls: 'no-pointer',
									style: 'background: transparent; border: none;',
									reference : 'correctoInscripcionCorrectaFase1',
									bind: {
										iconCls:'{getIconClsInscripcionCorrecto}'									
									}									
								}]
						
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
								},{
									xtype: 'button',
									cls: 'no-pointer',
									style: 'background: transparent; border: none;',
									reference : 'correctoPor100PropiedadFase1',
									bind: {
										iconCls:'{getIconClsPorCienCorrecto}'									
									}									
								}]
						
						}
						
						]
				
			}]
		}, 
		{
			xtype:'toolfieldset',
			title : HreRem.i18n('publicacion.calidad.datos.fase3'),
			reference: 'toolFieldFase1',
			collapsible : true,
			collapsed : '{colapsarDesplegable}',
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
					cls: 'no-pointer',
					style: 'background: transparent; border: none;',
					bind: {
						iconCls:'{getIconClsDQBloqueFase3}'
					}
				}
			],
			items : [{
				xtype:'fieldsettable',
				title: HreRem.i18n('header.activos.afectados.referencia.catastral'),
				collapsible: false,
				collapsed : false,
				layout: {
			        type: 'table',
			        columns: 2
				},
				
				items: [{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.rem'),
							reference: 'drRefCatastral',
							bind: '{calidaddatopublicacionactivo.drF3ReferenciaCatastral}',
							readOnly: true
							
						},
						{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('publicacion.calidad.datos.dato.dq'),
							reference: 'dqRefCatastral',
							bind: '{calidaddatopublicacionactivo.dqF3ReferenciaCatastral}',
							readOnly: true
						},{
						xtype: 'button',
						cls: 'no-pointer',
						style: 'background: transparent; border: none;',
						bind: {
							iconCls:'{getIconClsDQRefCatastral}'
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
						xtype: 'button',
						cls: 'no-pointer',
						style: 'background: transparent; border: none;',
						bind: {
							iconCls:'{getIconClsDQSupConstruida}'
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
						xtype: 'button',
						cls: 'no-pointer',
						style: 'background: transparent; border: none;',
						bind: {
							iconCls:'{getIconClsDQSuperficieUtil}'
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
						xtype: 'button',
						cls: 'no-pointer',
						style: 'background: transparent; border: none;',
						bind: {
							iconCls:'{getIconClsDQAnyoConstruccion}'
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
						xtype: 'button',
						cls: 'no-pointer',
						style: 'background: transparent; border: none;',
						bind: {
							iconCls:'{getIconClsDQTipoVia}'
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
								xtype: 'button',
								cls: 'no-pointer',
								style: 'background: transparent; border: none;',
								bind: {
									iconCls:'{getIconClsDQNomCalle}'
								}
							},{
								xtype: 'textfieldbase',
								fieldLabel:  HreRem.i18n('publicacion.calidad.datos.probabilidad.calle.correcta'),
								bind: '{calidaddatopublicacionactivo.probabilidadCalleCorrecta}',
								readOnly: true
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
						xtype: 'button',
						cls: 'no-pointer',
						style: 'background: transparent; border: none;',
						bind: {
							iconCls:'{getIconClsDQCP}'
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
						xtype: 'button',
						cls: 'no-pointer',
						style: 'background: transparent; border: none;',
						bind: {
							iconCls:'{getIconClsDQMunicipio}'
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
						xtype: 'button',
						cls: 'no-pointer',
						style: 'background: transparent; border: none;',
						bind: {
							iconCls:'{getIconClsDQProvincia}'
						}
					}]
				}]
			}]
		}, */	
		{
			xtype:'toolfieldset',
			reference: 'toolFieldFase2',
			title : HreRem.i18n('publicacion.calidad.datos.fase4'),
			collapsible : true,
			collapsed : '{colapsarDesplegable}',		
			tools: [
				{
					xtype: 'button',
					cls: 'no-pointer',
					style: 'background: transparent; border: none;',
					bind: {
						iconCls:'{getIconClsDQBloqueFase4}'
					}
				}
			],
			items : [
				{
					// Apartado Fotos
					xtype:'fieldsettable',
					title:HreRem.i18n('publicacion.calidad.datos.fase4.fotos'),
					defaultType:'textfieldbase',
					items : [
						{
						xtype: 'button',
						colspan:3,
						cls: 'no-pointer',
						style: 'background: transparent; border: none;',
						bind: {
							iconCls:'{getIconClsDQFotos}'
							}
						},
						{
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
					},{
						xtype:'textfieldbase',
						fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.fotos.numero.imagenes.minima.resolucion.x'),
						reference: 'numFotosMinimaXRef',
						readOnly: true,
						bind: {
							value: '{calidaddatopublicacionactivo.numFotosMinimaResolucionX}'
						}
					},{
						xtype:'textfieldbase',
						fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.fotos.numero.imagenes.minima.resolucion.y'),
						reference: 'numFotosMinimaYRef',
						readOnly: true,
						bind: {
							value: '{calidaddatopublicacionactivo.numFotosMinimaResolucionY}'
						}
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
				items : [	
					{
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.indicador.correcto'),
					colspan:1,
					width: 50,
					xtype: 'button',						
					cls: 'no-pointer',
					style: 'background: transparent; border: none',
					bind: {
						iconCls:'{getIconClsDQescripcion}'
						}
					},
					{
					xtype:'button',
					text: HreRem.i18n('publicacion.calidad.datos.fase4.descripcion.aplicar'),
					reference: 'btnAplicaDescripcionRef',
					style: 'float: left;',
					readOnly: true,
					handler: 'aplicarDescripcion',	
					colspan:2,
					bind:{
						disabled: '{disableBtnDescF1}'
						}
					},
					{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.descripcion.dato.rem'),
					reference: 'datoRemRef',
          		  	maxWidth:  '100%',
          		  	style: 'text-align: justify;',
					colspan:3,
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.drFase4Descripcion}'
					}					
				},{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.descripcion.dato.rq'),
					reference: 'datoDQRef',
					style: 'text-align: justify;',
					colspan:3,
					maxWidth:  '100%',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.dqFase4Descripcion}'
					}
				}]
			},{
				// Apartado Localicacion
				xtype:'fieldsettable',
				title:HreRem.i18n('publicacion.calidad.datos.fase4.localizacion'),
				defaultType:'textfieldbase',
				items : [
				{
					xtype: 'button',
					cls: 'no-pointer',
					colspan:3,
					style: 'background: transparent; border: none;',
					bind: {
						iconCls:'{getIconClsDQLocalizacion}'
					}
				},{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.localizacion.latitud.rem'),
					reference: 'latitudRemRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.drf4LocalizacionLatitud}'
					}
				},{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.localizacion.longitud.rem'),
					reference: 'longitudRemRef',
					colspan:2,
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.drf4LocalizacionLongitud}'
					}
				},
				{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.localizacion.latitud.dq'),
					reference: 'latitudDQRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.dqF4Localizacionlatitud}'
					}					
				},	
				{
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.localizacion.longitud.dq'),
					reference: 'longitudDQRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.dqf4LocalizacionLongitud}'
					}					
				}, {
					xtype:'textfieldbase',
					fieldLabel: HreRem.i18n('publicacion.calidad.datos.fase4.localizacion.geodistancia.dq'),
					reference: 'geodistanciaRef',
					readOnly: true,
					bind: {
						value: '{calidaddatopublicacionactivo.geodistanciaDQ} km'
					}
				}]
			}, {
				// Apartado CEE
				xtype:'fieldsettable',
				title:HreRem.i18n('publicacion.calidad.datos.fase4.CEE'),
				defaultType:'textfieldbase',
				items : [
					{
						xtype: 'button',
						cls: 'no-pointer',
						colspan:3,
						style: 'background: transparent; border: none;',
						bind: {
							iconCls:'{getIconClsDQCEE}'
							}
					},
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
		},
		{
			xtype:'toolfieldset',
			title : HreRem.i18n('publicacion.referencia.catastral.datos.catastrales'),
			collapsible : false,
			reference: 'toolFieldDatosCatastrales',
			items:
				[
					{
						xtype : 'fieldsettable',
						title : HreRem.i18n('publicacion.referencia.catastral.referencias.catastrales.activo'),
						items : 
							[
								{
									xtype:'referenciacatastralgrid',
									reference: 'referenciacatastralgridref',
									idActivo:this.lookupController().getViewModel().get('activo').get('id')
								}
							]
					}, {
	                	xtype: 'combobox',
	                	fieldLabel: HreRem.i18n('publicacion.referencia.catastral.referencia.catastral'),
	                	name: 'referenciaCatastralActivo',
	                	reference: 'referenciaCatastralActivoRef',
	                	width: '400px',
	                	bind: {	
	                		store: '{comboReferenciaCatastral}',
							value: '{calidaddatopublicacionactivo.codigo}'
	                	},
						displayField: 'descripcion',
    					valueField: 'codigo',
	                	listeners: {
	                		change: function(combo){
	                			var me = this;
								var refCatastral = combo.getValue();
								var grid = me.lookupController().lookupReference('comparativareferenciacatastralgridref');
								var idActivo = me.lookupController().getViewModel().getData().activo.id;
								grid.setDisabled(false);
								grid.getStore().getProxy().setExtraParams({'refCatastral':refCatastral, 'idActivo':idActivo});    
								grid.getStore().load();
								
	                		}
	                	}
	                },
					{
						xtype : 'fieldsettable',
						title : HreRem.i18n('publicacion.referencia.catastral.datos.comparativa.catastro'),
						items : 
							[
								{
									xtype:'comparativareferenciacatastralgrid',
									reference: 'comparativareferenciacatastralgridref',
									idActivo:this.lookupController().getViewModel().get('activo').get('id'),
									disabled: true
								}
							]
					}
				]
		} 
		];
		me.callParent();

	},

	 funcionRecargar : function() {
		var me = this;
		me.recargar = false;		 
		if(me.xtype == "button") {
			me.lookupController().cargarTabDataCalidadDato(me.up().up());
			me.lookupController().cargarTabDataCalidadDatoGrid();
		} else {
			me.lookupController().cargarTabDataCalidadDato(me);
			me.lookupController().cargarTabDataCalidadDatoGrid();
		}
	}
});