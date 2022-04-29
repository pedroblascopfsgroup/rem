Ext.define('HreRem.view.configuracion.administracion.proveedores.detalle.DatosContacto', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'datoscontacto',
    reference: 'datosContactoRef',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    scrollable	: 'y',
    recordName: "datosContacto",
	recordClass: "HreRem.model.DatosContactoModel",
    requires: ['HreRem.model.DatosContactoModel', 'HreRem.view.common.ItemSelectorBase',
               'HreRem.view.configuracion.administracion.proveedores.detalle.DireccionesDelegacionesList',
               'HreRem.view.configuracion.administracion.proveedores.detalle.PersonasContactoList'],
    initComponent: function () {
        var me = this;
        
        me.setTitle(HreRem.i18n('title.datos.contacto'));
        
        me.items= [
					// Fila 0 (Direcciones y Delegaciones)
					 {
						 xtype:'fieldsettable',
							defaultType: 'textfieldbase',						
							title: HreRem.i18n('title.direcciones.delegaciones'),
							collapsible: true,
							colspan: 3,
							items :
								[
								 {
									 xtype: 'direccionesdelegacioneslist',
									 reference: 'gridDelegacionesRef',
									 colspan: 3,
									 flex: 3
								 },
					             {
									 xtype : 'comboboxfieldbasedd',
									 fieldLabel: HreRem.i18n('fieldlabel.proveedor.linea.negocio'),
									 reference: 'cbLineaNegocio',
								     bind : {
								       store : '{comboLineaDeNegocio}',
								       value : '{datosContacto.tipoLineaDeNegocioCodigo}',
									   rawValue : '{datosContacto.tipoLineaDeNegocioDescripcion}'
								     }
								},
								{
									 xtype : 'comboboxfieldbasedd',
									 fieldLabel: HreRem.i18n('fieldlabel.proveedor.clientes.no.residentes'),
									 reference: 'cbGestionClientes',
								     bind : {
								       store : '{comboSinSino}',
								       value : '{datosContacto.gestionClientesCodigo}',
									   rawValue : '{datosContacto.gestionClientesDescripcion}'
								     }
								},
					            {
									xtype: 'numberfieldbase',
						        	fieldLabel:  HreRem.i18n('fieldlabel.proveedor.numero.comerciales'),				        	
						        	bind: { 
						        		value: '{datosContacto.numeroComerciales}'
						        	}
									
						        },
						        {
						        	xtype: 'itemselectorbase',
									fieldLabel: HreRem.i18n('fieldlabel.provincia'),
									reference: 'provinciaCombo',
									chainedStore: 'comboMunicipioDatosContacto',
									chainedReference: 'municipioCombo',
					            	bind: {
					            		store: '{comboProvincia}',
					            	    value: '{datosContacto.provinciaCodigo}',
										rawValue: '{datosContacto.provinciaDescripcion}'
					            	},
		    						listeners: {
										select: 'onChangeChainedCombo',
										change: 'onChangeProvincia'

		    						}
								},
								{
									xtype: 'itemselectorbase',
									fieldLabel: HreRem.i18n('fieldlabel.municipio'),
									reference: 'municipioCombo',
									chainedStore: 'comboCodigoPostalDatosContacto',
									chainedReference: 'codigoPostalCombo',
					            	bind: {
					            		store: '{comboMunicipioDatosContacto}',
					            		value: '{datosContacto.municipioCodigo}',
					            		disabled: '{!datosContacto.provinciaDescripcion}',
										rawValue: '{datosContacto.municipioDescripcion}'
					            	},
		    						listeners: {
										select: 'onChangeChainedCombo'
		    						}
								},
								{
									xtype: 'itemselectorbase',
									fieldLabel: HreRem.i18n('fieldlabel.codigopostal'),
									reference: 'codigoPostalCombo',
					            	bind: {
					            		store: '{comboCodigoPostalDatosContacto}',
					            		value: '{datosContacto.codigoPostalCodigo}',
					            		disabled: '{!datosContacto.municipioDescripcion}',
										rawValue: '{datosContacto.codigoPostalDescripcion}'
					            	},
		    						listeners: {
										select: 'onChangeChainedCombo'
		    						}
								},
						        {
								    xtype: 'itemselectorbase',
								    reference: 'itemselEspecialidad',
								    fieldLabel: HreRem.i18n('fieldlabel.proveedor.especialidad'),
								    store: {
						            	model: 'HreRem.model.ComboBase',
										proxy: {
											type: 'uxproxy',
											remoteUrl: 'generic/getDiccionario',
											extraParams: {diccionario: 'especialidad'}
										},
										autoLoad: true
						            },									   
								    bind: {
								    	value: '{datosContacto.especialidadCodigo}'
								    }
								   
								},
								{
								    xtype: 'itemselectorbase',
								    reference: 'itemselIdiomas',
								    fieldLabel: HreRem.i18n('fieldlabel.proveedor.idiomas'),
								    store: {
						            	model: 'HreRem.model.ComboBase',
										proxy: {
											type: 'uxproxy',
											remoteUrl: 'generic/getDiccionario',
											extraParams: {diccionario: 'idioma'}
										},
										autoLoad: true
						            },
								    bind: {
								    	value: '{datosContacto.idiomaCodigo}'
								    }
								}
								]
					 },
					// Fila 1 (Personas de Contacto)
					 {
						 xtype:'fieldsettable',
							defaultType: 'textfieldbase',						
							title: HreRem.i18n('title.personas.contacto'),
							collapsible: true,
							colspan: 3,
							items :
								[
								 {xtype: 'personascontactolist'}
								]
					 }
        ];
        
    	me.callParent();
    },
    
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabDataDelegacion(me);

    }
});