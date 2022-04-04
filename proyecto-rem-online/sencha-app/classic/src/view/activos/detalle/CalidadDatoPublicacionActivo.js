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
	                		select: function(combo){
	                			var me = this;
								var refCatastral = combo.getValue();
								var grid = me.lookupController().lookupReference('comparativareferenciacatastralgridref');
								var idActivo = me.lookupController().getViewModel().getData().activo.id;
								grid.setDisabled(false);
								grid.getStore().getProxy().setExtraParams({'refCatastral':refCatastral, 'idActivo':idActivo});    
								grid.store.load();
								
	                		},
	                		render: function(combo){
	                			var me = this;
								var refCatastral = combo.getValue();
								var grid = me.lookupController().lookupReference('comparativareferenciacatastralgridref');
								var idActivo = me.lookupController().getViewModel().getData().activo.id;
								var refCatastral = me.lookupController().getViewModel().getData().activo.refCatastral;
								if(!Ext.isEmpty(refCatastral)){
									combo.setValue(refCatastral);
									grid.setDisabled(false);
								}
								
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
									refCatastral:this.lookupController().getViewModel().get('activo').get('refCatastral')
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