/**
 * Objeto global de configuración para mantener información pública y funciones de utilidad 
 * disponibles en cualquier punto de la aplicación.
 */

var AppConfig  = $AC = (function () {
	var localDataMode = false;					// En local tenemos la posibilidad de cargar ficheros json locales, si se configura el proxy con la url local
	var debugMode = null;						// En modo debug veremos por consola los mensajes que hayamos lanzado mediante la funcion log de Controller base 
	var webPath = '';	// web context // TODO Recuperar de contexto de la aplicación
	var locale = null;							// locale
	var localDataPath = 'resources/data';		// ruta de archivos json para carga de datos local
	var urlPattern = 'htm';						// extensión de las urls 
	var defaultPageSize = 30;
	var defaultTimeout = 60000;
	var currentDate = null;
	//var versionDefault = '1.0.3';
	var version = null;
	
	
	return {
		getWebPath : function () {
			return webPath;
		},
		
		setWebPath : function (wp) {
			
			webPath = wp;
		},

		
		getLocale: function () {
			if(locale === null || locale === '') {
				return null;
			}
			return locale.toLowerCase();
		},	
		
		setLocale: function (l) {
			locale = l.toLowerCase();
					
		},
		
		getUrlPattern : function () {
			return urlPattern;
		},
		
		setUrlPattern : function (up) {
			urlPattern = up;
		},
		
		getLocalDataPath: function() {
			
			return localDataPath;
		},
		
		isLocalDataMode: function () {
			return localDataMode;
		},
		
		isDebugMode: function () {
			return Ext.isEmpty(debugMode) ? true : debugMode;
		},
		
		setDebugMode: function (mode) {
			debugMode = mode;
		},
		
		
		getRemoteUrl: function(url) {
			return [webPath,url,'.',urlPattern].join('');
		},
				
		getLocalUrl: function(url) {
			
			return [localDataPath,'/',url].join('');
		},
		
		getDefaultPageSize: function() {
			return defaultPageSize;
		},
		
		getDefaultTimeout: function() {
			
			return defaultTimeout;
		},
		
		setCurrentDate: function(date) {
			
			currentDate = new Date(date);
		},
		
		getCurrentDate: function() {
			return 	Ext.Date.clearTime(currentDate);
		},
		
		setVersion: function(v) {
			version = v;
		},
		
		getVersion: function() {			
			return this.isDebugMode() || Ext.isEmpty(version) ? Ext.manifest.version : version;
		},
		
		getLabelVersion: function() {			
			return HreRem.i18n("label.version") + ' ' + this.getVersion(); 
		}
	};
	
})();

