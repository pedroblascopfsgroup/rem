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
								xtype: 'comboboxfieldbase',
			                	fieldLabel:  HreRem.i18n('fieldlabel.situacion.contrato.alquiler'),
					        	bind: {
				            		store: '{comboSituacionContratoAlquiler}',
				            		value: '{expediente.situacionContratoAlquiler}'
				            	},
					            displayField: 'descripcion',
		    					valueField: 'codigo'
					        }
					        
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
						fieldLabel: HreRem.i18n('fieldlabel.fecha.alta.oferta'),
	                	bind:		'{expediente.fechaAltaOferta}',
	                	renderer: Ext.util.Format.dateRenderer('d-m-Y')
	                },
	                {
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.aceptacion'),
	                	bind:		'{expediente.fechaAlta}',
	                	renderer: Ext.util.Format.dateRenderer('d-m-Y')
	                },
	                {
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.sancion'),
	                	bind:		'{expediente.fechaSancion}',
	                	renderer: Ext.util.Format.dateRenderer('d-m-Y')
	                },
	                { 
						fieldLabel: HreRem.i18n('fieldlabel.fecha.reserva'),
	                	bind:		'{expediente.fechaReserva}',
	                	renderer: Ext.util.Format.dateRenderer('d-m-Y')
	                },
	                {
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.posicionamiento'),
	                	bind:		'{expediente.fechaPosicionamiento}'	  ,
	                	renderer: Ext.util.Format.dateRenderer('d-m-Y')
	                },
	                {
	                	fieldLabel: HreRem.i18n('fieldlabel.fecha.contabilizacion.propietario'),
	                	bind:		'{expediente.fechaContabilizacionPropietario}',
	                	renderer: Ext.util.Format.dateRenderer('d-m-Y')
	                }

				]
				
				
           },
           {    
                xtype:'fieldsettable',
				defaultType: 'displayfield',
				title: HreRem.i18n('title.anulacion'),
				items: [
						{
							fieldLabel: HreRem.i18n('fieldlabel.fecha.anulacion'),
							bind: '{expediente.fechaAnulacion}',
							renderer: Ext.util.Format.dateRenderer('d-m-Y')
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.motivo.anulacion'),
							bind: '{expediente.motivoAnulacion}',
							colspan: 2
						},	
						{
							fieldLabel: HreRem.i18n('fieldlabel.peticionario'),
							bind: '{expediente.peticionarioAnulacion}'
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.fecha.devolucion.entregas.a.cuenta'),
							bind: '{expediente.fechaDevolucionEntregas}',
							renderer: Ext.util.Format.dateRenderer('d-m-Y')
						},
						{
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
			            	},
			            	allowBlank: false
		                },
		                {
		                	xtype: 'comboboxfieldbase',
							reference: 'comboRiesgoReputacional',
		                	fieldLabel:  HreRem.i18n('fieldlabel.riesgo.reputacional'),
				        	bind: {
			            		store: '{comboSiNoRem}',
			            		value: '{expediente.riesgoReputacional}'
			            	},
			            	allowBlank: false
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