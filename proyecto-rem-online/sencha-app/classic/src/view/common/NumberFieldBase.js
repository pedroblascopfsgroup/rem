Ext.define('HreRem.view.common.NumberFieldBase', { 
    extend		: 'Ext.form.field.Number',
    xtype		: 'numberfieldbase',
    requires: ['HreRem.ux.field.FieldBase'],
    mixins: [
        'HreRem.ux.field.FieldBase'
    ],
    
    labelWidth: 150,
    
    maxWidth: 400,

    hideTrigger: true,
	keyNavEnable: false,
	mouseWheelEnable: false,
	
    /**
     * Atributo para formatear el valor del campo cuando se está utilizando el plugin UxReadOnlyEditField y está en modo viewOnly
     * @type 
     */
    symbol: null, 

	initComponent: function() {    	
	    var me = this;    	
		// Aqui configuraciones únicas para el CurrencyFieldBase
		
		me.callParent();
		me.initFieldBase();
    }
});