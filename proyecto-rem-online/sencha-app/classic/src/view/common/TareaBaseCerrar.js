Ext.define('HreRem.view.common.TareaBaseCerrar', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'tareabasecerrar',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /2,    
    controller: 'tarea',

    initComponent: function() {
    	//debugger;
    	var me = this;
    	
    	me.buttonAlign = 'left';    		
    	me.buttons = [ { itemId: 'btnCancelar', text: 'Cerrar', handler: 'cancelarTarea'}];

    	me.callParent();    	
    
    },
    
     /**
     * Se debe sobreescribir esta función si se deseaan realizar y mostrar errores de validaciones pre
     */
    mostrarValidacionesPre: function() {alert("tarea.mostrarValidacionesPre()??")},    
    /**
     * Se debe sobreescribir esta función para que devuelva la tarea siguiente en el flujo
     */
    evaluar: function(){alert("tarea.evaluar()??")},
    
    /**
     * Se debe sobreescribir esta función si se deseaan realizar y mostrar errores de validaciones post
     */
    mostrarValidacionesPost: function() {alert("tarea.mostrarValidacionesPost()??")}
    
    
    
    

});