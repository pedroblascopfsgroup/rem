Ext.define('HreRem.view.agrupaciones.detalle.FichaAgrupacion', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'fichaagrupacion',    
    mixins		: ['HreRem.ux.tab.TabBase'],
    reference	: 'fichaagrupacionref',
    cls			: 'panel-base shadow-panel',
    collapsed	: false,
    scrollable	: 'y',
    flex		: 1,
    layout		: {
    	type	: 'vbox',
    	align	: 'stretch'
	},
	recordName	: "agrupacionficha",
	recordClass	: "HreRem.model.AgrupacionFicha",
    requires	: ['HreRem.model.AgrupacionFicha', 'HreRem.ux.tab.TabBase', 'HreRem.model.Activo'],
    bind		: {
    	ocultarBotonesEdicion: '{!agrupacionficha.esEditable}'
    },

    initComponent: function () {

        var me = this;

        me.setTitle(HreRem.i18n('title.ficha'));

        var items= [
			{
				xtype		:'fieldsettable',
				collapsible	: true,
				defaultType	: 'textfieldbase',
				title		: HreRem.i18n('title.datos.generales'),
				items 		: [
						{ 
							xtype		: 'displayfieldbase',
							fieldLabel	:  HreRem.i18n('fieldlabel.numero.agrupacion'),
			            	bind		: {
			            		value: '{agrupacionficha.numAgrupRem}'
			            	}		
		                },
		                {
							xtype		: 'comboboxfieldbase',
							fieldLabel	: HreRem.i18n('fieldlabel.tipo'),
							reference	: 'tipoAgrupacionCombo',
							readOnly	: true,
			            	bind		: {
			            		store: '{comboTipoAgrupacion}',
			            	    value: '{agrupacionficha.tipoAgrupacionCodigo}'
			            	},
				            listeners	: {
								change: 'onChangeTipoAgrupacion'
			            	}
						},
						{
							xtype		: 'comboboxfieldbase',
							fieldLabel	: HreRem.i18n('fieldlabel.municipio'),
							reference	: 'municipioCombo',
			            	bind		: {
			            		store: '{comboMunicipio}',
			            		value: '{agrupacionficha.municipioCodigo}',
			            		disabled: '{!agrupacionficha.provinciaCodigo}',
			            		readOnly: '{agrupacionficha.existeFechaBaja}'
			            	}

						},
		                { 
		                	xtype		: 'displayfieldbase',
		                	fieldLabel	:  HreRem.i18n('fieldlabel.numero.agrupacion.uvem'),
		                	bind		: {
			            		value: '{agrupacionficha.numAgrupUvem}'
			            	}		
		                },
		                { 
		                	fieldLabel	:  HreRem.i18n('fieldlabel.descripcion'),
			            	bind		: {
			            		value: '{agrupacionficha.descripcion}',
			            		readOnly: '{agrupacionficha.existeFechaBaja}'
			            	}
		                },
		                { 
							fieldLabel	: HreRem.i18n('fieldlabel.direccion'),
							bind		: {
								value: '{agrupacionficha.direccion}',
								readOnly: '{agrupacionficha.existeFechaBaja}'
							},
							allowBlank	:	'{esAgrupacionLoteComercial}'
						},
		                { 
		                	xtype		: 'datefieldbase',
		                	readOnly	:	true,
		                	fieldLabel	: HreRem.i18n('fieldlabel.fecha.alta'),
			            	bind		: {
			            		value: '{agrupacionficha.fechaAlta}'
			            	}		
						},
						{ 
							xtype		: 'displayfieldbase',
							fieldLabel	: HreRem.i18n('fieldlabel.entidad.propietaria'),
							bind		: {
								value: '{agrupacionficha.cartera}',
								readOnly: '{agrupacionficha.existeFechaBaja}'
							}	
						},
						{
							xtype		: 'comboboxfieldbase',
							fieldLabel	: HreRem.i18n('fieldlabel.provincia'),
							reference	: 'provinciaCombo',
							chainedStore: 'comboMunicipio',
							chainedReference: 'municipioCombo',
							allowBlank	:	'{esAgrupacionLoteComercial}',
			            	bind		: {
			            		store: '{comboProvincia}',
			            	    value: '{agrupacionficha.provinciaCodigo}',
			            	    readOnly: '{agrupacionficha.existeFechaBaja}'
			            	},
    						listeners	: {
								select: 'onChangeChainedCombo'
    						}
						},  
						{ 
		                	xtype		:'datefieldbase',
		                	fieldLabel	:  HreRem.i18n('fieldlabel.fecha.baja'),
			            	bind		: {
			            		value: 	'{agrupacionficha.fechaBaja}',
			            		minValue: '{agrupacionficha.fechaAlta}',
			            		readOnly: '{agrupacionficha.existeFechaBaja}',
			            		disabled: '{esAgrupacionAsistida}'
			            	}
						},
						{ 
		                	fieldLabel	: HreRem.i18n('fieldlabel.nombre'),
			            	bind		: {
			            		value: '{agrupacionficha.nombre}',
			            		readOnly: '{agrupacionficha.existeFechaBaja}'
			            	},
							allowBlank	:	false
		                },
						{ 
							fieldLabel	: HreRem.i18n('fieldlabel.codigo.postal'),
							bind		: {
								value: '{agrupacionficha.codigoPostal}',
								readOnly: '{agrupacionficha.existeFechaBaja}'
							},
							allowBlank	:	'{esAgrupacionLoteComercial}',
							maskRe		: /^\d*$/,
							vtype		: 'codigoPostal'
						},
						{ 
		                	xtype		: 'datefieldbase',
		                	fieldLabel	: HreRem.i18n('header.fecha.inicio.vigencia'),
			            	bind		: {
			            		value: '{agrupacionficha.fechaInicioVigencia}',
			            		readOnly: '{!esAgrupacionAsistidaAndFechaVigenciaNotNull}',
			            		hidden: '{!esAgrupacionAsistida}',
			            		maxValue: '{agrupacionficha.fechaFinVigencia}'
			            	}		
						},
						{ 
		                	xtype		: 'datefieldbase',
		                	fieldLabel	: HreRem.i18n('header.fecha.fin.vigencia'),
		                	maxValue	: null,
			            	bind		: {
			            		value: '{agrupacionficha.fechaFinVigencia}',
			            		readOnly: '{!esAgrupacionAsistidaAndFechaVigenciaNotNull}',
				        		hidden: '{!esAgrupacionAsistida}',
				        		minValue: '{agrupacionficha.fechaInicioVigencia}'
			            	}		
						}, 
						{
							xtype : 'button',
							text : HreRem.i18n('label.reactivar'),
							handler : 'onClickReactivarAgr',
							disabled : false,
							bind : {
								hidden: '{!esAgrupacionAsistida}',
								disabled: '{!agrupacionficha.existeFechaBaja}'
								
							}
						},
						{
		                    xtype		: 'comboboxfieldbase',                    
		                    reference	: 'comboFormalizacion',
		                    fieldLabel	: HreRem.i18n('fieldlabel.agrupacion.con.formalizacion'),
		                    bind		: {
		                    		store: '{comboSiNoRem}',
		                    		value: '{agrupacionficha.isFormalizacion}',
		                    		hidden: '{!esAgrupacionLoteComercial}',
		                        	readOnly: '{agrupacionTieneActivos}'                       
		                    },
		                    listeners	: {
		                        change: function(combo, value) {
		                          var me = this;
		                          if(value=='1') {                            
		                            me.up('formBase').down('[reference=cbGestoriaFormalizacion]').setDisabled(false);
		                            me.up('formBase').down('[reference=cbGestoriaFormalizacion]').validate();
		                            me.up('formBase').down('[reference=cbGestorFormalizacion]').setDisabled(false);
		                            me.up('formBase').down('[reference=cbGestorFormalizacion]').validate();
		                            me.up('formBase').down('[reference=cbGestorFormalizacion]').allowBlank = '{!esAgrupacionLoteComercial}';
		                            me.up('formBase').down('[reference=cbGestoriaFormalizacion]').allowBlank = '{!esAgrupacionLoteComercial}';
		                          } else {
		                            me.up('formBase').down('[reference=cbGestoriaFormalizacion]').allowBlank = true;
		                            me.up('formBase').down('[reference=cbGestoriaFormalizacion]').setValue("");
		                            me.up('formBase').down('[reference=cbGestoriaFormalizacion]').setDisabled(true);
		                            me.up('formBase').down('[reference=cbGestoriaFormalizacion]').validate();
		                            me.up('formBase').down('[reference=cbGestorFormalizacion]').allowBlank = true;
		                            me.up('formBase').down('[reference=cbGestorFormalizacion]').setValue("");
		                            me.up('formBase').down('[reference=cbGestorFormalizacion]').setDisabled(true);
		                            me.up('formBase').down('[reference=cbGestorFormalizacion]').validate();                            
		                          }
		                        }
		                    }
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.perimetro.destino.comercial'),
							bind: {
								store: '{comboTipoDestinoComercialCreaFiltered}',
								value: '{agrupacionficha.tipoComercializacionCodigo}'
							}
						}
				]
          },
          {
				xtype: 'gridBase',
				title: HreRem.i18n('title.historico.vigencias'),
			    minHeight: 100,
				cls	: 'panel-base shadow-panel',
				reference: 'listadoSubdivisionesAgrupacion',
				
				bind: {
					store: '{storeHistoricoVigencias}',
					hidden: '{!esAgrupacionAsistida}'
				},
				listeners : [
				],
				columns: [
				
				    {   
						text: HreRem.i18n('header.fecha.inicio.vigencia'),
			        	dataIndex: 'fechaInicioVigencia',
			        	formatter: 'date("d/m/Y H:i:s")',
						flex: 1
			        },
			        {   
						text: HreRem.i18n('header.fecha.fin.vigencia'),
			        	dataIndex: 'fechaFinVigencia',
			        	formatter: 'date("d/m/Y H:i:s")',
						flex: 1
			        },
			        {   
						text: HreRem.i18n('header.fecha.creacion'),
			        	dataIndex: 'fechaCrear',
			        	formatter: 'date("d/m/Y  H:i:s")',
						flex: 1
			        },
			        {   
						text: HreRem.i18n('fieldlabel.usuario'),
			        	dataIndex: 'usuarioModificacion',
			        	flex: 1
			        }
			       	        
			    ]
			},
          {
        	  xtype			:'fieldsettable',
        	  collapsible	: true,
        	  defaultType	: 'textfieldbase',
        	  title			: HreRem.i18n('title.datos.gestores'),
        	  colspan		: 3,
        	  layout		: {
        		  type: 'table',
        		  columns: 2
        	  },
        	  bind			: {
        		  hidden: '{!esAgrupacionLoteComercial}'
        	  },
        	  items			: [
						{
							xtype		: 'comboboxfieldbase',
				        	fieldLabel	: HreRem.i18n('fieldlabel.gestoria.formalizacion'),
				        	reference	: 'cbGestoriaFormalizacion',
				        	hidden		: true,
				        	displayField: 'apellidoNombre',
				        	valueField	: 'id',
				        	bind		: {
			            		store: '{comboGestoriaFormalizacion}',
			            		value: '{agrupacionficha.codigoGestoriaFormalizacion}'
			            	}
						},
						{
							xtype		: 'comboboxfieldbase',
				        	fieldLabel	: HreRem.i18n('fieldlabel.gestor.comercial'),
				        	reference	: 'cbGestorComercial',
				        	displayField: 'apellidoNombre',
				        	valueField	: 'id',
				        	bind		: {
			            		store: '{comboGestorComercial}',
			            		value: '{agrupacionficha.codigoGestorComercial}'
			            	}
						},
						{
							xtype		: 'comboboxfieldbase',
				        	fieldLabel	: HreRem.i18n('fieldlabel.gestor.formalizacion'),
				        	reference	: 'cbGestorFormalizacion',
				        	hidden		: true,
				        	displayField: 'apellidoNombre',
				        	valueField	: 'id',
				        	bind		: {
			            		store: '{comboGestorFormalizacion}',
			            		value: '{agrupacionficha.codigoGestorFormalizacion}'
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
		
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    }
});