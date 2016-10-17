Ext.define('HreRem.view.expedientes.DatosClienteUrsus', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'datosclienteursuswindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /3,    
    height	: Ext.Element.getViewportHeight() > 700 ? 700 : Ext.Element.getViewportHeight() - 50,
	reference: 'datosclienteursuswindowref',
//	y:Ext.Element.getViewportHeight()/20,
	x:Ext.Element.getViewportWidth() / 1.7,
    controller: 'expedientedetalle',
    viewModel: {
        type: 'expedientedetalle'
    },
    cls: '',//panel-base shadow-panel
    collapsed: false,
    modal	: false,
    idComprador: null,
    
    
    clienteUrsus: null,
	
    initComponent: function() {
    	var me = this;
		var clienteUrsus= me.clienteUrsus;
    	me.setTitle(HreRem.i18n("title.windows.datos.cliente.ursus"));
    	
    	me.buttonAlign = 'right'; 
   		me.buttons = [ { itemId: 'btnCerrar', text: HreRem.i18n('btn.cerrarBtnText'), handler: 'onClickBotonCerrarClienteUrsus'}];

    	me.items = [
    		{
	    		xtype: 'formBase', 
	    		collapsed: false,
	   			scrollable	: 'y',
	    		cls:'',
    			items: [
        			{    
				    	          
						xtype:'fieldsettable',
						collapsible: false,
						defaultType: 'textfieldbase',
						margin: '10 10 10 10',
						layout: {
							type: 'table',
							columns: 1,
							tdAttrs: {width: '50%'}
						},
						items :
							[
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.tipo.documento'),
									value: clienteUrsus.claseDeDocumentoIdentificador
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.num.documento.titular.oferta'),
									value: clienteUrsus.dniNifDelTitularDeLaOferta
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.nombre.apellidos.titular.oferta'),
									value: clienteUrsus.nombreYApellidosTitularDeOferta
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.nombre.cliente'),
									value: clienteUrsus.nombreDelCliente
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.primer.apellido'),
									value: clienteUrsus.primerApellido
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.segundo.apellido'),
									value: clienteUrsus.segundoApellido
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.tipo.via'),
									value: clienteUrsus.codigoTipoDeVia
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.nombre.via'),
									value: clienteUrsus.nombreDeLaVia
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.portal'),
									value: clienteUrsus.pORTAL
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.escalera'),
									value: clienteUrsus.eSCALERA
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.piso'),
									value: clienteUrsus.pISO
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.puerta'),
									value: clienteUrsus.numeroDePuerta
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.codigo.postal'),
									value: clienteUrsus.codigoPostal
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.municipio'),
									value: clienteUrsus.nombreDelMunicipio
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.provincia'),
									value: clienteUrsus.nombreDeLaProvincia
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.pais.domicilio'),
									value: clienteUrsus.nombreDelPaisDeNacimiento
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.datos.complementarios.domicilio'),
									value: clienteUrsus.datosComplementariosDelDomicilio
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.barrio'),
									value: clienteUrsus.barrioColoniaOApartado
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.edad.cliente'),
									value: clienteUrsus.edadDelCliente
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.estado.civil'),
									value: clienteUrsus.estadoCivilActual
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.num.hijos'),
									value: clienteUrsus.numeroDeHijos
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.sexo'),
									value: clienteUrsus.sEXO
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.nombre.comercial.empresa'),
									value: clienteUrsus.nombreComercialDeLaEmpresa
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.delegacion'),
									value: clienteUrsus.dELEGACION
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.tipo.sociedad'),
									value: clienteUrsus.tipoDeSociedad
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.situacion.cliente'),
									value: clienteUrsus.nombreDeLaSituacionDelCliente
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.fecha.nacimiento.constitucion'),
									value: clienteUrsus.fechaDeNacimientoOConstitucion
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.pais.nacimiento'),
									value: clienteUrsus.nombreDelPaisDeNacimiento
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.provincia.nacimiento'),
									value: clienteUrsus.nombreDeLaProvinciaNacimiento
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.poblacion.nacimiento'),
									value: clienteUrsus.nombreDePoblacionDeNacimiento
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.nacionalidad'),
									value: clienteUrsus.nombreDePaisNacionalidad
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.pais.residencia'),
									value: clienteUrsus.nombreDePaisResidencia
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.subsector.actividad.economica'),
									value: clienteUrsus.subsectorDeActividadEconomica
								}
								
							]
					}
						
        		]
    		}
    	]

    	me.callParent();    	
    
    },
    
     resetWindow: function() {
    	var me = this,    	
    	form = me.down('formBase');
		form.setBindRecord(comprador);
	
    }

});