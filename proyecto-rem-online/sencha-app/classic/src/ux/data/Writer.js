Ext.define('HreRem.ux.data.SinglePost', {
    extend: 'Ext.data.writer.Writer',
    alternateClassName: 'Ext.data.SinglePostWriter',
    alias: 'writer.singlepost',

    writeRecords: function(request, data) {

		var parametros = {};
    	for (var attrname in request._params) { parametros[attrname] = request._params[attrname]; }
    	for (var attrname in data[0]) { parametros[attrname] = data[0][attrname]; }
		
		
        request._params = parametros;
        return request;
    }
    
});
