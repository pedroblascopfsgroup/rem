/**
 * @class HreRem.ux.util.Validations
 * @author Jose Villel
 *
 * Clase para implementar validaciones globales.
 * 
 * Ejemplo de uso:
 * 
 * HreRem.ux.util.Validations.latValidation()
 * @singleton
 */
Ext.define('HreRem.ux.util.Validations', {
   
	alternateClassName: ['RemValidations'],
	singleton: true,

    constructor: function (config) {
    	this.initConfig(config)
    },
        
    /**
     * Valida la latitud en una coordenada
     * return @Boolean
     */
  	latValidation: function(lat) {
  		return  !Ext.isEmpty(lat) && lat != 0;
  	},
  	
  	 /**
     * Valida la longitud en una coordenada
     * return @Boolean
     */
  	lngValidation: function(lng) {
  		return !Ext.isEmpty(lng) && lng != 0;
  	}   
    
});
