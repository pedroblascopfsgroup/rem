Ext.define('HreRem.model.BusquedaPublicacionGrid', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',        

    fields: [
    		
			{
		          name: 'numActivo'
		    },
			{
		          name: 'tipoActivoCodigo'
		    },
			{
		          name: 'tipoActivoDescripcion'
		    },
			{
		          name: 'subtipoActivoCodigo'
		    },
			{
		          name: 'subtipoActivoDescripcion'
		    },
			{
		          name: 'direccion'
		    },
			{
		          name: 'carteraCodigo'
		    },
			{
		          name: 'estadoPublicacionVentaCodigo'
		    },
			{
		          name: 'estadoPublicacionVentaDescripcion'
		    },
			{
		          name: 'estadoPublicacionAlquilerCodigo'
		    },
			{
		          name: 'estadoPublicacionAlquilerDescripcion'
		    },
			{
		          name: 'estadoPublicacionDescripcion'
		    },
			{
		          name: 'tipoComercializacionCodigo'
		    },
			{
		          name: 'tipoComercializacionDescripcion'
		    },
			{
		          name: 'admision'
		    },
			{
		          name: 'gestion'
		    },
			{
		          name: 'publicacion'
		    },			
		    {
		          name: 'indicadorVenta',
		          calculate: function(data) {
		          	if(data.carteraCodigo == '01' || data.carteraCodigo == '08'){
		          		return data.admision == 1 && data.gestion == 1 && data.informeComercial == 1 && (data.adecuacionAlquilerCodigo == '02'  || data.publicarSinPrecioVenta == 1)
		          	}else{
		          		return data.admision == 1 && data.gestion == 1 && (data.adecuacionAlquilerCodigo == '02'  || data.publicarSinPrecioVenta == 1)	
		          	}
    			},
    			depends: ['admision', 'gestion', 'carteraCodigo', 'informeComercial', 'adecuacionAlquilerCodigo', 'publicarSinPrecioVenta']
		    },
		    {
		          name: 'indicadorAlquiler',
		          calculate: function(data) {		          	
		          	if(data.tipoActivoCodigo == '02' && data.adecuacionAlquilerCodigo == '01'  || data.adecuacionAlquilerCodigo == '03' && data.adjuntoActivo == 1
			          		&& (data.conPrecioAlquiler == 1 || data.publicarSinPrecioAlquiler == 1) && data.informeComercial == 1){
		          			if (data.carteraCodigo == '01' || data.carteraCodigo == '08') {
		          				return true;
		          			} else {
		          				return data.informeComercial == 1;
		          			}
	          		} else {
	          			return false;
	          		}
    			  },
    			  depends: ['tipoActivoCodigo', 'admision', 'adecuacionAlquilerCodigo', 'gestion', 'adjuntoActivo', 'conPrecioAlquiler', 'publicarSinPrecioAlquiler', 'informeComercial']
		    },		   
			{
		          name: 'precio'
		    },
		    {
		          name: 'precioTasacionActivo'
		    },
			{
		          name: 'gestorPublicacionUsername'
		    },
			{
		          name: 'fasePublicacionCodigo'
		    },
			{
		          name: 'fasePublicacionDescripcion'
		    },
			{
		          name: 'subfasePublicacionCodigo'
		    },
			{
		          name: 'subfasePublicacionDescripcion'
		    },
			{
		          name: 'tipoAlquilerDescripcion'
		    },
		    {
		          name: 'fechaPublicacionActivo',
		          calculate: function(data) {		          	
		          		var tiposVenta = [CONST.TIPOS_COMERCIALIZACION['VENTA'], CONST.TIPOS_COMERCIALIZACION['ALQUILER_VENTA']];
		          		var estadosPublicadoVenta = [CONST.ESTADO_PUBLICACION_VENTA['PUBLICADO'], CONST.ESTADO_PUBLICACION_VENTA['PRE_PUBLICADO']];
		            	var estadosPublicadoAlquiler = [CONST.ESTADO_PUBLICACION_ALQUILER['PUBLICADO'], CONST.ESTADO_PUBLICACION_ALQUILER['PRE_PUBLICADO']];		            	
		            	
		            	if ((tiposVenta.includes(data.tipoComercializacionCodigo) && estadosPublicadoVenta.includes(data.estadoPublicacionVentaCodigo))
		            			|| data.tipoComercializacionCodigo  == CONST.TIPOS_COMERCIALIZACION['SOLO_ALQUILER'] && estadosPublicadoAlquiler.includes(data.estadoPublicacionAlquilerCodigo)) {
		            			
		            		return tiposVenta.includes(data.tipoComercializacionCodigo) ? data.fechaPublicacionVenta : data.fechaPublicacionAlquiler;
		            		}		            		
		          		return null;		          	
		            },
    				depends: ['estadoPublicacionVentaCodigo', 'estadoPublicacionAlquilerCodigo', 'tipoComercializacionCodigo', 'fechaPublicacionVenta', 'fechaPublicacionAlquiler']        	    			
    		},
		    {
		          name: 'fechaDespublicacionActivo',
		          calculate: function(data) { 
			          	var tiposVenta = [CONST.TIPOS_COMERCIALIZACION['VENTA'], CONST.TIPOS_COMERCIALIZACION['ALQUILER_VENTA']];
			          	var estadosDespublicadoVenta = [CONST.ESTADO_PUBLICACION_VENTA['OCULTO']];
			            var estadosDespublicadoAlquiler = [CONST.ESTADO_PUBLICACION_ALQUILER['OCULTO']];        	
			            	
			            if ((tiposVenta.includes(data.tipoComercializacionCodigo) && estadosDespublicadoVenta.includes(data.estadoPublicacionVentaCodigo))
			            		|| data.tipoComercializacionCodigo  == CONST.TIPOS_COMERCIALIZACION['SOLO_ALQUILER'] && estadosDespublicadoAlquiler.includes(data.estadoPublicacionAlquilerCodigo)) {
			            			
			            		return tiposVenta.includes(data.tipoComercializacionCodigo) ? data.fechaPublicacionVenta : data.fechaPublicacionAlquiler;
			            		}
			          		return null;		          	
			        },
	    			depends: ['estadoPublicacionVentaCodigo', 'estadoPublicacionAlquilerCodigo', 'tipoComercializacionCodigo', 'fechaPublicacionVenta', 'fechaPublicacionAlquiler']		          	
		    },
			{
		          name: 'fechaPublicacionVenta'
		    },
			{
		          name: 'fechaPublicacionAlquiler'
		    },
			{
		          name: 'publicarSinPrecioVenta'
		    },
			{
		          name: 'publicarSinPrecioAlquiler'
		    },
			{
		          name: 'informeComercial'
		    },
			{
		          name: 'adjuntoActivo'
		    },
		    {
		          name: 'checkOkPrecio'
		    },
		    {
		          name: 'checkOkVenta'
		    },
		    {
		          name: 'checkOkAlquiler'
		    },
		    {
		          name: 'checkOkInformeComercial'
		    },
		    {
		          name: 'checkOkGestion'
		    },
		    {
		          name: 'checkOkAdmision'
		    },
		    {
		          name: 'motivosOcultacionVentaCodigo'
		    },
		    {
		          name: 'motivosOcultacionAlquilerCodigo'
		    },
		    {
		          name: 'adecuacionAlquilerCodigo'
		    },
		    {
		          name: 'conPrecioAlquiler'
		    }		    
		  
    ] 
    

});
