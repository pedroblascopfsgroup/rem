Ext.define('HreRem.view.administracion.gastos.GestionGastosSearch', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'gestiongastossearch',
    isSearchFormGastos: true,
  	layout: 'column',
	defaults: {
        xtype: 'fieldsettable',
        columnWidth: 1,
        cls: 'fieldsetCabecera',
        collapsed: true
    },

	initComponent: function() {

		var me = this;
    	me.setTitle(HreRem.i18n('title.filtro'));
    	me.removeCls('shadow-panel');

	    me.items= [
				    {
			    		title: HreRem.i18n('title.filtro.por.situacion.gasto'),
			    		defaultType: 'textfieldbase',
			    		defaults: {
							addUxReadOnlyEditFieldPlugin: false
						},
			    		items: [

			    			{
								xtype: 'comboboxfieldbase',
								name: 'estadoGastoCodigo',
				              	fieldLabel : 'Estado gasto',
								bind: {
									store: '{estadosGasto}'
								}
							},
			    			{
								xtype: 'comboboxfieldbase',
								name: 'estadoAutorizacionHayaCodigo',
				              	fieldLabel : 'Estado autorización Haya',
								bind: {
									store: '{comboEstadoAutorizacionHaya}'
								}
							},
							{
								xtype: 'comboboxfieldbase',
								name: 'estadoAutorizacionPropietarioCodigo',
				              	fieldLabel : 'Estado autorización propietario',
								bind: {
									store: '{comboEstadoAutorizacionPropietario}'
								}
							}

						]
				    },
				    {
			    		title: HreRem.i18n('title.filtro.por.gasto'),
			    		defaultType: 'textfieldbase',
			    		defaults: {
							addUxReadOnlyEditFieldPlugin: false
						},
			    		items: [
	    					{
						    	fieldLabel: HreRem.i18n('fieldlabel.numero.gasto'),
						        name: 'numGastoHaya',
						        listeners : {
							    	change: 'onChangeNumGasto'
						        } 
						    },
						    {
					        	xtype: 'comboboxfieldbasedd',
					        	fieldLabel: HreRem.i18n('fieldlabel.tipo'),
					        	reference: 'filtroComboTipoGasto',
					        	name: 'tipoGastoCodigo',
					        	bind: {
				            		store: '{comboTipoGasto}'
				            	},
								publishes: 'value',
								chainedStore: 'comboSubtipoGastoFiltered',
					        	chainedReference: 'subtipoGastoCodigoRef',
					        	listeners: {
									select: 'onChangeChainedCombo'
								}

							},
							{
						    	fieldLabel: HreRem.i18n('fieldlabel.importe.desde'),
						        name: 'importeDesde'
						    },
						    {
						    	fieldLabel: HreRem.i18n('fieldlabel.numero.gasto.gestoria'),
						        name: 'numGastoGestoria'
						    },
						    {
					        	xtype: 'comboboxfieldbasedd',
					        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo'),
					        	reference: 'subtipoGastoCodigoRef',
					        	name: 'subtipoGastoCodigo',
					        	bind: {
				            		store: '{comboSubtipoGastoFiltered}',
				                    disabled: '{!filtroComboTipoGasto.value}'
				                    /*,
				                    filters: {
				                        property: 'tipoGastoCodigo',
				                        value: '{filtroComboTipoGasto.value}'
				                    }*/
				            	}
					        },
    						{
						    	fieldLabel: HreRem.i18n('fieldlabel.importe.hasta'),
						        name: 'importeHasta'
						    },
						    {
						    	fieldLabel: HreRem.i18n('fieldlabel.referencia.emisor'),
						        name: 'referenciaEmisor'
						    },
						    {
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.periodicidad'),
					        	name: 'periodicidad',
					        	bind: {
				            		store: '{comboPeriodicidad}'
				            	}
    						},
							{
			                	xtype:'datefieldbase',
						 		fieldLabel: HreRem.i18n('fieldlabel.fecha.tope.pago.desde'),
						 		name: 'fechaTopePagoDesde',
				            	formatter: 'date("d/m/Y")',
	            	        	listeners : {
					            	change: function (a, b) {
					            		//Eliminar la fechaHasta e instaurar
					            		//como minValue a su campo el valor de fechaDesde
					            		var me = this,
					            		fechaHasta = me.up('form').down('[name=fechaTopePagoHasta]');
					            		fechaHasta.reset();
					            		fechaHasta.setMinValue(me.getValue());
					                }
				            	}
							},
							{
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.destinatario'),
					        	name: 'destinatario',
					        	bind: {
				            		store: '{comboDestinatarios}'
				            	},
				            	displayField: 'descripcion',
								valueField: 'codigo'
    						},
    						{
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.cubre.seguro'),
					        	name: 'cubreSeguro',
					        	bind: {
				            		store: '{comboSiNoRem}'
				            	},
				            	displayField: 'descripcion',
								valueField: 'codigo'
    						},
							{
			                	xtype:'datefieldbase',
						 		fieldLabel: HreRem.i18n('fieldlabel.fecha.tope.pago.hasta'),
						 		name: 'fechaTopePagoHasta',
						 		maxValue: null,
						 		formatter: 'date("d/m/Y")'
							},
							{
					        	xtype: 'comboboxfieldbase',
						    	fieldLabel: HreRem.i18n('fieldlabel.gestoria.responsable'),
					        	name: 'idGestoria',
					        	bind: {
				            		store: '{comboGestorias}'
				            	},
				            	displayField: 'descripcion',
								valueField: 'id'
    						},
    						{
						    	fieldLabel: HreRem.i18n('fieldlabel.num.provision'),
						        name: 'numProvision'
    						},
							{
			                	xtype:'datefieldbase',
						 		fieldLabel: HreRem.i18n('fieldlabel.fecha.emision.desde'),
						 		name: 'fechaEmisionDesde',
						 		formatter: 'date("d/m/Y")'
							},

    						{
    							fieldLabel: HreRem.i18n('fieldlabel.nombre.propietario'),
						        name: 'nombrePropietario'
    						},
    						{
    							fieldLabel: HreRem.i18n('fieldlabel.docidentif.propietario'),
						        name: 'docIdentifPropietario'
    						},
    						{
			                	xtype:'datefieldbase',
						 		fieldLabel: HreRem.i18n('fieldlabel.fecha.emision.hasta'),
						 		name: 'fechaEmisionHasta',
						 		formatter: 'date("d/m/Y")'
							},
    						{
			                	xtype:'datefieldbase',
						 		fieldLabel: HreRem.i18n('fieldlabel.fecha.autorizacion.desde'),
						 		name: 'fechaAutorizacionDesde',
						 		formatter: 'date("d/m/Y")'
							},
							{
			                	xtype:'datefieldbase',
						 		fieldLabel: HreRem.i18n('fieldlabel.fecha.autorizacion.hasta'),
						 		name: 'fechaAutorizacionHasta',
						 		formatter: 'date("d/m/Y")'
							},
							{
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.sujeto.impuesto.indirecto'),
					        	name: 'impuestoIndirecto',
					        	bind: {
				            		store: '{comboSiNoRem}'
				            	},
				            	displayField: 'descripcion',
								valueField: 'codigo'
				             },
				             {
				                xtype: 'comboboxfieldbase',
				                fieldLabel:  HreRem.i18n('fieldlabel.motivo.aviso.gasto'),
				                name: 'codigoMotivoAviso',
				                bind: {
				                  store: '{comboMotivosAviso}'
				                },
				                displayField: 'descripcion',
				                valueField: 'codigo'
				             },
				             {
				    			fieldLabel: HreRem.i18n('fieldlabel.filtro.por.gasto'),
								name: 'numTrabajo'
				    		 }
			    		]
				    },
				    {

			    		title: HreRem.i18n('title.filtro.por.proveedor'),
			    		defaultType: 'textfieldbase',
			    		defaults: {
							addUxReadOnlyEditFieldPlugin: false
						},
						hidden: $AU.userIsRol(CONST.PERFILES['PROVEEDOR']),
			    		items: [

			    			{
						    	fieldLabel: HreRem.i18n('fieldlabel.nif.proveedor'),
						        name: 'nifProveedor'
						    },
					    	{
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.tipo'),
					        	reference: 'filtroComboTipoProveedor',
					        	name: 'codigoTipoProveedor',
					        	bind: {
				            		store: '{comboTipoProveedor}'
				            	},
								publishes: 'value'

							},
    						{
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo'),
					        	name: 'codigoSubtipoProveedor',
					        	bind: {
				            		store: '{comboSubtipoProveedor}',
				                    disabled: '{!filtroComboTipoProveedor.value}',
				                    filters: {
				                        property: 'tipoEntidadCodigo',
				                        value: '{filtroComboTipoProveedor.value}'
				                    }
				            	}
					        },
						    {
						    	fieldLabel: HreRem.i18n('fieldlabel.nombre.proveedor'),
						        name: 'nombreProveedor'
						    }

						]
				    },
				    {

			    		title: HreRem.i18n('title.filtro.por.activo.agrupacion'),
			    		defaultType: 'textfieldbase',
			    		defaults: {
							addUxReadOnlyEditFieldPlugin: false
						},
			    		items: [

			    			{
						    	fieldLabel: HreRem.i18n('fieldlabel.numero.activo'),
						        name: 'numActivo'
						    },

					    	{
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.cartera'),
					        	reference: 'filtroEntidadPropietaria',
					        	name: 'entidadPropietariaCodigo',
					        	bind: {
				            		store: '{comboEntidadPropietaria}'
				            	},
								listeners : {
				        			change: 'onChangeCartera'
				        		},
				            	publishes: 'value'

							},

							{
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.subcartera'),
					        	name: 'subentidadPropietariaCodigo',
					        	bind: {
				            		store: '{comboSubentidadPropietaria}',
				            		disabled: '{!filtroEntidadPropietaria.selection}',
				                    filters: {
				                        property: 'carteraCodigo',
				                        value: '{filtroEntidadPropietaria.value}'
				                    }
				            	}

							}

						]
				    }
	    ];

	    me.callParent();
	}
});
