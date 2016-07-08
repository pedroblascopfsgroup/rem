Ext.define('HreRem.view.dashboard.activosCalientes.ActivosCalientesWidget', {
	xtype: 'activoscalienteswidget',
    extend: 'Ext.view.View',
    title:	'Activos en curso',
    scrollable: 'y',
    minHeight : 206,
    maxHeight : 206,
  //  cls	: 'panel-base shadow-panel',

    viewModel: {
        type: 'activoscalientesmodel'
    },
    controller: {
        type: 'activoscalientescontroller'
    },
	
    bind: {
        store: '{activoscalientesimagenes}'
    },
    
    
    // Listener para el doble click en la lista de activos
	listeners        : {
		itemclick: 'onEnlaceActivosClick'
     },
     
    itemSelector: 'div.thumb-wrap',
    tpl: new Ext.XTemplate( 		
    		'<tpl for="."><div style="background-color: #fff;margin-left:10px" class="thumb-wrap"><img src="{src}" width="60px" height="60px"  style="float:left" /><br>' +
    		'<span style="margin-left:10px">{descripcionActivo}</span><br>' +
    		'<span style="margin-left:10px">{tarea}</span><br>' + 
    		'<span>&nbsp;&nbsp;&nbsp;</span>' +
    		'</div></tpl>'), 
    emptyText: 'No images available'//,
   // renderTo: Ext.getBody()
    
    
});
