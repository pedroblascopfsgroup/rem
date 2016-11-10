Ext.define('HreRem.view.configuracion.administracion.mediadores.ConfiguracionMediadoresFiltros', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'configuracionmediadoresfiltros',
    reference: 'configuracionMediadoresFiltros',
    isSearchForm: true,
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,    
    layout: {
        type: 'accordion',
        titleCollapse: false,
        animate: true,
        vertical: true,
        multi: false
    },    

	initComponent: function() {
	
		var me = this;
    	me.setTitle(HreRem.i18n('title.configuracion.mediadores.filtro'));
	    me.items= [
	         {
    			xtype: 'panel',
    			collapsible: false,
    			layout: 'column',
    			title: HreRem.i18n('title.configuracion.mediadores.filtro'),
    			cls: 'panel-base shadow-panel',
    			defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfield'
			    },
				items: [

					{ 
						fieldLabel:  HreRem.i18n('fieldlabel.mediadores.codigo'),
						name: 'codigo'
					}
				]
    		}
	    ];
	   	
	    me.callParent();
	}
});