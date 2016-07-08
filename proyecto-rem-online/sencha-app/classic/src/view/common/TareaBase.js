Ext.define('HreRem.view.common.TareaBase', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'tareabase',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /2,    
    requires : ['HreRem.view.common.TareaController'],
    controller: 'tarea',
    

    tareaEditable: true,
    tareaFinalizable: false,
    
    initComponent: function() {
    	var me = this;
	    
    	me.buttonAlign = 'left';
    	if(me.tareaEditable){
    		me.buttons = [ { itemId: 'btnGuardar', text: 'Guardar', handler: 'guardarTarea', bind: { hidden: '{errorValidacion}'}},{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'cancelarTarea'}];
    	}else{
    		if(me.tareaFinalizable){
    			me.buttons = [{ itemId: 'btnFinalizar', text: 'Marcar como leido', handler: 'finalizarTarea'}, { itemId: 'btnCancelar', text: 'Cerrar', handler: 'cancelarTarea'}];
    		}else{
    			me.buttons = [{ itemId: 'btnCancelar', text: 'Cerrar', handler: 'cancelarTarea'}];
    		}
    	}
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