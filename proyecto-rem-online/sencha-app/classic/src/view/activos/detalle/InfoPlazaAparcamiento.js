Ext.define('HreRem.view.activos.detalle.InfoPlazaAparcamiento', {
    extend: 'HreRem.view.common.FieldSetTable',
    xtype: 'infoplazaaparcamiento',
    initComponent: function () {

        var me = this;
		me.items = [
					{
		        	    xtype:'fieldset',				        	 
		        	    layout: {
			        	      type: 'vbox',
			        	      align: 'stretch'
			        	},
			        	height: 200,
		        	
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.destino'),
						items :
						[
				 			 {
				 				xtype: 'checkboxfieldbase',
			                	fieldLabel: 'Coche',
			                	bind: '{infoComercial.destinoCoche}',
			                	flex: 1,
								readOnly: true
				 				 
				 			 },
				 			 {
				 				 xtype: 'checkboxfieldbase',
				 				 fieldLabel: 'Moto',
				 				 bind: '{infoComercial.destinoMoto}',
				 				 flex: 1,
								 readOnly: true
				 			 },
				 			 {
				 				 xtype: 'checkboxfieldbase',
				 				 fieldLabel: 'Doble',
				 				 bind: '{infoComercial.destinoDoble}',
				 				 flex: 1,
								 readOnly: true
				 			 }
						]
					},
					{
		        	    xtype:'fieldset',
		        	    width: '95%',
		        	    layout: {
			        	      type: 'vbox',
			        	      align: 'stretch'
			        	},
			        	height: 200,
		        	
						defaultType: 'textfieldbase',
						title: HreRem.i18n('title.caracteristicas'),
						items :
						[
			 			 	 {
								xtype: 'comboboxfieldbase',
								editable: false,
								fieldLabel: HreRem.i18n('fieldlabel.ubicacion'),
								flex: 1,
								bind: {
				            		store: '{comboUbicacionAparcamiento}',
				            		value: '{infoComercial.ubicacionAparcamientoCodigo}'
				            	},
				            	displayField: 'descripcion',
	    						valueField: 'codigo',
								readOnly: true
					         },
							 {
								xtype: 'comboboxfieldbase',
								editable: false,
								fieldLabel: HreRem.i18n('fieldlabel.maniobrabilidad'),
								flex: 1,
								readOnly: true
							 },
			 			 	 {
								xtype: 'numberfieldbase',
						 		fieldLabel: HreRem.i18n('fieldlabel.anchura'),
						 		decimalPrecision: 2,
				            	bind:		'{infoComercial.anchura}',
				            	flex: 1,
								readOnly: true
							 },
							 {
								xtype: 'numberfieldbase',
						 		fieldLabel: HreRem.i18n('fieldlabel.profundidad'),
						 		decimalPrecision: 2,
				            	bind:		'{infoComercial.profundidad}',
				            	flex: 1,
								readOnly: true
							 },
							 {
				 				 xtype: 'checkboxfieldbase',
				 				 fieldLabel: 'Forma irregular',
				 				 bind:		'{infoComercial.formaIrregular}',
					             flex: 1,
								 readOnly: true
				 			 }
						]
					},
					{ 
						xtype: 		'textareafieldbase',
				 		fieldLabel: HreRem.i18n('fieldlabel.observaciones'),
				 		height: 	200,
		            	bind:		'',
						readOnly: true
					}
					
		         ]
       
    	me.callParent();
    	
    }
    
});