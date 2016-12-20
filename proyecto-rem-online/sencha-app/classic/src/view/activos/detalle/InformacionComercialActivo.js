Ext.define('HreRem.view.activos.detalle.InformacionComercialActivo', {
    extend			: 'HreRem.view.common.FormBase',
    xtype			: 'informacioncomercialactivo',    
    cls				: 'panel-base shadow-panel',
    collapsed		: false,
    disableValidation: true,
    reference		: 'informacioncomercialactivoref',
    scrollable		: 'y',
	recordName		: "infoComercial",
	recordClass		: "HreRem.model.ActivoInformacionComercial",
    requires		: ['HreRem.view.common.FieldSetTable', 'HreRem.model.ActivoInformacionComercial', 'HreRem.model.Distribuciones'],

    listeners: {
    	boxready: function() {
    		var me = this;

	    	me.lookupController().cargarTabData(me);
    	}
    },

    initComponent: function () {
        var me = this;

        me.setTitle(HreRem.i18n('title.informacion.comercial'));

        var items= [
			{    
				xtype:'fieldsettable',
				title:HreRem.i18n('title.mediador'),
				defaultType: 'textfieldbase',
				items :
					[
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.nombre'),
							bind: '{infoComercial.nombreMediador}',
							readOnly: true
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.telefono'),
							bind: '{infoComercial.telefonoMediador}',
							readOnly: true
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.email'),
							bind: '{infoComercial.emailMediador}',
							readOnly: true
						}
					]
			},
			{    
				xtype:'fieldsettable',
				title:HreRem.i18n('title.estado.informe.comercial'),
				defaultType: 'datefieldbase',
				items :
					[
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.fecha.emision'),
							bind: '{infoComercial.fechaEmisionInforme}',
							readOnly: true
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.fecha.rechazo'),
							bind: '{infoComercial.fechaRechazo}',
							readOnly: true
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.fecha.aceptacion'),
							bind: '{infoComercial.fechaAceptacion}',
							readOnly: true
						}
					]
			},
			{
				xtype:'fieldsettable',
				title:HreRem.i18n('title.informacion.general'),
				defaultType: 'textfieldbase',
				items :
					[
						{ 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.ubicacion'),
				        	bind: {
			            		store: '{comboTipoUbicacion}',
			            		value: '{infoComercial.ubicacionActivoCodigo}'
			            	},
			            	displayField: 'descripcion',
    						valueField: 'codigo',
							readOnly: true
				        },
						{
				        	xtype: 		'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.descripcion.comercial'),
					 		height: 	200,
					 		maxWidth:   550,
					 		rowspan:	5,
			            	bind:		'{infoComercial.descripcionComercial}',
							readOnly: true,
					 		labelAlign: 'top'
						},
						{ 
							xtype: 		'textareafieldbase',
					 		fieldLabel: HreRem.i18n('fieldlabel.propuesta.activos.vinculados'),
					 		height: 	200,
					 		width: '100%',
					 		rowspan:	5,
			            	bind:		'{infoComercial.activosVinculados}',
							readOnly: true,
					 		labelAlign: 'top'
						},
						{ 
				        	xtype: 'comboboxfieldbase',
				        	editable: false,
				        	fieldLabel: HreRem.i18n('fieldlabel.estado.construccion'),
				        	bind: {
			            		store: '{comboEstadoConstruccion}',
			            		value: '{infoComercial.estadoConstruccionCodigo}',
			    				hidden: '{infoComercial.isSuelo}'
			            	},
			            	displayField: 'descripcion',
    						valueField: 'codigo',
							readOnly: true
				        },
		                { 
				        	xtype: 'comboboxfieldbase',
				        	editable: false,
				        	fieldLabel: HreRem.i18n('fieldlabel.estado.conservacion'),
				        	bind: {
			            		store: '{comboEstadoConservacion}',
			            		value: '{infoComercial.estadoConservacionCodigo}'
			            	},
			            	displayField: 'descripcion',
    						valueField: 'codigo',
							readOnly: true
				        },
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.anyo.construccion'),
		                	bind: {
		                		value: '{infoComercial.anyoConstruccion}',
			    				hidden: '{infoComercial.isSuelo}'
		                	},
							maskRe: /^\d*$/,
							vtype: 'anyo',
							readOnly: true
		                },
		                { 
					 		fieldLabel: HreRem.i18n('fieldlabel.anyo.rehabilitacion'),
					 		bind: {
		                		value: '{infoComercial.anyoRehabilitacion}',
			    				hidden: '{infoComercial.isSuelo}'
		                	},
							maskRe: /^\d*$/,
							vtype: 'anyo',
							readOnly: true
						}/*,
						{ 
				        	xtype: 'comboboxfieldbase',
				        	editable: false,
				        	fieldLabel:  HreRem.i18n('fieldlabel.apto.valla.publicitaria'),
				        	width: 		220,
				        	bind: {
			            		store: '{comboSiNoRem}',
			            		value: '{infoComercial.aptoPublicidad}'			            		
			            	},
			            	displayField: 'descripcion',
    						valueField: 'codigo'
				        }*/
					 ]
            },
            {
				xtype:'fieldset',
				collapsible: true,
				width: '100%',
				layout: {
			        type: 'hbox',
			       	align: 'stretch'
			    },
				title:HreRem.i18n('title.edificio.ubica.activo'),
				items :
					[	{
							xtype: 'container',
							layout: {type: 'vbox'},
							defaultType: 'textfieldbase',
							width: '33%',
							items: [
								{ 
						        	xtype: 'comboboxfieldbase',
						        	editable: false,
						        	fieldLabel: HreRem.i18n('fieldlabel.estado.conservacion'),
						        	bind: {
					            		store: '{comboEstadoConservacion}',
					            		value: '{infoComercial.estadoConservacionEdificioCodigo}'			            		
					            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo',
									readOnly: true
						        },						        
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.anyo.rehabilitacion'),
									vtype: 		'anyo',
				                	bind:		'{infoComercial.anyoRehabilitacionEdificio}',
									readOnly: true
				                },
				                { 
							 		fieldLabel: HreRem.i18n('fieldlabel.numero.plantas'),
							 		maxLength:	3,
					            	bind:		'{infoComercial.numPlantas}',
									readOnly: true
								},
								{ 
						        	xtype: 'comboboxfieldbase',
						        	editable: false,
						        	fieldLabel:  HreRem.i18n('fieldlabel.ascensor'),
						        	bind: {
					            		store: '{comboSiNoRem}',
					            		value: '{infoComercial.ascensor}'			            		
					            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo',
									readOnly: true
						        },
				                { 
							 		fieldLabel: HreRem.i18n('fieldlabel.numero.ascensores'),
					            	maxLength:	2,
					            	bind:		'{infoComercial.numAscensores}',
									readOnly: true
								},
								{ 
						        	xtype: 'comboboxfieldbase',
						        	editable: false,
						        	fieldLabel: HreRem.i18n('fieldlabel.material.fachada'),
						        	bind: {
					            		store: '{comboTipoFachada}',
					            		value: '{infoComercial.tipoFachadaCodigo}'			            		
					            	},
					            	displayField: 'descripcion',
		    						valueField: 'codigo',
									readOnly: true
						        }
	            			]
						},
		                { 
			        	    xtype:'fieldset',
			        	    margin: '0 15 10 5',	
			        	    width: '33%',
							defaultType: 'textfieldbase',
							title: HreRem.i18n('title.reformas.necesarias'),
							items :
							[
					 			 {
					 				 xtype: 'checkboxfieldbase',
					 				 fieldLabel: 'Fachada',
					 				 bind: '{infoComercial.reformaFachada}',
									 readOnly: true
					 			 },
					 			{
					 				 xtype: 'checkboxfieldbase',
					 				 fieldLabel: 'Escalera',
					 				 bind: '{infoComercial.reformaEscalera}',
									 readOnly: true
					 			 },
					 			 {
					 				 xtype: 'checkboxfieldbase',
					 				 fieldLabel: 'Portal',
					 				 bind: '{infoComercial.reformaPortal}',
									 readOnly: true
					 			 },
					 			 {
					 				 xtype: 'checkboxfieldbase',
					 				 fieldLabel: 'Ascensor',
					 				 bind: '{infoComercial.reformaAscensor}',
									 readOnly: true
					 			 },
					 			 {
					 				 xtype: 'checkboxfieldbase',
					 				 fieldLabel: 'Cubierta',
					 				 bind: '{infoComercial.reformaCubierta}',
									 readOnly: true
					 			 },
					 			 {
					 				 fieldLabel: 'Otras zonas comunes',
					 				 bind: '{infoComercial.reformaOtroDescEdificio}',
									 readOnly: true
					 			 }
					 		]
						},
						{ 
							xtype: 		'textareafieldbase',
							margin: '0 5 10 0',
							flex: 1,
							maxWidth: 550,
							fieldLabel: HreRem.i18n('fieldlabel.descripcion.edificio'),
		                	bind:		'{infoComercial.ediDescripcion}',
							readOnly: true,
					 		labelAlign: 'top'
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
    }
});