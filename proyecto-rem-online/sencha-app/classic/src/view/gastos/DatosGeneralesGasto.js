Ext.define('HreRem.view.gastos.DatosGeneralesGasto', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'datosgeneralesgasto',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'datosgeneralesgastoref',
    scrollable	: 'y',
//	recordName: "expediente",
//	
//	recordClass: "HreRem.model.ExpedienteComercial",
//    
//    requires: ['HreRem.model.ExpedienteComercial'],
    
    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.ficha'));
        var items= [

//			{   
//				xtype:'fieldsettable',
//				defaultType: 'textfieldbase',				
//				title: HreRem.i18n('title.identificacion'),
//				items :
//					[
//		                {
//		                	xtype: 'displayfieldbase',
//		                	fieldLabel:  HreRem.i18n('fieldlabel.num.expediente'),
//		                	bind:		'{expediente.numExpediente}'
//
//		                },						
//						{
//							xtype: 'displayfieldbase',
//							fieldLabel: HreRem.i18n('fieldlabel.cartera'),
//							bind:		'{expediente.entidadPropietariaDescripcion}'
//						},						
//						{
//							xtype: 'displayfieldbase',
//							fieldLabel:  HreRem.i18n('fieldlabel.propietario'),
//			                bind:		'{expediente.propietario}'
//						},		       
//						{ 
//							xtype: 'displayfieldbase',
//							fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
//		                	bind:		'{expediente.tipoExpedienteDescripcion}'
//		                },		                
//		                { 
//							xtype: 'displayfieldbase',
//							fieldLabel:  HreRem.i18n('fiedlabel.numero.activo.agrupacion'),
//		                	bind:		'{expediente.numEntidad}'
//		                }
//						
//					]
//           }
           
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