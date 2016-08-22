Ext.define('HreRem.view.agenda.AgendaAvisos', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'agendaavisos',
    isSearchForm: false,
    reference: 'agendaavisosform',
    title: 'Avisos',
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
	    		text: HreRem.i18n('btn.nueva.avisos'), handler: 'onAvisosClick' 
	    	}
	    ];
	    		
	    me.callParent();
	}
});