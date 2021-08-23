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
							reference: 'numAgrupacionRemRef',
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
		                	fieldLabel	: HreRem.i18n('fieldlabel.nombre'),
			            	bind		: {
			            		value: '{agrupacionficha.nombre}',
			            		readOnly: '{agrupacionficha.existeFechaBaja}'
			            	},
							allowBlank	:	false
		                },
		                {
		                	fieldLabel: HreRem.i18n('header.numero.agrupacion.prinex'),
		                	bind: {
		                		hidden: '{!esAgrupacionPromocionAlquiler}',
		                		value: '{agrupacionficha.numAgrupPrinexHPM}',
		                		readOnly: false
		                	}		
		                },
		                {
		                	fieldLabel: HreRem.i18n('fieldlabel.numero.agrupacion.activo.matriz'),
		                	bind: {
		                		readOnly: '{existeActivoEnAgrupacion}',
		                		hidden: '{!esAgrupacionPromocionAlquiler}',
		                		value: '{agrupacionficha.activoMatriz}'
		                	},
		                	name: 'activoMatriz'
	                	},	
		                { 
		                	fieldLabel	: HreRem.i18n('fieldlabel.subtipo'),
			            	bind		: {
			            		value: '{agrupacionficha.subTipoComercial}',
			            		readOnly: true,
			            		hidden: '{!esComercialVentaOAlquiler}',
			            		disabled:'{esComercialVenta}'
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
			            		readOnly: '{isCampoReadOnly}'
			            	}

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
		                	fieldLabel	:  HreRem.i18n('fieldlabel.numero.agrupacion.externo'),
		                	bind		: {
			            		value: '{agrupacionficha.numAgrupUvem}',
			            		hidden:'{muestraUvem}'
			            	},			            	
							listeners:
							{
								afterrender: function(get){
									var me=this;
									var cartera = me.lookupController().getViewModel().getData().agrupacionficha.getData().codigoCartera;
									
									if (cartera == CONST.CARTERA['BANKIA']) {
										me.setFieldLabel(HreRem.i18n('fieldlabel.numero.agrupacion.caixa'));
									}
								}
							}
						},
		                {
							xtype		: 'comboboxfieldbase',
							fieldLabel	: HreRem.i18n('fieldlabel.tipo.alquiler'),
							reference	: 'tipoAlquilerCombo',
			            	bind		: {
			            		store: '{comboTipoAlquiler}',
			            	    value: '{agrupacionficha.tipoAlquilerCodigo}',
			            	    hidden: '{!esComercialVentaOAlquiler}',
			            	    readOnly:'{esComercialVenta}'
			            	}
						},
						
		                { 
							fieldLabel	: HreRem.i18n('fieldlabel.direccion'),
							bind		: {
								value: '{agrupacionficha.direccion}',
								readOnly: '{isCampoReadOnly}',
								hidden:'{esAgrupacionProyecto}'
							},
							allowBlank	:	'{esAgrupacionLoteComercial}'
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
							xtype		: 'comboboxfieldbase',
							fieldLabel	: HreRem.i18n('fieldlabel.entidad.propietaria'),
							bind		: {
								store: '{comboCartera}',
								value: '{agrupacionficha.codigoCartera}',
								readOnly: '{isCampoReadOnly}',
								allowBlank	:'{campoAllowBlank}'	
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
		                	
							xtype		: 'comboboxfieldbase',
							fieldLabel	: HreRem.i18n('fieldlabel.provincia'),
							reference	: 'provinciaCombo',
							chainedStore: 'comboMunicipio',
							chainedReference: 'municipioCombo',
			            	bind		: {
			            		store: '{comboProvincia}',
			            	    value: '{agrupacionficha.provinciaCodigo}',
			            	    readOnly: '{isCampoReadOnly}',
			            	    allowBlank	:'{campoAllowBlank}'
			            	},
    						listeners	: {
								select: 'onChangeChainedCombo'
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
							fieldLabel	: HreRem.i18n('fieldlabel.codigo.postal'),
							bind		: {
								value: '{agrupacionficha.codigoPostal}',
								readOnly: '{isCampoReadOnly}'
							},
//							allowBlank	:	'{esAgrupacionLoteComercial}',
							allowBlank	:	'{esAgrupacionLoteComercialOrRestringida}',
							maskRe		: /^\d*$/,
							vtype		: 'codigoPostal'
						},
						{ 
							xtype: 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.tipo.activo'),
				        	bind: {
			            		store: '{comboTipoActivo}',
			            		value: '{agrupacionficha.tipoActivoCodigo}',
			            		hidden: '{!esAgrupacionProyecto}',
			            		readOnly: '{agrupacionTieneActivosOrExisteFechaBaja}'
			            	}
			            	
		                },
		                { 
		                	xtype: 'comboboxfieldbase',
				        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.activo'),
				        	bind: {
			            		store: '{comboSubtipoActivo}',
			            		value: '{agrupacionficha.subtipoActivoCodigo}',
			            		hidden: '{!esAgrupacionProyecto}',
			            		readOnly: '{agrupacionTieneActivosOrExisteFechaBaja}'
			            	}
    					
		                },
		                { 
		                	xtype: 'comboboxfieldbase',
				        	fieldLabel:  HreRem.i18n('fieldlabel.estado.fisico.activo'),
				        	name: 'estadoActivoCodigo',
				        	bind: {
			            		store: '{comboEstadoActivo}',
			            		value: '{agrupacionficha.estadoActivoCodigo}',
			            		hidden: '{!esAgrupacionProyecto}',
			            		readOnly: '{agrupacionTieneActivosOrExisteFechaBaja}'
			            	}
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
							xtype: 'comboboxfieldbase',
                            fieldLabel: HreRem.i18n('fieldlabel.perimetro.destino.comercial'),
                            bind: {
                                store: '{comboTipoDestinoComercialCreaFiltered}',
                                value: '{agrupacionficha.tipoComercializacionCodigo}',
                                readOnly: '{!esAgrupacionRestringida}'
                            }	
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.agrupacion.comercializable.construccion.plano'),
							name: 'comercializableConsPlano',
							allowBlank:	false,
							bind: {
								value: '{agrupacionficha.comercializableConsPlano}',
								store: '{comboTrueFalse}',
								readOnly: false,
								disabled: '{!esAgrupacionThirdpartiesYubaiObraNueva}',
								hidden: '{!esAgrupacionThirdpartiesYubaiObraNueva}',
								listeners: {
									change: 'onChangeComboComercializableConsPlano'
								}
							}
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldLabel.agrupacion.existe.piso.piloto'),
							name: 'existePiloto',
							reference: 'existePiloto',
							allowBlank:	false,
							bind: {
								value: '{agrupacionficha.existePiloto}',
								store: '{comboTrueFalse}',
								readOnly: false,
								hidden: '{!esAgrupacionThirdpartiesYubaiObraNueva}',
								disabled: '{!comercializableConstruccionPlano}',
								listeners: {
									change: 'onChangeComboExistePisoPiloto'
								}
							}
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldLabel.agrupacion.visitable'),
							name: 'esVisitable',
							reference: 'esVisitable',
							allowBlank:	false,
							bind: {
								value: '{agrupacionficha.esVisitable}',
								store: '{comboTrueFalse}',
								readOnly: false,
								hidden: '{!esAgrupacionThirdpartiesYubaiObraNueva}',
								disabled: '{!comprobarExistePiloto}',
								listeners: {
									change: 'onChangeComboEsVisitable'
								}
							}
						},
						{
							xtype: 'textfieldbase',
							fieldLabel: HreRem.i18n('fieldLabel.agrupacion.piso.piloto'),
							name: 'pisoPiloto',
							reference: 'pisoPiloto',
							bind: {
								value: '{agrupacionficha.pisoPiloto}',
								readOnly: false,
								disabled: '{!comprobarEsVisitable}',
								allowBlank: '{!comprobarEsVisitable}',
								hidden: '{!esAgrupacionThirdpartiesYubaiObraNueva}'
							}
						},
						{
							xtype: 'textfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.empresa.promotora'),
							name: 'empresapromotora',
							reference: 'empresapromotora',
							bind: {
								value: '{agrupacionficha.empresaPromotora}',
								readOnly: false,
								hidden: '{!esAgrupacionThirdpartiesYubaiObraNueva}'
							}
						},
						{
							xtype: 'textfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.empresa.comercializadora'),
							name: 'empresacomercializadora',
							reference: 'empresacomercializadora',
							bind: {
								value: '{agrupacionficha.empresaComercializadora}',
								readOnly: false,
								hidden: '{!esAgrupacionThirdpartiesYubaiObraNueva}'
							}
						},
						{
							xtype: 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.venta.sobre.plano'),
				        	reference: 'ventaPlano',						
				        	bind: {	
				        		readOnly: '{!esUsuarioGestorComercialAgrupacionObraNueva}',
			            		store: '{comboSiNoBoolean}',
			            		value: '{agrupacionficha.ventaSobrePlano}'
			            	}
						},
						{
							xtype: 'textfieldbase',
							fieldLabel: HreRem.i18n('fieldLabel.agrupacion.codigo.on.sareb'),
							name: 'codigoOnSareb',
							reference: 'codigoOnSareb',
							bind: {
								value: '{agrupacionficha.codigoOnSareb}',
								readOnly: '{!usuarioEditarAgrupaciones}',
								hidden: '{!agrupacionficha.isObraNuevaSareb}'
							}
						}
				]
          },
          {
          	  xtype			:'fieldsettable',
          	  collapsible	: true,
          	  defaultType	: 'textfieldbase',
          	  title			: HreRem.i18n('title.datos.gestion.comercial'),
          	  bind			: {
          		  hidden: '{!esAgrupacionRestringida}'
          	  },
          	  items			: [
    						{
    							xtype:'checkboxfieldbase',
    							fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.visibleGestionComercial'),
    							reference: 'chkVisibleGestionComercial',
    							bind: {
    								value: '{agrupacionficha.visibleGestionComercial}',
    			            		readOnly:'{esEditableExcluirValidaciones}'
    							}
    						},
    						{
    							xtype: 'comboboxfieldbase',
    				        	fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.marcaDeExcluido'),
    				        	reference: 'chkMarcaDeExcluido',
    				        	bind: {	
    			            		store: '{comboSiNoBoolean}',
    			            		value: '{agrupacionficha.marcaDeExcluido}',
    			              		readOnly:'{esEditableExcluirValidaciones}'
    			            	}
    						},
    						{
    							xtype		: 'comboboxfieldbase',
    				        	fieldLabel	: HreRem.i18n('fieldlabel.perimetros.motivoDeExcluido'),
    				        	reference	: 'cbMotivoDeExcluido',
    				        	bind		: {
    			            		store: '{comboMotivoDeExcluido}',
    			            		value: '{agrupacionficha.motivoDeExcluidoCodigo}',
    			            		disabled: '{!agrupacionficha.marcaDeExcluido}',
    			              		readOnly:'{esEditableExcluirValidaciones}',
    			              		allowBlank:'{!agrupacionficha.marcaDeExcluido}'
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
        	  bind			: {
        		  hidden: '{!esAgrupacionLoteComercial}'
        		 //hidden: '{!esAgrupacionLoteComercialOrProyecto}'
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
						//Si es Liberbank se muestra el de Gestores Backoffice, si no el de Gestor Comercial
						{
							xtype		: 'comboboxfieldbase',
				        	fieldLabel	: HreRem.i18n('fieldlabel.gestor.activo'),
				        	reference	: 'cbGestorActivo',
				        	displayField: 'apellidoNombre',
				        	valueField	: 'id',
				        	bind		: {
			            		store: '{comboGestorActivos}',
			            		value: '{agrupacionficha.codigoGestorActivo}',
			            		hidden: '{!esAgrupacionProyecto}',
			            		readOnly:'{agrupacionProyectoTieneActivos}'
			            	}
						},
						{
							xtype		: 'comboboxfieldbase',
				        	fieldLabel	: HreRem.i18n('fieldlabel.gestor.comercial'),
				        	reference	: 'cbGestorComercial',
				        	displayField: 'apellidoNombre',
				        	valueField	: 'id',
				        	editable    : true,
		            		
				        	bind		: {
			            		store: '{comboGestorComercialTipo}',
			            		value: '{agrupacionficha.codigoGestorComercial}',
			            		hidden: '{esAgrupacionLiberbank}',
			            		readOnly:'{agrupacionProyectoTieneActivos}'
			            	},
			            	minChars: 0,
			            	anyMatch: true,
			            	queryMode: 'local'
						},
						{
							xtype		: 'comboboxfieldbase',
				        	fieldLabel	: HreRem.i18n('fieldlabel.gestor.comercial.backoffice'),
				        	reference	: 'cbGestorComercialBackoffice',
				        	displayField: 'apellidoNombre',
				        	valueField	: 'id',
				        	bind		: {
			            		store: '{comboGestorComercialBackoffice}',
			            		value: '{agrupacionficha.codigoGestorComercialBackOffice}',
			            		hidden: '{!mostrarComboBO}'
				        	}
						},
						{
							xtype		: 'comboboxfieldbase',
				        	fieldLabel	: HreRem.i18n('fieldlabel.doble.gestor.activo'),
				        	reference	: 'cbDobleGestorActivo',
				        	displayField: 'apellidoNombre',
				        	valueField	: 'id',
				        	bind		: { 
			            		store: '{comboDobleGestorActivo}',
			            		value: '{agrupacionficha.codigoGestorDobleActivo}',
			            		hidden: '{!esAgrupacionProyecto}',
			            		readOnly:'{agrupacionProyectoTieneActivos}'
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