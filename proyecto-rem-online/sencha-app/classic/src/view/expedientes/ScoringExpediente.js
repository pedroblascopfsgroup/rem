Ext.define('HreRem.view.expedientes.ScoringExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'scoringexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'scoringexpediente',
    scrollable	: 'y',
	recordName: "expediente",
	
	recordClass: "HreRem.model.ExpedienteComercial",
    
    requires: ['HreRem.model.ExpedienteComercial'],
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.scoring'));
        var items= [

			{   
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',				
				title: HreRem.i18n('fieldlabel.bloque.detalle'),
				items :
					[
		                
		                { 
		                	xtype:'comboboxfieldbase',
							fieldLabel:HreRem.i18n('fieldlabel.estado'),
							cls: 'cabecera-info-field',
							bind :{ 
									store :'{comboEstadoScoring}'
							}
		                },
		                { 
							xtype: 'textfieldbase',
		                	fieldLabel:HreRem.i18n('fieldlabel.motivo.rechazo'),
				        	readOnly: false
				        },
				        { 
							xtype: 'textfieldbase',
		                	fieldLabel: HreRem.i18n('fieldlabel.numero.solicitud'),
				        	readOnly: true
				        },
				        { 
							xtype: 'checkboxfield',
		                	name : HreRem.i18n('fieldlabel.revision'),
		                	fieldLabel: HreRem.i18n('fieldlabel.revision'),
				        	readOnly: false
				        },
				        { 
							xtype: 'textfieldbase',
		                	fieldLabel: HreRem.i18n('fieldlabel.aseguradoras'),
				        	bind: '{expediente.numContratoAlquiler}',
				        	readOnly: true
				        },
				        { 
							xtype: 'textfieldbase',
		                	fieldLabel: HreRem.i18n('fieldlabel.email.poliza.segura'),
				        	bind: '{expediente.numContratoAlquiler}',
				        	readOnly: true
				        },
				        { 
							xtype: 'textfieldbase',
		                	fieldLabel: HreRem.i18n('fieldlabel.comentario'),
				        	readOnly: true
				        }
						
					]
           },
           {   
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',				
				title: HreRem.i18n('title.bloque.historico.scoring'),
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
					        	fieldLabel: HreRem.i18n('fieldlabel.fecha.sancion'),
					        	bind: '{expediente.fechaInicioAlquiler}',
					        	readOnly: true,
					        	maxValue: null
					        },
					       
							{ 
								xtype: 'textfieldbase',
			                	fieldLabel: HreRem.i18n('fieldlabel.resultado'),
					        	bind: '{expediente.numContratoAlquiler}',
					        	readOnly: true
					        },
					        { 
								xtype: 'textfieldbase',
			                	fieldLabel:HreRem.i18n('fieldlabel.numero.solicitud'),
					        	bind: '{expediente.numContratoAlquiler}',
					        	readOnly: true
					        },
					        { 
								xtype: 'textfieldbase',
			                	fieldLabel:HreRem.i18n('fieldlabel.documento'),
					        	bind: '{expediente.numContratoAlquiler}',
					        	readOnly: true
					        },
					        { 
								xtype: 'textfieldbase',
			                	fieldLabel:HreRem.i18n('fieldlabel.meses.fianza'),
					        	bind: '{expediente.numContratoAlquiler}',
					        	readOnly: true
					        },
					        { 
								xtype: 'textfieldbase',
			                	fieldLabel:HreRem.i18n('fieldlabel.importe.fianza'),
					        	bind: '{expediente.numContratoAlquiler}',
					        	readOnly: true
					        }
					        
				        ]
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