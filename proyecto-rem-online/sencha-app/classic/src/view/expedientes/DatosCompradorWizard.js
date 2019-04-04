Ext.define('HreRem.view.expedientes.DatosCompradorWizard', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'datoscompradorwizard',
	reference: 'datoscompradorwizardref',
	y:Ext.Element.getViewportHeight()*(10/150),
    modal	: true,
    bodyStyle	: 'padding:20px',
	collapsed: false,
	idComprador: null, 
	expediente: null,
	modoEdicion: true, // Inicializado para evitar errores.
	scrollable	: 'y',
	listeners: {
		boxready:'cargarDatosCompradorWizard'
	},
	viewModel: {
        type: 'expedientedetalle'
    },

    initComponent: function() {
    	var me = this;
    	me.buttonAlign = 'right';
    	if(!Ext.isEmpty(me.idComprador)){
			me.buttons = [ { itemId: 'btnModificar', text: HreRem.i18n('btn.modificar'), handler: 'onClickBotonModificarComprador', bind:{disabled: !me.esEditable()}},
    					   { itemId: 'btnCancelar', text: HreRem.i18n('btn.cancelBtnText'), handler: 'onClickBotonCancelarWizardComprador'}];
    	} else {
    		me.buttons = [ { itemId: 'btnCrear', text: HreRem.i18n('btn.crear.comprador'), handler: 'onClickBotonCrearComprador', listeners: {click: 'comprobarFormato'}},
    					   { itemId: 'btnCancelar', text: HreRem.i18n('btn.cancelBtnText'), handler: 'onClickBotonCancelarWizardComprador'}];
    	}

    	 me.items = [{
    		xtype: 	'checkboxfieldbase', 
 	    	name:		'cesionDatos',
			bind:		'{comprador.cesionDatos}',
			hidden:		true
	    },

	    {
	    	xtype: 		'checkboxfieldbase',
	    	name:		'comunicacionTerceros',
			bind:		'{comprador.comunicacionTerceros}',
			hidden:		true
	    },

	    {
	    	xtype: 		'checkboxfieldbase',
	    	name:		'transferenciasInternacionales',
			bind:		'{comprador.transferenciasInternacionales}',
			hidden:		true
	    },
	    {   
	    	xtype:      'textfieldbase',
	    	name:		'pedirDoc',
			bind:		'{comprador.pedirDoc}',
			hidden:		true
	    },{
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
			title: HreRem.i18n('title.gasto.datos.generales'),
			layout: {
		        type: 'table',
		        columns: 2,
			    trAttrs: {width: '25%'},
		        tdAttrs: {width: '25%'}
			},
			items :
				[
					{ 
						xtype: 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.tipo.persona'),
						reference: 'tipoPersona',
						name: 'codTipoPersona',
						margin: '10px 0 10px 0',
						padding: '5px',
			        	bind: {	
			        		store: '{comboTipoPersona}'/*,
		            		value: '{comprador.codTipoPersona}'*/
		            		
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
						name: 'titularReserva',
						hidden: true,
						padding: '5px',
			        	bind: {
		            		store: '{comboSiNoRem}'/*,
		            		value: '{comprador.titularReserva}'*/
		            	}
            		},
					{ 
            			xtype:'numberfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.porcion.compra'),
			        	reference: 'porcionCompra',
			        	name: 'porcentajeCompra',
			        	//bind: '{comprador.porcentajeCompra}',
			        	maxValue: 100,
			        	minValue:0,
			        	padding: '5px',
		            	allowBlank: false
			        },
			        {
            			xtype: 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.titular.contratacion'),
						reference: 'titularContratacionWizard',
						name: 'titularContratacion',
						padding: '5px',
			        	bind: {
		            		store: '{comboSiNoRem}',
		            		//value: '{comprador.titularContratacion}',
		            		hidden: '{!comprador.titularContratacion}'
		            	},
		            	disabled: true
            		},
            		{
            			xtype: 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.grado.propiedad'),
						reference: 'gradoPropiedad',
						name: 'codigoGradoPropiedad',
						padding: '5px',
			        	bind: {
		            		store: '{comboTipoGradoPropiedad}'/*,
		            		value: '{comprador.codigoGradoPropiedad}'*/
		            	}
            		}
				]
       },
       {    
			xtype:'fieldsettable',
			collapsible: false,
			defaultType: 'textfieldbase',
			margin: '10px 10px 10px 10px',
			title: HreRem.i18n('fieldlabel.datos.identificacion'),
			layout: {
		        type: 'table',
		        columns: 2,
			    trAttrs: {width: '25%'},
		        tdAttrs: {width: '25%'}
			},
			items :
				[
					{ 
						xtype: 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.tipoDocumento'),
			        	name: 'codTipoDocumento',
						reference: 'tipoDocumento',
						margin: '10px 0 10px 0',
						padding: '5px',
			        	bind: {
		            		store: '{comboTipoDocumento}'/*,
		            		value: '{comprador.codTipoDocumento}'*/
		            	},
		            	allowBlank: false
			        },
			        
			        {  
			        	fieldLabel: HreRem.i18n('fieldlabel.numero.documento'),
			        	name: 'numDocumento',
						reference: 'numeroDocumento',
						padding: '5px',
//			        	bind: {
//		            		value: '{comprador.numDocumento}'
//		            	},
		            	listeners: {
		            		change: 'onNumeroDocumentoChange'
		            	},
		            	allowBlank: false
           	        }, 
					{   
			        	fieldLabel:  HreRem.i18n('header.nombre.razon.social'),
			        	name: 'nombreRazonSocial',
			        	reference: 'nombreRazonSocial',
			        	padding: '5px',
//			        	bind: {
//		            		value: '{comprador.nombreRazonSocial}' 
//		            	},
		            	allowBlank: false
			        },
			        {   
			        	fieldLabel:  HreRem.i18n('fieldlabel.apellidos'),
			        	name: 'apellidos',
			        	reference: 'apellidos',
			        	padding: '5px',
//			        	bind: {
//		            		value: '{comprador.apellidos}'
//		            	},
		            	allowBlank: false
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.direccion'),
			        	name: 'direccion',
			        	reference: 'direccion',
			        	padding: '5px',
			        	bind: {
		            		//value: '{comprador.direccion}',
		            		allowBlank: '{esObligatorio}'
		            	}
			        },

			        {
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.provincia'),
						reference: 'provinciaCombo',
						name: 'provinciaCodigo',
						padding: '5px',
						chainedStore: 'comboMunicipio',
						chainedReference: 'municipioCombo',
		            	bind: {
		            		store: '{comboProvincia}'/*,
		            		value: '{comprador.provinciaCodigo}'*/
		            	},
		            	displayField: 'descripcion',
						valueField: 'codigo',
						listeners: {
							change: 'onChangeComboProvincia'
						}
					},
				
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.telefono1'),
			        	name: 'telefono1',
			        	reference: 'telefono1',
			        	padding: '5px'/*,
			        	bind: {
		            		value: '{comprador.telefono1}'
		            	}*/
			        },
			        
			       {
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.municipio'),
						reference: 'municipioCombo',
						name: 'municipioCodigo',
						padding: '5px',
		            	bind: {
		            		store: '{comboMunicipio}',
		            		//value: '{comprador.municipioCodigo}',
		            		disabled: '{!comprador.provinciaCodigo}'
		            	}
					},
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.telefono2'),
			        	name: 'telefono2',
			        	reference: 'telefono2',
			        	padding: '5px'/*,
			        	bind: {
		            		value: '{comprador.telefono2}'
		            	}*/
			        },
			        { 
			        	xtype:'numberfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.codigo.postal'),
			        	name: 'codigoPostal',
			        	reference: 'codigoPostal',
			        	padding: '5px'/*,
			        	bind: {
		            		value: '{comprador.codigoPostal}'
		            	}*/
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.email'),
			        	name: 'email',
			        	reference: 'email',
			        	padding: '5px'/*,
			        	bind: {
		            		value: '{comprador.email}'
		            	}*/
			        },
			        {
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.pais'),
						name: 'codigoPais',
						reference: 'pais',
						padding: '5px',
		            	bind: {
		            		store: '{comboPaises}',
		            		//value: '{comprador.codigoPais}',
		            		allowBlank: '{expediente.esObligatorio}'
		            	},
		            	listeners: {
							change: 'comprobarObligatoriedadRte'
						}
					},
			        {
			        	xtype      : 'container',
			        	layout: {
					        type: 'table',
					        columns: 2
						},
                       padding: '5px',
                       items: [
                       	{ 
								xtype: 'comboboxfieldbase',   
					        	fieldLabel: HreRem.i18n('title.windows.datos.cliente.ursus'),
								reference: 'seleccionClienteUrsus',
								
					        	bind: {
				            		store: '{comboClienteUrsus}',
				            		hidden: '{!comprador.esCarteraBankia}'
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
					            	hidden: '{!comprador.esCarteraBankia}'
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
				        name: 'numeroClienteUrsus',
				        padding: '5px',
				        bind: {
			            	//value: '{comprador.numeroClienteUrsus}',
			            	hidden: '{!comprador.mostrarUrsus}'
			            },
			            editable: true
                   },
                   
                   {
                   	xtype: 'textfieldbase', 
				        fieldLabel:  HreRem.i18n('header.numero.ursus.bh'),
				        reference: 'numeroClienteUrsusBhRef',
				        name: 'numeroClienteUrsusBh',
				        padding: '5px',
				        bind: {
			            	//value: '{comprador.numeroClienteUrsusBh}',
			            	hidden: '{!comprador.mostrarUrsusBh}'
			            },
			            editable: true
                   }
				]
      },
      {
			xtype:'fieldsettable',
			collapsible: false,
			defaultType: 'textfieldbase',
			margin: '10px 10px 10px 10px',
			title: HreRem.i18n('title.nexos'),
			layout: {
		        type: 'table',
		        columns: 2,
			    trAttrs: {width: '25%'},
		        tdAttrs: {width: '25%'}
			},
			items :
				[
					{ 
						xtype: 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.estado.civil'),
			        	name: 'codEstadoCivil',
						reference: 'estadoCivil',
						padding: '5px',
			        	bind: {
		            		store: '{comboEstadoCivil}'/*,
		            		value: '{comprador.codEstadoCivil}'*/
		            	},
		            	listeners: {
							change: 'comprobarObligatoriedadCamposNexos'
						},
		            	allowBlank:true
			        },
			        {
			        	xtype: 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.regimen.economico'),
			        	name: 'codigoRegimenMatrimonial',
						reference: 'regimenMatrimonial',
						padding: '5px',
			        	bind: {
		            		store: '{comboRegimenesMatrimoniales}'/*,
		            		value: '{comprador.codigoRegimenMatrimonial}'*/
		            	},
		            	listeners: {
		            		change: 'comprobarObligatoriedadCamposNexos'
		            	},
		            	allowBlank:true
			        },
			        { 
			        	xtype: 'comboboxfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.tipoDocumento'),
			        	reference: 'tipoDocConyuge',
			        	name: 'codTipoDocumentoConyuge',
			        	padding: '5px',
			        	bind: {
			        		store: '{comboTipoDocumento}'/*,
			        		value: '{comprador.codTipoDocumentoConyuge}'*/
		            	}
			        },
					{ 
			        	fieldLabel:  HreRem.i18n('fieldlabel.num.reg.conyuge'),
			        	reference: 'numRegConyuge',
			        	name: 'documentoConyuge',
			        	padding: '5px'/*,
			        	bind: {
		            		value: '{comprador.documentoConyuge}'
		            	}*/
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.relacion.hre'),
			        	reference: 'relacionHre',
			        	name: 'relacionHre',
			        	padding: '5px'/*,
			        	bind: {
		            		value: '{comprador.relacionHre}' 
		            	}*/
			        },
			        { 
			        	xtype: 'comboboxfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.antiguo.deudor'),
			        	reference: 'antiguoDeudor',
			        	name: 'antiguoDeudor',
			        	padding: '5px',
			        	bind: {
			        		store: '{comboSiNoRem}'/*,
			        		value: '{comprador.antiguoDeudor}'*/
		            	}
			        },
			        { 
			        	xtype: 'comboboxfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.relacion.ant.deudor'),
			        	reference: 'relacionAntDeudor',
			        	name: 'relacionAntDeudor',
			        	padding: '5px',
			        	bind: {
			        		store: '{comboSiNoRem}'/*,
			        		value: '{comprador.relacionAntDeudor}'*/
		            	}
			        }
				]
     },
     {
			xtype:'fieldsettable',
			collapsible: false,
			defaultType: 'textfieldbase',
			margin: '10px 10px 10px 10px',
			title: HreRem.i18n('title.datos.representante'),
			layout: {
		        type: 'table',
		        columns: 2,
			    trAttrs: {width: '25%'},
		        tdAttrs: {width: '25%'}
			},
			items :
				[
					{ 
						xtype: 'comboboxfieldbase',
			        	fieldLabel: HreRem.i18n('fieldlabel.tipoDocumento'),
			        	name: 'codTipoDocumentoRte',
						reference: 'tipoDocumentoRte',
						padding: '5px',
			        	bind: {
		            		store: '{comboTipoDocumento}'/*,
		            		value: '{comprador.codTipoDocumentoRte}'*/
		            	},
		            	listeners : {
		            		change: function(combo, value) {
		            			try{
		            			     var me = this;
		            			     if(value) {
		            				    me.up('formBase').down('[reference=numeroDocumentoRte]').allowBlank = false;
		            			     } else {
		            				    me.up('formBase').down('[reference=numeroDocumentoRte]').allowBlank = true;
		            				    me.up('formBase').down('[reference=numeroDocumentoRte]').setValue("");
		            			     }
		            			     }catch (err){
		            				    Ext.global.console.log(err);
		            			     }
		            		   }
		            	}
			        },
			        {
			        	fieldLabel: HreRem.i18n('fieldlabel.numero.documento'),
						reference: 'numeroDocumentoRte',
						name: 'numDocumentoRte',
						padding: '5px',
//			        	bind: {		
//		            		value: '{comprador.numDocumentoRte}'
//		            	},
		            	listeners : {
		            		change: function(combo, value) {
		            			try{
		            				var me = this;
			            			if(value) {
			            				me.up('formBase').down('[reference=tipoDocumentoRte]').allowBlank = false;
			            			} 
		            			}catch (err){
		            				Ext.global.console.log(err);
		            			}
		            			
		            		}
		            	}
         		},
					{ 
			        	fieldLabel:  HreRem.i18n('header.nombre.razon.social'),
			        	reference: 'nombreRazonSocialRte',
			        	name: 'nombreRazonSocialRte',
			        	padding: '5px'/*,
			        	bind: {
		            		value: '{comprador.nombreRazonSocialRte}' 
		            	}*/
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.apellidos'),
			        	reference: 'apellidosRte',
			        	name: 'apellidosRte',
			        	padding: '5px'/*,
			        	bind: {
		            		value: '{comprador.apellidosRte}'
		            	}*/
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.direccion'),
			        	name: 'direccionRte',
			        	reference: 'direccionRte',
			        	padding: '5px'/*,
			        	bind: {
		            		value: '{comprador.direccionRte}'
		            	}*/
			        },
			        {
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.provincia'),
						reference: 'provinciaComboRte',
						name: 'provinciaRteCodigo',
						chainedStore: 'comboMunicipioRte',
						chainedReference: 'municipioComboRte',
						padding: '5px',
		            	bind: {
		            		store: '{comboProvincia}'/*,
		            		value: '{comprador.provinciaRteCodigo}'*/
		            	},
						listeners: {
							change: 'onChangeComboProvincia'
						}
					},		        
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.telefono1'),
			        	reference: 'telefono1Rte',
			        	name: 'telefono1Rte',
			        	padding: '5px'/*,
			        	bind: {
		            		value: '{comprador.telefono1Rte}'
		            	}*/
			        },
			        {
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.municipio'),
						reference: 'municipioComboRte',
						name: 'municipioRteCodigo',
						padding: '5px',
		            	bind: {
		            		store: '{comboMunicipioRte}',
		            		//value: '{comprador.municipioRteCodigo}',
		            		disabled: '{!comprador.provinciaRteCodigo}'
		            	}
					},		        
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.telefono2'),
			        	reference: 'telefono2Rte',
			        	name: 'telefono2Rte',
			        	padding: '5px'/*,
			        	bind: {
		            		value: '{comprador.telefono2Rte}'
		            	}*/
			        },
			        { 
			        	xtype:'numberfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.codigo.postal'),
			        	reference: 'codigoPostalRte',
			        	name: 'codigoPostalRte',
			        	padding: '5px'/*,
			        	bind: {
		            		value: '{comprador.codigoPostalRte}'
		            	}*/
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.email'),
			        	reference: 'emailRte',
			        	name: 'emailRte',
			        	padding: '5px'/*,
			        	bind: {
		            		value: '{comprador.emailRte}'
		            	}*/
			        },
			        {
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.pais'),
						reference: 'paisRte',
						name: 'codigoPaisRte',
						padding: '5px',
		            	bind: {
		            		store: '{comboPaises}'/*,
		            		value: '{comprador.codigoPaisRte}'*/
		            	},
		            	listeners : {
		            		change: 'comprobarObligatoriedadRte'
		            	}
					}
				]
    }
     ]
    	me.callParent();  	
    },
    				 			
     resetWindow: function() {
    	var me = this;    	
		//me.setBindRecord(comprador);
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
    	
    	me = me.lookupController().getViewModel().get('expediente');
    	
    	var estadoExpediente = me.data.codigoEstado;
    	var solicitaReserva = me.data.solicitaReserva;
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