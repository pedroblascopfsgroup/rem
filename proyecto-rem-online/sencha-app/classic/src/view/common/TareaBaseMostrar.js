Ext.define('HreRem.view.common.TareaBaseMostrar', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'tareabasemostrar',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /2,    
    controller: 'tarea',

    initComponent: function() {
    	//debugger;
    	var me = this;
    	
    	me.buttonAlign = 'left';    		
    	me.buttons = [ { itemId: 'btnCerrar', text: 'Cerrar', handler: 'cerrarTarea' }];

    	me.callParent();
    
    },
    
     /**
     * Se debe sobreescribir esta función si se deseaan realizar y mostrar errores de validaciones pre
     */
    mostrarValidacionesPre: function() {},    
    /**
     * Se debe sobreescribir esta función para que devuelva la tarea siguiente en el flujo
     */
    evaluar: function(){alert("tarea.evaluar()??")},
    
    /**
     * Se debe sobreescribir esta función si se deseaan realizar y mostrar errores de validaciones post
     */
    mostrarValidacionesPost: function() {}
    
    
    
    

});