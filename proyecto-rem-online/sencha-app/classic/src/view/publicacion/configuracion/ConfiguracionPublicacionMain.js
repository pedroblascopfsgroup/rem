Ext.define('HreRem.view.publicacion.configuracion.ConfiguracionPublicacionMain', {
	extend		: 'Ext.panel.Panel',
    xtype		: 'configuracionpublicacionmain',
    requires	: /* Componentes que van dentro: Búsqueda y grid */[],
    layout: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n('title.publicaciones.configuracion'));
        
        me.items = [
                    /* Aquí metemos los xtype que tenemos que definir: Búsqueda y Grid con stock */
        
        ];
        
        me.callParent(); 

        
    }


});

