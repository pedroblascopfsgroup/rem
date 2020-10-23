Ext.define('HreRem.view.activos.detalle.CalidadDatoPublicacionActivo', {
	extend : 'HreRem.view.common.FormBase',
	xtype : 'calidaddatopublicacionactivo',
	reference : 'calidaddatopublicacionactivoref',
	cls : 'panel-base shadow-panel',
	scrollable : 'y',
	refreshAfterSave : true,
	disableValidation : false,
	//records : ['calidaddatopublicacionactivo'],
	//recordsClass : ['HreRem.model.CalidadDatoPublicacionActivo'],
	//requires	:['HreRem.view.common.FieldSetTable'],
	/*listeners : {
		boxready : 'cargarTabData'
	},*/ 
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
			xtype:'fieldsettable',
			cls	 :  'fieldsetCabecera',
			title : HreRem.i18n('publicacion.calidad.datos.fase0'),
			collapsible : true,
			collapsed : false,
			/*items : [{
				xtype : 'textfieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.fases.de.publicacion.comentario'),
				reference : 'faseComentario',
				bind : {
					value : '{calidaddatopublicacionactivo.comentario}'
				}
			}]*/
		}, {
			xtype:'fieldsettable',
			cls	 :  'fieldsetCabecera',
			title : HreRem.i18n('publicacion.calidad.datos.fase3'),
			collapsible : true,
			collapsed : true,
			/*items : [{
				xtype : 'textareafieldbase',
				fieldLabel : HreRem
						.i18n('fieldlabel.fases.de.publicacion.comentario'),
				reference : 'faseComentario',
				bind : {
					value : '{calidaddatopublicacionactivo.comentario}'
				}
			}]*/
		}, {
			xtype:'fieldsettable',
			cls	 :  'fieldsetCabecera',
			title : HreRem.i18n('publicacion.calidad.datos.fase4'),
			collapsible : true,
			collapsed : true,
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