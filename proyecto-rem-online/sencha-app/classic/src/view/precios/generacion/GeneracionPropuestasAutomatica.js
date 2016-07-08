Ext.define('HreRem.view.precios.generacion.GeneracionPropuestasAutomatica', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'generacionpropuestasautomatica',
    reference	: 'generacionPropuestasAutomatica',    

    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.inclusion.automatica"));       
        
        me.callParent(); 

        
    }


});

