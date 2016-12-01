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
			            	bind: '{infoComercial.infoDescripcion}',
			            	colspan: 3,
			            	maxLength: 500,
			            	margin: '0 0 20 0',
			            	height: 100,
							maxWidth: 1600
						},
						{ 
							xtype: 'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.info.distribucion.interior'),
							labelAlign: 'top',
		                	bind: '{infoComercial.infoDistribucionInterior}',
			            	colspan: 3,
			            	maxLength: 500,
			            	height: 100,
							maxWidth: 1600
		                }
		];            
       
    	me.callParent();
    	
    }
    
});