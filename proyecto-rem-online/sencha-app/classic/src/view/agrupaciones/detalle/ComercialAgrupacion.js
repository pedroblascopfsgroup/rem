Ext.define('HreRem.view.agrupacion.detalle.ComercialAgrupacion', {
	extend: 'Ext.form.Panel',
    cls: 'panel-base shadow-panel',
    xtype: 'comercialagrupacion',
    reference: 'comercialagrupacionref',
    scrollable: 'y',
    requires: ['HreRem.view.agrupacion.detalle.ComercialAgrupacionTabs'], 
    
    initComponent: function () {
    	
    	var me = this;
    	
    	me.items = [
    		{
    			xtype: 'label',
    			cls:'x-form-item',
    			html: HreRem.i18n('msg.oferta.agrupacion.no.tramitable'),
    			style: 'color: red; font-weight: bold; font-size: small;',
    			readOnly: true,
    			hidden: true,
    			bind : {
    				hidden: '{agrupacionficha.tramitable}'
    			}
    		},
			{
				xtype: 'comercialagrupaciontabs'
			}
    	];
    	
    	

    	me.setTitle(HreRem.i18n('title.comercial'));
    	me.callParent();
    	
    },
    
    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.up('agrupacionesdetallemain').lookupReference('comercialagrupaciontabsref').funcionRecargar();
    }
    
});