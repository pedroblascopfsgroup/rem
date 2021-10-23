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
			        		store: '{comboTipoPersona}'
		            		
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
		            		store: '{comboSiNoRem}'
		            	}
            		},
					{ 
            			xtype:'numberfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.porcion.compra'),
			        	reference: 'porcionCompra',
			        	name: 'porcentajeCompra',
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
		            		store: '{comboTipoGradoPropiedad}'
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
		            		store: '{comboTipoDocumento}'
		            	},
		            	allowBlank: false
			        },
			        
			        {  
			        	fieldLabel: HreRem.i18n('fieldlabel.numero.documento'),
			        	name: 'numDocumento',
						reference: 'numeroDocumento',
						padding: '5px',
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
		            	allowBlank: false
			        },
			        {   
			        	fieldLabel:  HreRem.i18n('fieldlabel.apellidos'),
			        	name: 'apellidos',
			        	reference: 'apellidos',
			        	padding: '5px',
		            	allowBlank: false
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.direccion'),
			        	name: 'direccion',
			        	reference: 'direccion',
			        	padding: '5px',
			        	bind: {
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
		            		store: '{comboProvincia}'
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
			        	padding: '5px'
			        },
			        
			       {
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.municipio'),
						reference: 'municipioCombo',
						name: 'municipioCodigo',
						padding: '5px',
						disabled: true,
		            	bind: {
		            		store: '{comboMunicipio}'
		            	}
					},
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.telefono2'),
			        	name: 'telefono2',
			        	reference: 'telefono2',
			        	padding: '5px'
			        },
			        {
			        	fieldLabel:  HreRem.i18n('fieldlabel.codigo.postal'),
			        	name: 'codigoPostal',
			        	reference: 'codigoPostal',
			        	padding: '5px',
			        	vtype: 'codigoPostal',
						maskRe: /^\d*$/, 
	                	maxLength: 5
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.email'),
			        	name: 'email',
			        	reference: 'email',
			        	padding: '5px'
			        },
			        {
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.pais'),
						name: 'codigoPais',
						reference: 'pais',
						padding: '5px',
		            	bind: {
		            		store: '{comboPaises}',
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
		            		store: '{comboEstadoCivil}'
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
		            		store: '{comboRegimenesMatrimoniales}'
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
			        	editable: true,
			        	allowBlank:true,
			        	padding: '5px',
			        	bind: {
			        		store: '{comboTipoDocumento}'
		            	},
		            	listeners: {
		            		change: 'comprobarObligatoriedadCamposNexos'										         
		            	}
			        },
					{ 
			        	fieldLabel:  HreRem.i18n('fieldlabel.num.reg.conyuge'),
			        	reference: 'numRegConyuge',
			        	name: 'documentoConyuge',
			        	padding: '5px',
		            	listeners: {
		            		change: 'comprobarObligatoriedadCamposNexos'										         
		            	}
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.relacion.hre'),
			        	reference: 'relacionHre',
			        	name: 'relacionHre',
			        	padding: '5px'
			        },
			        { 
			        	xtype: 'comboboxfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.antiguo.deudor'),
			        	reference: 'antiguoDeudor',
			        	name: 'antiguoDeudor',
			        	padding: '5px',
			        	bind: {
			        		store: '{comboSiNoRem}'
		            	}
			        },
			        { 
			        	xtype: 'comboboxfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.relacion.ant.deudor'),
			        	reference: 'relacionAntDeudor',
			        	name: 'relacionAntDeudor',
			        	padding: '5px',
			        	bind: {
			        		store: '{comboSiNoRem}'
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
		            		store: '{comboTipoDocumento}'
		            	},
		            	listeners : {
		            		change: 'comprobarObligatoriedadCamposNexos'
		            	}
			        },
			        {
			        	fieldLabel: HreRem.i18n('fieldlabel.numero.documento'),
						reference: 'numeroDocumentoRte',
						name: 'numDocumentoRte',
						padding: '5px',
		            	listeners : {
		            		change: 'comprobarObligatoriedadCamposNexos'
		            	}
         		},
					{ 
			        	fieldLabel:  HreRem.i18n('header.nombre.razon.social'),
			        	reference: 'nombreRazonSocialRte',
			        	name: 'nombreRazonSocialRte',
			        	padding: '5px'
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.apellidos'),
			        	reference: 'apellidosRte',
			        	name: 'apellidosRte',
			        	padding: '5px'
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.direccion'),
			        	name: 'direccionRte',
			        	reference: 'direccionRte',
			        	padding: '5px'
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
		            		store: '{comboProvincia}'
		            	},
						listeners: {
							change: 'onChangeComboProvincia'
						}
					},		        
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.telefono1'),
			        	reference: 'telefono1Rte',
			        	name: 'telefono1Rte',
			        	padding: '5px'
			        },
			        {
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.municipio'),
						reference: 'municipioComboRte',
						name: 'municipioRteCodigo',
						padding: '5px',
		            	bind: {
		            		store: '{comboMunicipioRte}',
		            		disabled: '{!comprador.provinciaRteCodigo}'
		            	}
					},		        
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.telefono2'),
			        	reference: 'telefono2Rte',
			        	name: 'telefono2Rte',
			        	padding: '5px'
			        },
			        {
			        	fieldLabel:  HreRem.i18n('fieldlabel.codigo.postal'),
			        	reference: 'codigoPostalRte',
			        	name: 'codigoPostalRte',
			        	padding: '5px',
			        	vtype: 'codigoPostal',
						maskRe: /^\d*$/, 
	                	maxLength: 5
			        },
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.email'),
			        	reference: 'emailRte',
			        	name: 'emailRte',
			        	padding: '5px'
			        },
			        {
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.pais'),
						reference: 'paisRte',
						name: 'codigoPaisRte',
						padding: '5px',
		            	bind: {
		            		store: '{comboPaises}'
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