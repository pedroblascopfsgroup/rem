Ext.define('HreRem.view.activos.detalle.DatosBasicosActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'datosbasicosactivo',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'datosbasicosactivo',
    scrollable	: 'y',

	recordName: "activo",
	
	recordClass: "HreRem.model.Activo",
    
    requires: ['HreRem.model.Activo'],
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.datos.basicos'));
        var items= [

			{   
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				
				title: HreRem.i18n('title.identificacion'),
				items :
					[
		                {
		                	xtype: 'displayfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.id.activo.haya'),
		                	bind:		'{activo.numActivo}'

		                },
						{ 
							xtype: 'displayfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.id.bien.recovery'),
							bind:		'{activo.idRecovery}'
						},
						{ 
		                	xtype: 'textareafieldbase',
		                	labelWidth: 200,
		                	rowspan: 4,
		                	height: 160,
		                	labelAlign: 'top',
		                	fieldLabel: HreRem.i18n('fieldlabel.breve.descripcion.activo'),
		                	bind:		'{activo.descripcion}'
		                },
						{
							xtype: 'displayfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.id.activo.prinex'),
							bind:		'{activo.idProp}'
						},
						{ 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel: HreRem.i18n('fieldlabel.tipo.activo'),
							reference: 'tipoActivo',
				        	chainedStore: 'comboSubtipoActivo',
							chainedReference: 'subtipoActivoCombo',
				        	bind: {
			            		store: '{comboTipoActivo}',
			            		value: '{activo.tipoActivoCodigo}'
			            	},
    						listeners: {
			                	select: 'onChangeChainedCombo'
			            	},
			            	allowBlank: false
				        },
						{
							xtype: 'displayfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.id.activo.sareb'),
			                bind:		'{activo.idSareb}'
						},
						{ 
							xtype: 'comboboxfieldbase',
				        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo.activo'),
				        	reference: 'subtipoActivoCombo',
				        	bind: {
			            		store: '{comboSubtipoActivo}',
			            		value: '{activo.subtipoActivoCodigo}',
			            		disabled: '{!activo.tipoActivoCodigo}'
			            	},
    						allowBlank: false
				        },			       
						{ 
							xtype: 'displayfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.id.activo.uvem'),
		                	bind:		'{activo.numActivoUvem}'
		                },
						{ 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel:  HreRem.i18n('fieldlabel.estado.fisico.activo'),
				        	name: 'estadoActivoCodigo',
				        	bind: {
			            		store: '{comboEstadoActivo}',
			            		value: '{activo.estadoActivoCodigo}'
			            	}			
				        },	
		                { 
		                	xtype: 'displayfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.id.activo.rem'),
		                	bind:		'{activo.numActivoRem}'
		                },
		                {
		                	xtype: 'comboboxfieldbase',
				        	fieldLabel:  HreRem.i18n('fieldlabel.uso.dominante'),
				        	name: 'tipoUsoDestinoCodigo',
		                	bind: {
			            		store: '{comboTipoUsoDestino}',
			            		value: '{activo.tipoUsoDestinoCodigo}'
			            	}
		                }
					]
           },
           
            {    
                
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.direccion'),
				items :
					[
						// fila 1
						{							
							xtype: 'comboboxfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.tipo.via'),
				        	bind: {
			            		store: '{comboTipoVia}',
			            		value: '{activo.tipoViaCodigo}'			            		
			            	},
    						allowBlank: false
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.provincia'),
							reference: 'provinciaCombo',
							chainedStore: 'comboMunicipio',
							chainedReference: 'municipioCombo',
			            	bind: {
			            		store: '{comboProvincia}',
			            	    value: '{activo.provinciaCodigo}'
			            	},
    						listeners: {
								select: 'onChangeChainedCombo'
    						},
    						allowBlank: false
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.latitud'),
							readOnly	: true,
							bind:		'{activo.latitud}'
		                },						
						// fila 2	
						
						{ 
							fieldLabel:  HreRem.i18n('fieldlabel.nombre.via'),
		                	bind:		'{activo.nombreVia}',
		                	allowBlank: false
		                },
		                {
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.municipio'),
							reference: 'municipioCombo',
							chainedStore: 'comboInferiorMunicipio',
							chainedReference: 'inferiorMunicipioCombo',
			            	bind: {
			            		store: '{comboMunicipio}',
			            		value: '{activo.municipioCodigo}',
			            		disabled: '{!activo.provinciaCodigo}'
			            	},
    						listeners: {
								select: 'onChangeChainedCombo'
    						},
    						allowBlank: false
						},
						{ 
							fieldLabel: HreRem.i18n('fieldlabel.longitud'),
							readOnly: true,
							bind:		'{activo.longitud}'
		                }, 
		                // fila 3               
		                { 
		                	fieldLabel: HreRem.i18n('fieldlabel.numero'),
		                	bind:		'{activo.numeroDomicilio}'
		                },
		                {
							xtype: 'comboboxfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.unidad.poblacional'),
							reference: 'inferiorMunicipioCombo',
			            	bind: {
			            		store: '{comboInferiorMunicipio}',
			            		value: '{activo.inferiorMunicipioCodigo}',
			            		disabled: '{!activo.municipioCodigo}'
			            	},
			            	tpl: Ext.create('Ext.XTemplate',
			            		    '<tpl for=".">',
			            		        '<div class="x-boundlist-item">{descripcion}</div>',
			            		    '</tpl>'
			            	),
			            	displayTpl: new Ext.XTemplate(
			            	        '<tpl for=".">' +
			            	        '{[typeof values === "string" ? values : values["descripcion"]]}' +
			            	        '</tpl>'
			            	)
						},
						{
		                	xtype: 'button',
		                	reference: 'botonVerificarDireccion',
		                	disabled: true,
		                	bind:{
		                		disabled: '{!editing}'
		                	},
		                	rowspan: 2,
		                	text: HreRem.i18n('btn.verificar.direccion'),
		                	handler: 'onClickVerificarDireccion'
		                	
		                },	
		                // fila 4
		                {
							fieldLabel:  HreRem.i18n('fieldlabel.escalera'),
			                bind:		'{activo.escalera}'
						},
				        { 
				        	xtype: 'comboboxfieldbase',
				        	fieldLabel:  HreRem.i18n('fieldlabel.comunidad.autonoma'),
				        	forceSelection: true,
				        	readOnly: true,
				        	bind: {		
				        		store: '{storeComunidadesAutonomas}',
			            		value: '{activo.provinciaCodigo}'
			            	},
							valueField: 'id',
							allowBlank: false
								
					     },					
						 // fila 5
 						{ 
		                	fieldLabel:  HreRem.i18n('fieldlabel.planta'),
		                	bind:		'{activo.piso}'
		                },	               
		                {
							xtype: 'comboboxfieldbase',
							reference: 'pais',
							fieldLabel: HreRem.i18n('fieldlabel.pais'),
			            	bind: {
			            		store: '{comboPais}',
			            		value: '{activo.paisCodigo}'
			            	},
    						colspan: 2,
    						allowBlank: false
		                	
						},
						// fila 6
						 { 
		                	fieldLabel:  HreRem.i18n('fieldlabel.puerta'),
		                	bind:		'{activo.puerta}'
		                },
		                {
							fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
							bind:		'{activo.codPostal}',
							colspan: 2,
							vtype: 'codigoPostal',
							maskRe: /^\d*$/, 
		                	maxLength: 5,
							allowBlank: false		                	
						}
												 
		               
					]               
          	},
          	// Perimetros -----------------------------------------------
            {    
                
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.perimetros'),
				items :
					[
					{
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.perimetro.incluido'),
						bind : '{activo.incluidoEnPerimetro}', 
						valueToRaw: function(value) { return Utils.rendererBooleanToSiNo(value); },
						readOnly	: true
					},
					{
						xtype: 'datefieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.perimetro.fecha.alta.activo'),
						colspan: 2,
						bind:		'{activo.fechaAltaActivoRem}',
						readOnly	: true
					},					
		            {    
		                
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.perimetros.condiciones'),
						border: true,
						colapsible: false,
						colspan: 3,
						items :
							[
							//Fila cabecera
							{
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.modulos.in.ex'),
								readOnly	: true
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.fecha.in.ex'),
								readOnly	: true
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.motivo.in.ex'),
								readOnly	: true
							},
							
							//Fila Admision
							{
								xtype:'checkboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.admision'),
								bind:		'{activo.aplicaTramiteAdmision}'
							},
							{
								xtype: 'datefieldbase',
								bind:		'{activo.fechaAplicaTramiteAdmision}'
							},
							{
								xtype: 'textfieldbase',
								bind:		'{activo.motivoAplicaTramiteAdmision}'
							},

							//Fila gestion
							{
								xtype:'checkboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.gestion'),
								bind:		'{activo.aplicaGestion}'
							},
							{
								xtype: 'datefieldbase',
								bind:		'{activo.fechaAplicaGestion}'
							},
							{
								xtype: 'textfieldbase',
								bind:		'{activo.motivoAplicaGestion}'
							},
							
							//Fila mediador
							{
								xtype:'checkboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.mediador'),
								bind:		'{activo.aplicaAsignarMediador}'
							},
							{
								xtype: 'datefieldbase',
								bind:		'{activo.fechaAplicaAsignarMediador}'
							},
							{
								xtype: 'textfieldbase',
								bind:		'{activo.motivoAplicaAsignarMediador}'
							},
							
							//Fila comercializar
							{
								xtype:'checkboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.comercial'),
								bind:		'{activo.aplicaComercializar}'
							},
							{
								xtype: 'datefieldbase',
								bind:		'{activo.fechaAplicaComercializar}'
							},
							{
								xtype: 'comboboxfieldbase',
								bind: {
									store: '{comboMotivoAplicaComercializarActivo}',
									value: '{activo.motivoAplicaComercializarCodigo}',
									visible: '{activo.aplicaComercializar}'
								}
							},
							{
								xtype: 'comboboxfieldbase',
								visible: false,
								bind: {
									store: '{comboMotivoNoAplicaComercializarActivo}',
									value: '{activo.motivoNoAplicaComercializarCodigo}',
									visible: '{!activo.aplicaComercializar}'
								}
							},
							//Fila formalizar
							{
								xtype:'checkboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.check.formalizar'),
								bind:		'{activo.aplicaFormalizar}'
							},
							{
								xtype: 'datefieldbase',
								bind:		'{activo.fechaAplicaFormalizar}'
							},
							{
								xtype: 'textfieldbase',
								bind:		'{activo.motivoAplicaFormalizar}'
							},
							
							//Otros
							{
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.perimetro.tipo.comercializacion'),
								bind: {
									store: '{comboTipoComercializacionActivo}',
									value: '{activo.tipoComercializacionCodigo}'
								}
							},
							{
								xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('title.publicaciones.estadoDisponibilidadComercial'),
								bind : '{activo.situacionComercialDescripcion}', 
								readOnly	: true
							}	
						]
					}, //Fin condiciones
					//Datos bancarios
		            {    
		                
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.bancario'),
						border: true,
						colapsible: false,
						colspan: 3,
						items :
							[
							{
								xtype:'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.clase'),
								reference: 'claseActivoBancarioCombo',
					        	chainedStore: 'comboSubtipoClaseActivoBancario',
								chainedReference: 'subtipoClaseActivoBancarioCombo',
								bind: {
									store: '{comboClaseActivoBancario}',
									value: '{activo.claseActivoCodigo}'
								},
	    						listeners: {
				                	select: 'onChangeChainedCombo'
				            	},
								allowBlank: false
							},
							{
								xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.expediente.num'),
								bind: '{activo.numExpRiesgo}'
							},
							{
								xtype:'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.producto.tipo'),
								bind: {
									store: '{comboTipoProductoBancario}',
									value: '{activo.tipoProductoCodigo}'
								}
							},
							{
								xtype:'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.subtipo'),
								reference: 'subtipoClaseActivoBancarioCombo',
								bind: {
									store: '{comboSubtipoClaseActivoBancario}',
									value: '{activo.subtipoClaseActivoCodigo}',
									disabled: '{!activo.claseActivoCodigo}'
								}
							},
							{
								xtype:'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.expediente.estado'),
								bind: {
									store: '{comboEstadoExpRiesgoBancario}',
									value: '{activo.estadoExpRiesgoCodigo}'
								}
							},
							{
								xtype:'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.bancario.incorriente.estado'),
								bind: {
									store: '{comboEstadoExpIncorrienteBancario}',
									value: '{activo.estadoExpIncorrienteCodigo}'
								}
							}
						]
						
					} //Fin activo bancario
				]
			} //Fin perimetros
            
     ];
	me.addPlugin({ptype: 'lazyitems', items: items });
    me.callParent();    	
    	
    },
    
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;		
		me.lookupController().cargarTabData(me);
    	
    },
    
    actualizarCoordenadas: function(latitud, longitud) {
    	var me = this;
    	
    	me.getBindRecord().set("longitud", longitud);
    	me.getBindRecord().set("latitud", latitud);
    	
    }
});