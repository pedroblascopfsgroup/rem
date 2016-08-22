Ext.define('HreRem.view.agenda.AgendaNotificacion', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'agendanotificacion',
    isSearchForm: false,
    reference: 'agendanotificacionform',
    title: 'Notificaciones',
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
	    		text: HreRem.i18n('btn.nueva.notificacion'), handler: 'onNotificacionClick' 
	    	}
	    ];
	    		
	    me.callParent();
	}
});