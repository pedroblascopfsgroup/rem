Ext.define('HreRem.view.agrupaciones.detalle.FichaAgrupacion', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'fichaagrupacion',    
    mixins: [
        'HreRem.ux.tab.TabBase'
    ],
    reference: 'fichaagrupacionref',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    scrollable: 'y',
    flex: 1,
    layout: 
    	{
			type : 'vbox',
			align : 'stretch'
		},

	recordName: "agrupacionficha",
	recordClass: "HreRem.model.AgrupacionFicha",
    requires: ['HreRem.model.AgrupacionFicha', 'HreRem.ux.tab.TabBase'],
    
    bind: {
    	ocultarBotonesEdicion: '{!agrupacionficha.esEditable}'
    },
    
    initComponent: function () {

        var me = this;
        
        me.setTitle(HreRem.i18n('title.ficha'));
        
        var items= [

			{    
                
				xtype:'fieldsettable',
				collapsible: false,
				defaultType: 'textfieldbase',
				 flex 		: 3,
				title: HreRem.i18n('title.datos.generales'),
				items :
					[
						{ 
							xtype: 'displayfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.numero.agrupacion'),
			            	bind: {
			            		value: '{agrupacionficha.numAgrupRem}'
			            	}		
		                },
		                {
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.tipo'),
							reference: 'tipoAgrupacionCombo',
							readOnly: true,
			            	bind: {
			            		store: '{comboTipoAgrupacion}',
			            	    value: '{agrupacionficha.tipoAgrupacionCodigo}'
			            	},
				            listeners: {
								change: 'onChangeTipoAgrupacion'
			            	}
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.municipio'),
							reference: 'municipioCombo',
			            	bind: {
			            		store: '{comboMunicipio}',
			            		value: '{agrupacionficha.municipioCodigo}',
			            		disabled: '{!agrupacionficha.provinciaCodigo}',
			            		readOnly: '{agrupacionficha.existeFechaBaja}'
			            	}

						},
		                { 
		                	xtype: 'displayfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.numero.agrupacion.uvem'),
			            	bind: {
			            		value: '{agrupacionficha.numAgrupUvem}'
			            	}		
		                },
		                { 
		                	fieldLabel:  HreRem.i18n('fieldlabel.descripcion'),
			            	bind: {
			            		value: '{agrupacionficha.descripcion}',
			            		readOnly: '{agrupacionficha.existeFechaBaja}'
			            	}
		                },
		                { 
							fieldLabel: HreRem.i18n('fieldlabel.direccion'),
							bind: {
								value: '{agrupacionficha.direccion}',
								readOnly: '{agrupacionficha.existeFechaBaja}'
							},
							allowBlank:	false
						},
		                { 
		                	xtype: 'datefieldbase',
		                	readOnly:	true,
		                	fieldLabel: HreRem.i18n('fieldlabel.fecha.alta'),
			            	bind: {
			            		value: '{agrupacionficha.fechaAlta}'
			            	}		
						},
						{ 
							xtype: 'displayfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
							bind: {
								value: '{agrupacionficha.cartera}',
								readOnly: '{agrupacionficha.existeFechaBaja}'
							}	
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.provincia'),
							reference: 'provinciaCombo',
							chainedStore: 'comboMunicipio',
							chainedReference: 'municipioCombo',
							allowBlank:	false,
			            	bind: {
			            		store: '{comboProvincia}',
			            	    value: '{agrupacionficha.provinciaCodigo}',
			            	    readOnly: '{agrupacionficha.existeFechaBaja}'
			            	},
    						listeners: {
								select: 'onChangeChainedCombo'
    						}
						},  
						{ 
		                	xtype:'datefieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.fecha.baja'),
			            	bind: {
			            		value: 	'{agrupacionficha.fechaBaja}',
			            		minValue: '{agrupacionficha.fechaAlta}',
			            		readOnly: '{agrupacionficha.existeFechaBaja}',
			            		disabled: '{esAgrupacionAsistida}'
			            	}
						},
						{ 
		                	fieldLabel:  HreRem.i18n('fieldlabel.nombre'),
			            	bind: {
			            		value: '{agrupacionficha.nombre}',
			            		readOnly: '{agrupacionficha.existeFechaBaja}'
			            	},
							allowBlank:	false
		                },
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
							bind: {
								value: '{agrupacionficha.codigoPostal}',
								readOnly: '{agrupacionficha.existeFechaBaja}'
							},
							allowBlank:	false,
							maskRe: /^\d*$/,
							vtype: 'codigoPostal'
							
						},
						{ 
		                	xtype: 'datefieldbase',
		                	fieldLabel: HreRem.i18n('header.fecha.inicio.vigencia'),
			            	bind: {
			            		value: '{agrupacionficha.fechaInicioVigencia}',
			            		readOnly: '{agrupacionficha.existeFechaBaja}',
			            		hidden: '{!esAgrupacionAsistida}',
			            		maxValue: '{agrupacionficha.fechaFinVigencia}'
			            	}		
						},
						{ 
		                	xtype: 'datefieldbase',
		                	fieldLabel: HreRem.i18n('header.fecha.fin.vigencia'),
		                	maxValue: null,
			            	bind: {
			            		value: '{agrupacionficha.fechaFinVigencia}',
			            		readOnly: '{agrupacionficha.existeFechaBaja}',
				        		hidden: '{!esAgrupacionAsistida}',
				        		minValue: '{agrupacionficha.fechaInicioVigencia}'
			            	}		
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