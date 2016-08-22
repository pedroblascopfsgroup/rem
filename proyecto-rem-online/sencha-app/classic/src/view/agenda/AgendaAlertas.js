Ext.define('HreRem.view.agenda.AgendaAlertas', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'agendaalertas',
    isSearchForm: false,
    reference: 'agendaalertasform',
    title: 'Alertas',
    layout: 'column', 
    
    defaults: {
        layout: 'form',
        xtype: 'container',
        defaultType: 'textfield'
        //,style: 'width: 50%'
    },
    
	initComponent: function() {
	
		var me = this;
	    
	    me.collapsible= true;
    	me.collapsed= false;    		
    	me.buttonAlign = 'left'; 
	    me.buttons = [
	    	{ 
	    		text: HreRem.i18n('btn.nueva.alertas'), handler: 'onAlertasClick' 
	    	}
	    ];
	    		
	    me.callParent();
	}
});