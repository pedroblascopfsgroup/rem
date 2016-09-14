Ext.define('HreRem.view.activos.detalle.InfoIndustrialYSuelo', {
    extend: 'HreRem.view.common.FieldSetTable',
    xtype: 'infoindustrialysuelo',
    initComponent: function () {

        var me = this;        
		me.items = [
					 	{ 	
					 		xtype: 'textareafieldbase',
					 		fieldLabel: HreRem.i18n('fieldlabel.descripcion'),
					 		labelAlign: 'top',
			            	bind: '{informeComercial.infoDescripcion}',
			            	colspan: 3,
			            	maxLength: 500,
			            	margin: '0 0 20 0',
			            	height: 100,
			            	width: 680,
							maxWidth: 680
						},
						{ 
							xtype: 'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.info.distribucion.interior'),
							labelAlign: 'top',
		                	bind: '{informeComercial.infoDistribucionInterior}',
			            	colspan: 3,
			            	maxLength: 500,
			            	height: 100,
			            	width: 680,
							maxWidth: 680
		                }
		];            
       
    	me.callParent();
    	
    }
    
});