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
			defaultType: 'container',
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
				//handler	: 'onClickBotonRefrescar',
				tooltip : HreRem.i18n('btn.refrescar')
			}]
		
		},
		{
			
			cls: 'no-pointer',
			title: HreRem.i18n('publicacion.calidad.datos.correcto'),
			style:{
				backgroundColor: 'white'
			},
			bind: {
				iconCls:'{getIconClsDQCorrecto}'
			}
		},
		{
			xtype:'fieldsettable',
			cls	 :  'fieldsetCabecera',
			title : HreRem.i18n('publicacion.calidad.datos.fase0'),
			collapsible : true,
			collapsed : false,
			items : [{
				xtype : 'fieldsettable',
				title : HreRem.i18n('publicacion.calidad.datos.datos.registrales'),
				items : [{
						xtype : 'fieldsettable',
						 collapsible : false,
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
						title :HreRem.i18n('publicacion.calidad.datos.datos.del.registro'),
								items : [{
									xtype : 'fieldsettable',
									collapsible : false,
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
						
						},{
							
						}
							
						
						,{
							xtype : 'fieldsettable',
						 collapsible : false,
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
										value : '{calidaddatopublicacionactivo.dqTipologianFase1}'
									}
								}/*,{
				
									xtype : 'numberfield',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.correcto'),
									reference : 'correctoTipologianFase1'
								
									
								}*/]
						
						},{
							xtype : 'fieldsettable',
						 collapsible : false,
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
										value : '{calidaddatopublicacionactivo.dqSubtipologianFase1}'
									}
								}/*,{
				
									xtype : 'numberfield',
									fieldLabel :HreRem.i18n('publicacion.calidad.datos.correcto'),
									reference : 'correctoSubtipologianFase1'
								
									
								}*/]
						
						},{
							xtype : 'fieldsettable',
						 collapsible : false,
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
			cls: 'no-pointer',
			title: HreRem.i18n('publicacion.calidad.datos.correcto'),
			style:{
				backgroundColor: 'white'
			},
			bind: {
				iconCls:'{getIconClsDQCorrecto}'
			}
		},
		{
			xtype:'fieldsettable',
			cls	 :  'fieldsetCabecera',
			title : HreRem.i18n('publicacion.calidad.datos.fase3'),
			collapsible : true,
			collapsed : true//,
			/*items : [{
				xtype : 'textareafieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.fases.de.publicacion.comentario'),
				reference : 'faseComentario',
				bind : {
					value : '{calidaddatopublicacionactivo.comentario}'
				}
			}]*/
		}, 
		{
			cls: 'no-pointer',
			title: HreRem.i18n('publicacion.calidad.datos.correcto'),
			style:{
				backgroundColor: 'white'
			},
			bind: {
				iconCls:'{getIconClsDQCorrecto}'
			}
		},	
		{
			xtype:'fieldsettable',
			cls	 :  'fieldsetCabecera',
			title : HreRem.i18n('publicacion.calidad.datos.fase4'),
			collapsible : true,
			collapsed : true//,
			/*items : [{
				xtype : 'textareafieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.fases.de.publicacion.comentario'),
				reference : 'faseComentario',
				bind : {
					value : '{calidaddatopublicacionactivo.comentario}'
				}
			}]*/
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