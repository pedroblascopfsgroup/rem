/**
 * GMap Panel UX extiende `Ext.ux.GMapPanel` para sobreescribir el método onLookupComplete
 * y propagar un evento en caso de recibir algún error de la API de Google, de manera que pueda gestionarse
 * de la manera que corresponda.
 * 
 * 	"OK" indicates that no errors occurred; the address was successfully parsed and at least one geocode was returned.
 * 	"ZERO_RESULTS" indicates that the geocode was successful but returned no results. This may occur if the geocoder was passed a non-existent address.
 *	"OVER_QUERY_LIMIT" indicates that you are over your quota.
 *	"REQUEST_DENIED" indicates that your request was denied.
 *	"INVALID_REQUEST" generally indicates that the query (address, components or latlng) is missing.
 * 	"UNKNOWN_ERROR" indicates that the request could not be processed due to a server error. The request may succeed if you try again.

 * 
 */
Ext.define('HreRem.ux.panel.GMapPanel', {
    extend: 'Ext.ux.GMapPanel',    
    alias: 'widget.uxgmappanel',
    
    OK: "OK",
    ZERO_RESULTS : "ZERO_RESULTS",
    OVER_QUERY_LIMIT: "OVER_QUERY_LIMIT",
    REQUEST_DENIED: "REQUEST_DENIED",
	INVALID_REQUEST: "INVALID_REQUEST",
	UNKNOWN_ERROR: "UNKNOWN_ERROR",
	
	
    onLookupComplete: function(data, response, marker){
        
        var me = this;
        if (response == me.OK && me.body) {
			this.createMap(data[0].geometry.location, marker);
        } else {        	
        	me.fireEvent("gmapfailure", response);
        	return;
        }        
    },
    /**
     * Configurar el Mapa de manera que si recibe latitud y longitud validas, buscará el mapa con éstas,
     * sino lo hará con la dirección recibida. 
     * @param {} latitud
     * @param {} longitud
     * @param {} direccion
     * @param {} title
     */
    configurarMapa: function(latitud, longitud, direccion, title) {
    	
    	var me =this;

    	if(RemValidations.latValidation(latitud) && RemValidations.lngValidation(longitud)) {
    		me.center = new google.maps.LatLng(latitud, longitud);
			me.center.marker={position: me.center, title: title};
			
      	} else {
      		me.center.geoCodeAddr = direccion;
      		me.center.marker = {title: title};
      	}		
    	
    }
 
});
