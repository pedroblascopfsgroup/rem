Ext.define('HreRem.view.precios.generacion.GeneracionPropuestasManual', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'generacionpropuestasmanual',
    reference	: 'generacionPropuestasManual',    
	scrollable: 'y',
	layout: {
        type: 'vbox',
        align: 'stretch'
    },
    
    defaults: {
		
    	xtype: 'fieldsettable',
    	deafaultType: 'textfieldbase'
    },

    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.seleccion.manual"));
        
        me.buttons = [{ text: 'Buscar', handler: 'onSearchManualClick' },{ text: 'Limpiar', handler: 'onCleanFiltersClick'}];
        me.buttonAlign = 'left';
        
        var items = [
        
       {
        	title: HreRem.i18n('title.tipo.propuesta'),
	        defaults: {	
		    	xtype: 'textfieldbase',
		    	addUxReadOnlyEditFieldPlugin: false
		    }, 
		    layout: {
			    type: 'table',
				columns: 2,
				tdAttrs: {width: '50%'},
				tableAttrs: {
		            style: {width: '100%'}
		        }
			},
        	items: [
					{ 
					    xtype: 'comboboxfieldbase',
					    editable: true,
						fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
						name: 'entidadPropietariaCodigo',
						reference: 'entidadPropietariaCodigoRef',
						publishes: 'value',
						bind: {
							store: '{comboEntidadPropietaria}'
						},
		            	allowBlank: false
					},
					{
						xtype: 'comboboxfieldbase',
						editable: true,
						fieldLabel: HreRem.i18n('fieldlabel.tipo.propuesta'),
						name: 'tipoPropuestaCodigo',
		            	allowBlank: false,
						bind: {
		            		store: '{comboTiposPropuesta}'
		            	}
					},
					{ 
					    xtype: 'comboboxfieldbase',
					    editable: true,
						fieldLabel: HreRem.i18n('fieldlabel.propietario'),
						name: 'propietario',
						bind: {
							store: '{comboActivoPropietario}',
							disabled: '{!entidadPropietariaCodigoRef.value}',
							filters: {
				                property: 'codigo',
				                value: '{entidadPropietariaCodigoRef.value}'
				            }
						},
		            	allowBlank: false,
		            	valueField: 'id'
					},
					{
						xtype: 'checkboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.generacion.manual.check.todos'),
						name: 'checkTodosActivos',
			        	inputValue: true
					}
        	]
        },
        
        {
        	title: HreRem.i18n('title.titulo'),
	        defaults: {	
		    	xtype: 'textfieldbase',
		    	addUxReadOnlyEditFieldPlugin: false
		    }, 
        	items: [
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.origen.activo'),
						name: 'tipoTituloActivoCodigo',
						reference: 'tipoTituloCodigo',
						publishes: 'value',
		            	bind: {
		            		store: '{comboTipoTitulo}'
		            	}
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.subtipo.titulo'),
						name: 'subtipoTituloActivoCodigo',
		            	bind: {
		            		store: '{comboSubtipoTitulo}',
		            		disabled: '{!tipoTituloCodigo.value}',
		            		filters: {
				                property: 'codigoTipoTitulo',
				                value: '{tipoTituloCodigo.value}'
				            }
		            	}
					}
        	]
        },
        {
        	title: HreRem.i18n('title.estado.admision'),
	        defaults: {	
		    	xtype: 'textfieldbase',
		    	addUxReadOnlyEditFieldPlugin: false
		    }, 
        	items: [
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.inscrito'),
						name:	'inscrito',
						bind: {
							store: '{comboSiNoRem}'
						}
					},
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.con.toma.posesion.inicial'),
						name:	'conPosesion',
						bind: {
							store: '{comboSiNoRem}'
						}
					},
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.con.fecha.revision.cargas'),
						name:	'conCargas',
						bind: {
							store: '{comboSiNoRem}'
						}
					}
					
        	]
        },
        {
        	title: HreRem.i18n('title.estado.comercial'),
    	    defaults: {	
		    	xtype: 'textfieldbase',
		    	addUxReadOnlyEditFieldPlugin: false
		    },         	
        	items: [
        			{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.tipo.comercializacion'),
						name:	'tipoComercializacion',
						bind: {
							store: '{comboTiposComercializacion}'
						}
					},
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.con.oferta.aprobada'),
						name:	'conOfertaAprobada',
						bind: {
							store: '{comboSiNoRem}'
						}
					},
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.con.reserva'),
						name:	'conReserva',
						bind: {
							store: '{comboSiNoRem}'
						}
					}    
        	]
        },
        {
        	title: HreRem.i18n('title.informe.comercial'),
    	    defaults: {	
		    	xtype: 'textfieldbase',
		    	addUxReadOnlyEditFieldPlugin: false
		    },         	
        	items: [
        			{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.mediador.designado'),
						name:	'tieneMediador',
						bind: {
							store: '{comboSiNoRem}'
						}
					},
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.con.llaves.recibidas.mediador'),
						name:	'tieneLLavesMediador',
						bind: {
							store: '{comboSiNoRem}'
						}
					},
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.estado.informe.comercial'),
						name:	'estadoInformeComercial',
						bind: {
							store: '{comboEstadoInformeComercial}'
						}
					} 
        	]
        },
        {
        	title: HreRem.i18n('title.valoraciones.precios'),
    	    defaults: {	
		    	xtype: 'textfieldbase',
		    	addUxReadOnlyEditFieldPlugin: false
		    },         	
        	items: [
        	
        			{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.con.tasacion'),
						name:	'conTasacion',
						bind: {
							store: '{comboSiNoRem}'
						}
					},
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.fsv.venta'),
						name:	'conFsvVenta',
						bind: {
							store: '{comboSiNoRem}'
						}
					},
					{ 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.fsv.renta'),
						name:	'conFsvRenta',
						bind: {
							store: '{comboSiNoRem}'
						}
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.bloqueado'),
						name:	'conBloqueo',
						bind: {
							store: '{comboSiNoRem}'
						}
					}
        	]
        },
        {
        	title: HreRem.i18n('title.direccion'),
    	    defaults: {	
		    	xtype: 'textfieldbase',
		    	addUxReadOnlyEditFieldPlugin: false
		    },         	
        	items: [
        	        { 
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.provincia'),
						name:	'provinciaCodigo',
						bind: {
							store: '{comboFiltroProvincias}'
						}
					},
					{
						fieldLabel: HreRem.i18n('fieldlabel.municipio'),
		            	name:		'municipio'
					}, 
					{ 
						fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
						name:	'codPostal'
					}        	
        	]
        }

        ];
        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent();
        
    }
    
});

