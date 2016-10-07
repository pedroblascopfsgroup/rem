Ext.define('HreRem.view.expedientes.DatosBasicosExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'datosbasicosexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'datosbasicosactivo',
    scrollable	: 'y',
	recordName: "expediente",
	
	recordClass: "HreRem.model.ExpedienteComercial",
    
    requires: ['HreRem.model.ExpedienteComercial'],
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.ficha'));
        var items= [

			{   
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',				
				title: HreRem.i18n('title.identificacion'),
				items :
					[
		                {
		                	xtype: 'displayfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.num.expediente'),
		                	bind:		'{expediente.numExpediente}'

		                },						
						{
							xtype: 'displayfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.cartera'),
							bind:		'{expediente.entidadPropietariaDescripcion}'
						},						
						{
							xtype: 'displayfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.propietario'),
			                bind:		'{expediente.propietario}'
						},		       
						{ 
							xtype: 'displayfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
		                	bind:		'{expediente.tipoExpedienteDescripcion}'
		                },		                
		                { 
							xtype: 'displayfieldbase',
							fieldLabel:  HreRem.i18n('fiedlabel.numero.activo.agrupacion'),
		                	bind:		'{expediente.numEntidad}'
		                }
						
					]
           },
           {   
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',				
				title: HreRem.i18n('title.titulo.alquiler'),
				layout: {
					type: 'table',
					columns: 1
				},
				bind: {
					hidden: '{esOfertaVentaFicha}',
					disabled: '{esOfertaVentaFicha}'
			    },
				items :
					[
		                {   
						xtype:'fieldsettable',
						collapsible: false,
						border: false,
						defaultType: 'displayfieldbase',				
						items : [
						
							{
				        		xtype:'datefieldbase',
								formatter: 'date("d/m/Y")',
					        	fieldLabel: HreRem.i18n('fieldlabel.fecha.inicio'),
					        	bind: '{expediente.fechaInicioAlquiler}'					        						        	
					        },
					        {
				        		xtype:'datefieldbase',
								formatter: 'date("d/m/Y")',
					        	fieldLabel: HreRem.i18n('fieldlabel.fecha.fin'),
					        	bind: '{expediente.fechaFinAlquiler}'					        						        	
					        },
					        {
					        	
					        },
					        { 
								xtype: 'numberfieldbase',
								symbol: HreRem.i18n("symbol.euro"),
								fieldLabel: HreRem.i18n('fieldlabel.importe.renta.alquiler'),
				                bind: '{expediente.importeRentaAlquiler}'
							},
							{ 
								xtype: 'textfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.numero.contrato.alquiler'),
					        	bind: '{expediente.numContratoAlquiler}'
					        },
					        { 
								xtype: 'textfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.situacion.contrato.alquiler'),
					        	value: 'COMBO NO DEFINIDO'
					        }
//							{ 
//								xtype: 'comboboxfieldbase',
//			                	fieldLabel:  HreRem.i18n('fieldlabel.situacion.contrato.alquiler'),
//					        	bind: {
//				            		store: '{comboSituacionContratoAlquiler}',
//				            		value: '{expediente.situacionContratoAlquiler}'
//				            		//value: '{expediente.situacionContratoAlquiler}'
//				            	},
//					            displayField: 'descripcion',
//		    					valueField: 'codigo'
//					        }
					        
				        ]
					},
					{   
						xtype:'fieldsettable',
						collapsible: false,
						defaultType: 'displayfieldbase',				
						title: HreRem.i18n('title.opcion.compra.alquiler'),
						items : [
					        {
				        		xtype:'datefieldbase',
								formatter: 'date("d/m/Y")',
					        	fieldLabel: HreRem.i18n('fieldlabel.plazo.opcion.compra.alquiler'),
					        	bind: '{expediente.fechaPlazoOpcionCompraAlquiler}'					        						        	
					        },
							{ 
								xtype: 'numberfieldbase',
								symbol: HreRem.i18n("symbol.euro"),
								fieldLabel: HreRem.i18n('fieldlabel.prima.opcion.compra.alquiler'),
				                bind: '{expediente.primaOpcionCompraAlquiler}'
							},
							{ 
								xtype: 'numberfieldbase',
								symbol: HreRem.i18n("symbol.euro"),
								fieldLabel: HreRem.i18n('fieldlabel.precio.opcion.compra.alquiler'),
				                bind: '{expediente.precioOpcionCompraAlquiler}'
							},
							
					       	{ 
			                	xtype: 'textareafieldbase',
			                	labelWidth: 200,
			                	height: 160,
			                	labelAlign: 'top',
			                	fieldLabel: HreRem.i18n('fieldlabel.condiciones.opcion.compra.alquiler'),
			                	bind:		'{expediente.condicionesOpcionCompraAlquiler}'
			                }    
					        
				        ]
					}
						
					]
           },
           {    
                xtype:'fieldsettable',
				defaultType: 'displayfield',
				title: HreRem.i18n('title.tramite.expediente'),
				items: [
					{ 
						xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('fieldlabel.fecha.alta.oferta'),
	                	bind:		'{expediente.fechaAltaOferta}',
	                	maxValue: null
	                },
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.aceptacion'),
	                	bind:		'{expediente.fechaAlta}',
	                	maxValue: null
	                },
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.sancion'),
	                	bind:		'{expediente.fechaSancion}',
	                	maxValue: null
	                },
	                { 
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
						fieldLabel: HreRem.i18n('fieldlabel.fecha.reserva'),
	                	bind:		'{expediente.fechaReserva}',
	                	maxValue: null
	                },
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.posicionamiento'),
	                	bind:		'{expediente.fechaPosicionamiento}',
	                	maxValue: null
	                },
	                {
	                	xtype:'datefieldbase',
						formatter: 'date("d/m/Y")',
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.contabilizacion.propietario'),
	                	bind:		'{expediente.fechaContabilizacionPropietario}',
	                	maxValue: null
	                }

				]
				
				
           },
           {    
                xtype:'fieldsettable',
				defaultType: 'displayfield',
				title: HreRem.i18n('title.anulacion'),
				items: [
						{
							xtype:'datefieldbase',
							formatter: 'date("d/m/Y")',
							fieldLabel: HreRem.i18n('fieldlabel.fecha.anulacion'),
							bind: '{expediente.fechaAnulacion}',
							maxValue: null
						},
						{
							xtype: 'textfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.motivo.anulacion'),
							bind: '{expediente.motivoAnulacion}',
							colspan: 2
						},	
						{
							xtype: 'textfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.peticionario'),
							bind: '{expediente.peticionarioAnulacion}'
						},
						{
							xtype:'datefieldbase',
							formatter: 'date("d/m/Y")',
							fieldLabel: HreRem.i18n('fieldlabel.fecha.devolucion.entregas.a.cuenta'),
							bind: '{expediente.fechaDevolucionEntregas}',
							maxValue: null
						},
						{
							xtype: 'numberfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.importe.devolucion'),
							bind: '{expediente.importeDevolucionEntregas}'
						}
						
				
				]
				
           },
           {
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.politica.corporativa'),
				items :
					[
						{
		                	xtype: 'comboboxfieldbase',
							reference: 'comboConflictoIntereses',
		                	fieldLabel:  HreRem.i18n('fieldlabel.conflicto.intereses'),
				        	bind: {
			            		store: '{comboSiNoRem}',
			            		value: '{expediente.conflictoIntereses}'
			            	}
		                },
		                {
		                	xtype: 'comboboxfieldbase',
							reference: 'comboRiesgoReputacional',
		                	fieldLabel:  HreRem.i18n('fieldlabel.riesgo.reputacional'),
				        	bind: {
			            		store: '{comboSiNoRem}',
			            		value: '{expediente.riesgoReputacional}'
			            	}
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