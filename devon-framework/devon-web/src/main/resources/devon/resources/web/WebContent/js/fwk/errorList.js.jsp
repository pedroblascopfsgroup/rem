
/**
 * Este control sirve para presentar errores del servidor en un formulario. Si
 * está presente un control de este tipo en un panelForm y la respuesta de una
 * operación Ajax viene con fwkUserExceptions, se mostrarán en este control.
 * 
 * El control se oculta cuando se realiza una validación, esto es al enviar de nuevo
 * el formulario.
 */
fwk.ux.ErrorList = function(config){
    config = config || {};
    config.name = 'errorList';
    config.fieldLabel = config.fieldLabel || '**Errores';
    config.style = 'color:red';
    config.autoHeight = true;
    config.autoShow = true;
    config.hideLabel = true;
    config.cls = 'x-hidden'
    fwk.ux.ErrorList.superclass.constructor.call(this, config);
};

Ext.extend(fwk.ux.ErrorList, Ext.ux.form.StaticTextField, {

     /**
     * Clear any invalid styles/messages for this field, that is all the control
     * Required for Ext.form.Form.clearInvalid()
     * TODO: make invisible also
     */
    clearInvalid : function(){
        this.el.dom.innerHTML = '';
    }
    
    ,autoHeight : true
    // TODO: i18n
    ,fieldLabel : '**Errores'
    ,validateValue : function(value){
        this.clearInvalid();
        return true;
    }
    ,validate : function(){
        this.hide();
        if(this.getEl().up('.x-form-item') != null) {
        	this.getEl().up('.x-form-item').setDisplayed(false);
        }
        this.clearInvalid();
        return true;
    }
    ,setRawValue : function(value){
        this.getEl().up('.x-form-item').setDisplayed(true);
        this.getEl().removeClass('x-hidden');
        this.show();
        if (Ext.isArray(value)) {
        	value = "<ul><li>"+value.join("</li><li>")+"</li></ul>";
        }
        fwk.ux.ErrorList.superclass.setRawValue.call(this,value);
    }
});
Ext.reg('errorList', fwk.ux.ErrorList);

