Ext.define('HreRem.view.precios.generacion.GeneracionPropuestasAutomatica', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'generacionpropuestasautomatica',
    reference	: 'generacionPropuestasAutomatica',
    cls			: 'panel-contadores',
    layout: 'fit',
    requires: ['HreRem.view.precios.generacion.GeneracionPropuestasAutomaticaContadores'],

    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.inclusion.automatica")); 
        
        me.items = [
        		        						
	        		{
			    		xtype:'toolfieldset',			   		         						   		        
			        	cls: 'fieldsetBase cabecera',
			        	title: 'X',
			        	scrollable: 'y',
			        	border: false,			        	
					    layout: {
						        type: 'hbox'
					    },
						tools: [
								{	xtype: 'tbfill'},
								{
									xtype: 'button',
									margin: '10 6 0 0',
									cls: 'boton-cabecera',
									iconCls: 'ico-refrescar',
									handler	: 'onClickBotonRefrescarContadores',
									tooltip: HreRem.i18n('btn.refrescar')
						    	}
						    	
						],
						items: [
	    						{
	    							xtype: 'generacionpropuestasautomaticacontadores'
	    						}
						]
	        		}
	        			
        ];
       
        me.callParent(); 

        
    }


});

