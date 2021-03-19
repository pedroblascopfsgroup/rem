Ext.define('HreRem.model.BusquedaAgrupacionGrid', {
    extend: 'HreRem.model.Base',
     idProperty: 'id',    

    fields: [
			{
				name: 'tipoAgrupacionCodigo'
			},
			{
				name: 'tipoAgrupacionDescripcion'
			},
			{
				name: 'nombre'
			},
			{
				name: 'numAgrupacionRem'
			},
			{
				name: 'numAgrupacionUvem'
			},
			{
				name: 'descripcion'
			},
			{
				name: 'fechaAlta'
			},
			{
				name: 'fechaBaja'
			},
			{
				name: 'fechaInicioVigencia'
			},
			{
				name: 'fechaFinVigencia'
			},
			{
				name: 'fechaCreacionDesde'
			},
			{
				name: 'fechaCreacionHasta'
			},
			{
				name: 'fechaInicioVigenciaDesde'
			},
			{
				name: 'fechaInicioVigenciaHasta'
			},
			{
				name: 'fechaFinVigenciaDesde'
			},
			{
				name: 'fechaFinVigenciaHasta'
			},
			{
				name: 'publicado'
			},
			{
				name: 'numActivos'
			},
			{
				name: 'numPublicados'
			},
			{
				name: 'direccion'
			},
			{
				name: 'carteraCodigo'
			},
			{
				name: 'carteraDescripcion'
			},
			{
				name: 'subcarteraCodigo'
			},
			{
				name: 'subcarteraDescripcion'
			},
			{
				name: 'formalizacion'
			},
			{
				name: 'numActHaya'
			},
			{
				name: 'numActPrinex'
			},
			{
				name: 'numActSareb'
			},
			{
				name: 'numActUVEM'
			},
			{
				name: 'numActReco'
			},
			{
				name: 'nif'
			},
			{
				name: 'tipoAlquilerCodigo'
			},
			{
				name: 'tipoAlquilerDescripcion'
			},
			{
				name: 'localidadCodigo'
			},
			{
				name: 'localidadDescripcion'
			},
			{
				name: 'provinciaCodigo'
			},
			{
				name: 'provinciaDescripcion'
			}
	
    ],
        
    proxy: {
		type: 'uxproxy',
		api: {
		 	read: 'agrupacion/getBusquedaAgrupacionesGrid',           
        	create: 'agrupacion/createAgrupacionesGrid',
    	    destroy: 'agrupacion/deleteAgrupacionesById'
        }
    }  
      
});