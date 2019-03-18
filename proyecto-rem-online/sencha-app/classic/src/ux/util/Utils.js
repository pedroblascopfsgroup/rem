Ext.define('HreRem.ux.util.Utils', {

	alternateClassName: ['Utils'],
	singleton: true,

    constructor: function (config) {
    	this.initConfig(config)
    }, 
        
    /**
    * Renderer para convertir un resultado 1/0 en Si/No
    * @param {} value
    * @param {} metaData
    * @param {} record
    * @param {} rowIndex
    * @param {} colIndex
    * @param {} store
    * @param {} view
    * @return {}
    */
   rendererNumberToSiNo: function(value, metaData, record, rowIndex, colIndex, store, view) {
   		return Ext.isEmpty(value)? "" : value=='1'? HreRem.i18n('txt.si') : HreRem.i18n('txt.no')
   },
    /**
    * Renderer para convertir un resultado Boolean en Si/No
    * @param {} value
    * @param {} metaData
    * @param {} record
    * @param {} rowIndex
    * @param {} colIndex
    * @param {} store
    * @param {} view
    * @return {}
    */
   rendererBooleanToSiNo: function(value, metaData, record, rowIndex, colIndex, store, view) {
   		return value === true|| value === "true" ? HreRem.i18n('txt.si') : HreRem.i18n('txt.no')
   },
    /**
    * Renderer para convertir resultados de moneda
    * @param {} value
    * @param {} metaData
    * @param {} record
    * @param {} rowIndex
    * @param {} colIndex
    * @param {} store
    * @param {} view
    * @return {}
    */
   rendererCurrency: function(value, metaData, record, rowIndex, colIndex, store, view) {
	   	return Ext.isEmpty(value) ? "" : Ext.util.Format.currency(value);
   },
   
   /**
    * Función que evalua si el objeto recibido está vacio
    */
   isEmptyJSON: function (obj) {
 		for(var i in obj) { return false; }
 		return true;
   },
   
	/**
	 * Función failure por defecto para las operaciones de los modelos.
	 * @param {} a
	 * @param {} operation
	 * @param {} form - Formulario repsentativo del modelo.
	 * @param {} beforeFailureFn Funcion que se ejecutará antes de las operaciones por defecto.
	 * @param {} afterFailureFn Funcion que se ejecutará después de las operaciones por defecto.
	 */
   defaultOperationFailure: function (a, operation, form, beforeFailureFn, afterFailureFn) {
		var response;		
   		try{
			response = Ext.decode(operation.getResponse().responseText);
   		} catch(e) {
   			response = {}
   		}
   		
		beforeFailureFn = Ext.isFunction(beforeFailureFn) ? beforeFailureFn : Ext.emptyFn,
		afterFailureFn = Ext.isFunction(afterFailureFn) ? afterFailureFn : Ext.emptyFn;
		
		beforeFailureFn();
		
		if(Ext.isDefined(response.msgError)) {
			form.fireEvent("errorToast", response.msgError);
		} else {
			form.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		}
		this.unmaskAll();
		
		if(Ext.isFunction(form.funcionRecargar)) {
			form.funcionRecargar();
		}
		
		afterFailureFn();
   },
   
   /**
    * Función failure por defecto para las operaciones de los modelos.
    * @param {} response
    * @param {} opts
	* @param {} beforeFailureFn Funcion que se ejecutará antes de las operaciones por defecto.
	* @param {} afterFailureFn Funcion que se ejecutará después de las operaciones por defecto.
    */
   defaultRequestFailure: function (response, opts, beforeFailureFn, afterFailureFn) {
   		var response;		
   		try{
			response = Ext.decode(response.responseText);
   		} catch(e) {
   			response = {}
   		}

		beforeFailureFn = Ext.isFunction(beforeFailureFn) ? beforeFailureFn : Ext.emptyFn,
		afterFailureFn = Ext.isFunction(afterFailureFn) ? afterFailureFn : Ext.emptyFn;
		
		beforeFailureFn();
		
		if(Ext.isDefined(response.msgError)) {
			this.fireGlobalEvent("errorToast", response.msgError);
		} else {
			this.fireGlobalEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		}
		this.unmaskAll();
		
		afterFailureFn();
   },
   
   /**
    * Busca todos los componentes con la propiedad masked a true, y les quita la mascara
    */
   unmaskAll: function () {
   		
   		var cmps = Ext.ComponentQuery.query('[masked=true]');
   		
   		// TODO Si en algun momento necesitamos que a algún componente no se le quite la mascara,
   		// podriamos añadir un atributo que impida que se le quite la mascara aquí.
   		Ext.Array.each(cmps, function(cmp, index) {   			
   			cmp.unmask();   		
   		});
   	
   },
   
   	/**
	 * @param event Evento que se lanzará
	 * @param params Argumentos que se enviarán junto al evento
	 */
	fireGlobalEvent: function (event, params) {		
		Ext.GlobalEvents.fireEvent(event, params);
	}
    
});