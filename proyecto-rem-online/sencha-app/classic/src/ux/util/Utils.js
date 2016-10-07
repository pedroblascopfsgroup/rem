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
   		return value == "true" ? HreRem.i18n('txt.si') : HreRem.i18n('txt.no')
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
   }
    
});