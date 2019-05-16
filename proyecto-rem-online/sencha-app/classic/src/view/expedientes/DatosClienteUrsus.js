Ext.define('HreRem.view.expedientes.DatosClienteUrsus', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'datosclienteursuswindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /3,    
    height	: Ext.Element.getViewportHeight() > 700 ? 700 : Ext.Element.getViewportHeight() - 50,
	reference: 'datosclienteursuswindowref',
//	y:Ext.Element.getViewportHeight()/20,
	x:Ext.Element.getViewportWidth() / 1.60,
    controller: 'expedientedetalle',
    viewModel: {
        type: 'expedientedetalle'
    },
    cls: '',//panel-base shadow-panel
    collapsed: false,
    modal	: false,
    idComprador: null,
    requires: ['HreRem.view.expedientes.ProblemasVentaClienteUrsus', 'HreRem.model.DatosClienteUrsus', 'HreRem.view.expedientes.ExpedienteDetalleModel'],
    
    clienteUrsus: null,
    storeProblemasVenta: null,
    
    initComponent: function() {
    	var me = this;
		var clienteUrsus= me.clienteUrsus;
		me.storeProblemasVenta.proxy.extraParams.numeroUrsus = me.clienteUrsus.numeroClienteUrsus;
		me.storeProblemasVenta.load();
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
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.numero.cliente.ursus'),
									value: clienteUrsus.numeroClienteUrsus
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.tipo.documento'),
									value: clienteUrsus.claseDeDocumentoIdentificador
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.num.documento.titular.oferta'),
									value: clienteUrsus.dniNifDelTitularDeLaOferta
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.nombre.apellidos.titular.oferta'),
									value: clienteUrsus.nombreYApellidosTitularDeOferta
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.nombre.cliente'),
									value: clienteUrsus.nombreDelCliente
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.primer.apellido'),
									value: clienteUrsus.primerApellido
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.segundo.apellido'),
									value: clienteUrsus.segundoApellido
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.tipo.via'),
									value: clienteUrsus.codigoTipoDeVia
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.nombre.via'),
									value: clienteUrsus.nombreDeLaVia
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.portal'),
									value: clienteUrsus.pORTAL
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.escalera'),
									value: clienteUrsus.eSCALERA
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.piso'),
									value: clienteUrsus.pISO
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.puerta'),
									value: clienteUrsus.numeroDePuerta
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.codigo.postal'),
									value: clienteUrsus.codigoPostal
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.municipio'),
									value: clienteUrsus.nombreDelMunicipio
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.provincia'),
									value: clienteUrsus.nombreDeLaProvincia
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.pais.domicilio'),
									value: clienteUrsus.nombreDelPaisDeNacimiento
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.datos.complementarios.domicilio'),
									value: clienteUrsus.datosComplementariosDelDomicilio
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.barrio'),
									value: clienteUrsus.barrioColoniaOApartado
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.edad.cliente'),
									value: clienteUrsus.edadDelCliente
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.estado.civil'),
									value: clienteUrsus.estadoCivilActual
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.num.hijos'),
									value: clienteUrsus.numeroDeHijos
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.sexo'),
									value: clienteUrsus.sEXO
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.nombre.comercial.empresa'),
									value: clienteUrsus.nombreComercialDeLaEmpresa
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.delegacion'),
									value: clienteUrsus.dELEGACION
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.tipo.sociedad'),
									value: clienteUrsus.tipoDeSociedad
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.situacion.cliente'),
									value: clienteUrsus.nombreDeLaSituacionDelCliente
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.fecha.nacimiento.constitucion'),
									value: clienteUrsus.fechaDeNacimientoOConstitucion
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.pais.nacimiento'),
									value: clienteUrsus.nombreDelPaisDeNacimiento
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.provincia.nacimiento'),
									value: clienteUrsus.nombreDeLaProvinciaNacimiento
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.poblacion.nacimiento'),
									value: clienteUrsus.nombreDePoblacionDeNacimiento
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.nacionalidad'),
									value: clienteUrsus.nombreDePaisNacionalidad
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.pais.residencia'),
									value: clienteUrsus.nombreDePaisResidencia
								},
								{ 
									xtype: 'displayfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.subsector.actividad.economica'),
									value: clienteUrsus.subsectorDeActividadEconomica
								},
								{
									xtype : 'problemasVentaClienteUrsus',
									store : me.storeProblemasVenta,
									dockedItems : [{
											xtype: 'pagingtoolbar',
											dock: 'bottom',
											displayInfo : true,
											store: me.storeProblemasVenta
									}],
									hidden: !clienteUrsus.hayOcurrencias
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