Ext.define('HreRem.view.activos.detalle.InfoLocalComercial', {
    extend: 'HreRem.view.common.FieldSetTable',
    xtype: 'infolocalcomercial',
    initComponent: function () {

        var me = this;        
		me.items = [
					 	{ 	
					 		xtype: 'numberfieldbase',
					 		decimalPrecision: 2,
					 		fieldLabel: HreRem.i18n('fieldlabel.longitud.fachada.calle.principal'),
			            	bind:		'{infoComercial.mtsFachadaPpal}',
							readOnly: true
						},
						{ 
							xtype: 'textfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.uso.idoneo'),
		                	bind:		'{infoComercial.usuIdoneo}',
							readOnly: true
		                },
		                { 
							xtype: 		'textareafieldbase',
					 		fieldLabel: HreRem.i18n('fieldlabel.observaciones'),
					 		height: 	250,
					 		rowspan:	4,
		                	bind:		'',
							readOnly: true
						},
						{ 
					 		xtype: 'numberfieldbase',
					 		decimalPrecision: 2,
							fieldLabel: HreRem.i18n('fieldlabel.longitud.fachada.calles.laterales'),
		                	bind:		'{infoComercial.mtsFachadaLat}',
							readOnly: true
		                },
						{ 
							xtype: 'textfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.uso.anterior'),
		                	bind:		'{infoComercial.usuAnterior}',
							readOnly: true
		                },
		                { 
					 		xtype: 'numberfieldbase',
					 		decimalPrecision: 2,
					 		fieldLabel: HreRem.i18n('fieldlabel.longitud.luz.libre.pilares'),
			            	bind:		'{infoComercial.mtsLuzLibre}',
							readOnly: true
						},
		                { 
					 		xtype: 'numberfieldbase',
					 		decimalPrecision: 2,
					 		fieldLabel: HreRem.i18n('fieldlabel.altura.libre'),
			            	bind:		'{infoComercial.mtsAlturaLibre}',
							readOnly: true
						},
						{ 
				        	xtype: 'comboboxfieldbase',
				        	editable: false,
				        	fieldLabel:  HreRem.i18n('fieldlabel.local.diafano'),
				        	labelWidth:	150,
				        	bind: {
			            		store: '{comboSiNoRem}',
			            		value: '{infoComercial.diafano}'			            		
			            	},
			            	displayField: 'descripcion',
    						valueField: 'codigo',
							readOnly: true
				        },
						{ 
					 		xtype: 'numberfieldbase',
					 		decimalPrecision: 2,
							fieldLabel: HreRem.i18n('fieldlabel.profundidad'),
		                	bind:		'{infoComercial.mtsLinealesProf}',
							readOnly: true
		                }
						
		];            
       
    	me.callParent();
    	
    }
    
});