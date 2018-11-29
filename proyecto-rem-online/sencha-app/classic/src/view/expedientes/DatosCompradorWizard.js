Ext.define('HreRem.view.expedientes.DatosCompradorWizard', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'datoscompradorwizard',
	reference: 'datoscompradorwindowref',
	y:Ext.Element.getViewportHeight()*(10/150),
    controller: 'expedientedetalle',
    viewModel: {
        type: 'expedientedetalle'
    },
    requires: ['HreRem.model.FichaComprador'],
   
    modal	: true,

	collapsed: false,
	idComprador: null,
	expediente: null,
	modoEdicion: true, // Inicializado para evitar errores.
	scrollable	: 'y',
	recordName: "comprador",
	recordClass: "HreRem.model.FichaComprador",
	listeners: {
		boxready:'cargarDatosCompradorWizard'
	},
  

    initComponent: function() {
    	var me = this;
    	me.buttonAlign = 'right';
    	if(!Ext.isEmpty(me.idComprador)){
			me.buttons = [ { itemId: 'btnModificar', text: HreRem.i18n('btn.modificar'), handler: 'onClickBotonModificarComprador', bind:{disabled: !me.esEditable()}},
    					   { itemId: 'btnCancelar', text: HreRem.i18n('btn.cancelBtnText'), handler: 'onClickBotonCerrarComprador'}];
    	} else {
    		me.buttons = [ { itemId: 'btnCrear', text: HreRem.i18n('btn.crear'), handler: function(btn){
				var wizard = btn.up().up().up();
				var layout = wizard.getLayout();
				layout["next"]();
			}},
    					   { itemId: 'btnCancelar', text: HreRem.i18n('btn.cancelBtnText'), handler: 'onClickBotonCerrarComprador'}];
    	}
    	 me.items = [{
			xtype:'fieldsettable',
			collapsible: false,
			hidden: me.esEditable(),
			margin: '10px 0 0 10px',
			items :
				[
					{
					xtype: 'label',
					text: HreRem.i18n('fieldlabel.no.modificar.compradores'),
					margin: '10px 0 0 10px',
					style: 'font-weight: bold'
					}
				]
	    },
	    {    
			xtype:'fieldsettable',
			collapsible: false,
			defaultType: 'textfieldbase',
			margin: '10px 10px 10px 10px',		
			layout: {
		        type: 'table',
		        columns: 2,
		        tdAttrs: {width: '55%'}
			},
			items :
				[
					{ 
						xtype: 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.tipo.persona'),
						reference: 'tipoPersona',
						margin: '10 0 10 0',
			        	bind: {
		            		store: '{comboTipoPersona}',
		            		value: '{comprador.codTipoPersona}'
		            	},
		            	allowBlank: false,
						listeners: {
							change: 'comprobarObligatoriedadCamposNexos'
						}
			        },
			        {
			        	xtype: 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.titular.reserva'),
						reference: 'titularReserva',
						hidden: true,
						margin: '10 0 10 0',
			        	bind: {
		            		store: '{comboSiNoRem}',
		            		value: '{comprador.titularReserva}'
		            	}
            		},
					{ 
            			xtype:'numberfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.porcion.compra'),
			        	reference: 'porcionCompra',
			        	bind: '{comprador.porcentajeCompra}',
			        	maxValue: 100,
			        	minValue:0,
		            	allowBlank: false
			        },
			        {
            			xtype: 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.titular.contratacion'),
						reference: 'titularContratacion',
			        	bind: {
		            		store: '{comboSiNoRem}',
		            		value: '{comprador.titularContratacion}',
		            		hidden: '{!comprador.titularContratacion}'
		            	},
		            	disabled: true
            		},
            		{
            			xtype: 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.grado.propiedad'),
						reference: 'gradoPropiedad',
			        	bind: {
		            		store: '{comboTipoGradoPropiedad}',
		            		value: '{comprador.codigoGradoPropiedad}'
		            	}
            		}
				]
       },
       {    
			xtype:'fieldsettable',
			collapsible: false,
			defaultType: 'textfieldbase',
			margin: '10 10 10 10',
			layout: {
		        type: 'table',
		        columns: 2,
		        tdAttrs: {width: '55%'}
			},
			title: HreRem.i18n('fieldlabel.datos.identificacion'),
			items :
				[
					{ 
						xtype: 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.tipoDocumento'),
						reference: 'tipoDocumento',
			        	bind: {
		            		store: '{comboTipoDocumento}',
		            		value: '{comprador.codTipoDocumento}'
		            	},
		            	allowBlank: false
			        },
			        {
			        	fieldLabel: HreRem.i18n('fieldlabel.numero.documento'),
						reference: 'numeroDocumento',
			        	bind: {
		            		value: '{comprador.numDocumento}'
		            	},
		            	listeners: {
		            		change: 'onNumeroDocumentoChange'
		            	},
		            	allowBlank: false
           		},
					{ 
			        	fieldLabel:  HreRem.i18n('header.nombre.razon.social'),
			        	reference: 'nombreRazonSocial',
			        	bind: {
		            		value: '{comprador.nombreRazonSocial}'
		            	}
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.apellidos'),
			        	reference: 'apellidos',
			        	bind: {
		            		value: '{comprador.apellidos}'
		            	}
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.direccion'),
			        	reference: 'direccion',
			        	bind: {
		            		value: '{comprador.direccion}'
		            	}
			        },

			        {
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.provincia'),
						reference: 'provinciaCombo',
						chainedStore: 'comboMunicipio',
						chainedReference: 'municipioCombo',
		            	bind: {
		            		store: '{comboProvincia}',
		            	    value: '{comprador.provinciaCodigo}'
		            	},
						listeners: {
							select: 'onChangeChainedCombo'
						}
					},
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.telefono1'),
			        	reference: 'telefono1',
			        	bind: {
		            		value: '{comprador.telefono1}'
		            	}
			        },
			        
			        {
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.municipio'),
						reference: 'municipioCombo',
		            	bind: {
		            		store: '{comboMunicipio}',
		            		value: '{comprador.municipioCodigo}',
		            		disabled: '{!comprador.provinciaCodigo}'
		            	}
					},
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.telefono2'),
			        	reference: 'telefono2',
			        	bind: {
		            		value: '{comprador.telefono2}'
		            	}
			        },
			        { 
			        	xtype:'numberfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.codigo.postal'),
			        	reference: 'codigoPostal',
			        	bind: {
		            		value: '{comprador.codigoPostal}'
		            	}
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.email'),
			        	reference: 'email',
			        	bind: {
		            		value: '{comprador.email}'
		            	}
			        },
			        {
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.pais'),
						reference: 'pais',
		            	bind: {
		            		store: '{comboPaises}',
		            		value: '{comprador.codigoPais}'
		            	}
					},
			        {
			        	xtype      : 'container',
                       layout: 'box',
                       items: [
                       	{ 
								xtype: 'comboboxfieldbase',
								width: 360,
					        	fieldLabel: HreRem.i18n('title.windows.datos.cliente.ursus'),
								reference: 'seleccionClienteUrsus',
					        	bind: {
				            		store: '{comboClienteUrsus}',
				            		hidden: '{!esCarteraBankia}'
				            	},
				            	listeners: {
				            		change: 'establecerNumClienteURSUS',
				            		expand: 'buscarClientesUrsus'
				            	},
				            	valueField: 'numeroClienteUrsus',
				            	displayField: 'nombreYApellidosTitularDeOferta',
				            	recargarField: false,
				            	queryMode: 'local',
				            	autoLoadOnValue: false,
				            	loadOnBind: false,
				            	allowBlank:true
					        },
                           {
                               xtype: 'button',
					            handler: 'mostrarDetallesClienteUrsus',
					            bind: {
					            	hidden: '{!esCarteraBankia}'
					            },
					            reference: 'btnVerDatosClienteUrsus',
					            disabled: true,
					            cls: 'search-button-buscador',
								iconCls: 'app-buscador-ico ico-search'
                           }
                       ]
			        },
			        
			       {
                   	xtype: 'textfieldbase',
				        fieldLabel:  HreRem.i18n('header.numero.ursus'),
				        reference: 'numeroClienteUrsusRef',
				        bind: {
			            	value: '{comprador.numeroClienteUrsus}',
			            	hidden: '{!esCarteraBankia}'
			            },
			            editable: true
                   },
                   
                   {
                   	xtype: 'textfieldbase',
				        fieldLabel:  HreRem.i18n('header.numero.ursus.bh'),
				        reference: 'numeroClienteUrsusBhRef',
				        bind: {
			            	value: '{comprador.numeroClienteUrsusBh}',
			            	hidden: '{!esBankiaHabitat}'
			            },
			            editable: true
                   }
				]
      },
      {
			xtype:'fieldsettable',
			collapsible: false,
			defaultType: 'textfieldbase',
			margin: '10 10 10 10',
			layout: {
		        type: 'table',
		        columns: 2,
		        tdAttrs: {width: '55%'}
			},
			title: HreRem.i18n('title.nexos'),
			items :
				[
					{ 
						xtype: 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.estado.civil'),
						reference: 'estadoCivil',
			        	bind: {
		            		store: '{comboEstadoCivil}',
		            		value: '{comprador.codEstadoCivil}'
		            	},
		            	listeners: {
							change: 'comprobarObligatoriedadCamposNexos'
						},
		            	allowBlank:true
			        },
			        {
			        	xtype: 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.regimen.economico'),
						reference: 'regimenMatrimonial',
			        	bind: {
		            		store: '{comboRegimenesMatrimoniales}',
		            		value: '{comprador.codigoRegimenMatrimonial}'
		            	},
		            	listeners: {
		            		change: 'comprobarObligatoriedadCamposNexos'
		            	},
		            	allowBlank:true
          		},
					{ 
			        	fieldLabel:  HreRem.i18n('fieldlabel.num.reg.conyuge'),
			        	reference: 'numRegConyuge',
			        	bind: {
		            		value: '{comprador.documentoConyuge}'
		            	}
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.relacion.hre'),
			        	reference: 'relacionHre',
			        	bind: {
		            		value: '{comprador.relacionHre}'
		            	}
			        },
			        { 
			        	xtype: 'comboboxfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.antiguo.deudor'),
			        	reference: 'antiguoDeudor',
			        	bind: {
			        		store: '{comboSiNoRem}',
			        		value: '{comprador.antiguoDeudor}'
		            	}
			        },
			        { 
			        	xtype: 'comboboxfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.relacion.ant.deudor'),
			        	reference: 'relacionAntDeudor',
			        	bind: {
			        		store: '{comboSiNoRem}',
			        		value: '{comprador.relacionAntDeudor}'
		            	}
			        }
				]
     },
     {
			xtype:'fieldsettable',
			collapsible: false,
			defaultType: 'textfieldbase',
			margin: '10 10 10 10',
			layout: {
		        type: 'table',
		        columns: 2,
		        tdAttrs: {width: '55%'}
			},
			title: HreRem.i18n('title.datos.representante'),
			items :
				[
					{ 
						xtype: 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.tipoDocumento'),
						reference: 'tipoDocumentoRte',
			        	bind: {
		            		store: '{comboTipoDocumento}',
		            		value: '{comprador.codTipoDocumentoRte}'
		            	},
		            	listeners : {
		            		change: function(combo, value) {
		            			var me = this;
		            			if(value) {
		            				me.up('formBase').down('[reference=numeroDocumentoRte]').allowBlank = false;
		            			} else {
		            				me.up('formBase').down('[reference=numeroDocumentoRte]').allowBlank = true;
		            				me.up('formBase').down('[reference=numeroDocumentoRte]').setValue("");
		            			}
		            		}
		            	}
			        },
			        {
			        	fieldLabel: HreRem.i18n('fieldlabel.numero.documento'),
						reference: 'numeroDocumentoRte',
			        	bind: {
		            		value: '{numeroDocumentoRte}',
		            		value: '{comprador.numDocumentoRte}'
		            	},
		            	listeners : {
		            		change: function(combo, value) {
		            			var me = this;
		            			if(value) {
		            				me.up('formBase').down('[reference=tipoDocumentoRte]').allowBlank = false;
		            			} else {
		            				me.up('formBase').down('[reference=tipoDocumentoRte]').allowBlank = true;
		            				me.up('formBase').down('[reference=tipoDocumentoRte]').setValue("");
		            			}
		            		}
		            	}
         		},
					{ 
			        	fieldLabel:  HreRem.i18n('header.nombre.razon.social'),
			        	reference: 'nombreRazonSocialRte',
			        	bind: {
		            		value: '{comprador.nombreRazonSocialRte}'
		            	}
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.apellidos'),
			        	reference: 'apellidosRte',
			        	bind: {
		            		value: '{comprador.apellidosRte}'
		            	}
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.direccion'),
			        	reference: 'direccionRte',
			        	bind: {
		            		value: '{comprador.direccionRte}'
		            	}
			        },
			        {
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.provincia'),
						reference: 'provinciaComboRte',
						chainedStore: 'comboMunicipioRte',
						chainedReference: 'municipioComboRte',
		            	bind: {
		            		store: '{comboProvincia}',
		            	    value: '{comprador.provinciaRteCodigo}'
		            	},
						listeners: {
							select: 'onChangeChainedCombo'
						}
					},		        
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.telefono1'),
			        	reference: 'telefono1Rte',
			        	bind: {
		            		value: '{comprador.telefono1Rte}'
		            	}
			        },
			        {
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.municipio'),
						reference: 'municipioComboRte',
		            	bind: {
		            		store: '{comboMunicipioRte}',
		            		value: '{comprador.municipioRteCodigo}',
		            		disabled: '{!comprador.provinciaRteCodigo}'
		            	}
					},		        
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.telefono2'),
			        	reference: 'telefono2Rte',
			        	bind: {
		            		value: '{comprador.telefono2Rte}'
		            	}
			        },
			        { 
			        	xtype:'numberfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.codigo.postal'),
			        	reference: 'codigoPostalRte',
			        	bind: {
		            		value: '{comprador.codigoPostalRte}'
		            	}
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.email'),
			        	reference: 'emailRte',
			        	bind: {
		            		value: '{comprador.emailRte}'
		            	}
			        },
			        {
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.pais'),
						reference: 'paisRte',
		            	bind: {
		            		store: '{comboPaises}',
		            		value: '{comprador.codigoPaisRte}'
		            	}
					}
				]
    }
     ]
    	me.callParent();  	
    },
    				 			
     resetWindow: function() {
    	var me = this;    	
		me.setBindRecord(comprador);
    },
    
    esEditable: function(){
    	var me = this;
    	
    	if($AU.userIsRol("HAYASUPER")){
    		return true;
    	}
    	
    	if($AU.userHasFunction(['MODIFICAR_TAB_COMPRADORES_EXPEDIENTES'])){
    		if(!$AU.userHasFunction(['MODIFICAR_TAB_COMPRADORES_EXPEDIENTES_RESERVA']) && me.checkCoe()){
    			return false;
    		}
    		return true;
    	}
    	
    	return false;
    },
    
    checkCoe: function(){
    	var me = this;
    	
    	var estadoExpediente = me.expediente.data.codigoEstado;
    	var solicitaReserva = me.expediente.data.solicitaReserva;
    	if((solicitaReserva == 0 || solicitaReserva == null) && (estadoExpediente == CONST.ESTADOS_EXPEDIENTE['RESERVADO'] || estadoExpediente == CONST.ESTADOS_EXPEDIENTE['APROBADO']
    	|| estadoExpediente == CONST.ESTADOS_EXPEDIENTE['FIRMADO'] || estadoExpediente == CONST.ESTADOS_EXPEDIENTE['ANULADO'] || estadoExpediente == CONST.ESTADOS_EXPEDIENTE['VENDIDO'])){
    		return true;
    	}
    	if(solicitaReserva == 1 && (estadoExpediente == CONST.ESTADOS_EXPEDIENTE['RESERVADO'] || estadoExpediente == CONST.ESTADOS_EXPEDIENTE['FIRMADO'] 
    	|| estadoExpediente == CONST.ESTADOS_EXPEDIENTE['ANULADO'] || estadoExpediente == CONST.ESTADOS_EXPEDIENTE['VENDIDO'])){
    		return true;
    	}
    	return false;
    }
});