Ext.define('HreRem.model.BusquedaOfertaGrid', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    
			{ 
			    name: 'numOferta'
			},
			{ 
			    name: 'numExpediente'
			},
			{ 
			    name: 'numActivo'
			},
			{ 
			    name: 'numAgrupacion'
			},
			{ 
			    name: 'numActivoAgrupacion'
			},
			{ 
			    name: 'numVisita'
			},
			{ 
			    name: 'ofertante'
			},			
			{ 
			    name: 'importeOferta'
			},
			{ 
			    name: 'agrupacionesVinculadas'
			},
			{ 
			    name: 'codigoTipoOferta'
			},
			{ 
			    name: 'descripcionTipoOferta'
			},
			{ 
			    name: 'estadoExpedienteAlquiler'
			},			
			{ 
			    name: 'estadoExpedienteVenta'
			},
			{ 
			    name: 'codigoEstadoExpediente'
			},
			{ 
			    name: 'descripcionEstadoExpediente'
			},
			{ 
			    name: 'tipoComercializacionCodigo'
			},
			{ 
			    name: 'codigoEstadoOferta'
			},
			{ 
			    name: 'descripcionEstadoOferta'
			},
			{ 
			    name: 'tipoGestor'
			},
			{ 
			    name: 'numActivoUvem'
			},		
			{ 
			    name: 'tipoFecha'
			},
			{ 
			    name: 'fechaDesde',
				type : 'date',
				dateFormat: 'c'
			},
			{ 
			    name: 'fechaHasta',
				type : 'date',
				dateFormat: 'c'
			},
			{
				name : 'fechaCreacion',
				type : 'date',
				dateFormat: 'c'
			},
			{ 
			    name: 'estadoOferta'			
			},			
			{ 
			    name: 'claseActivoBancarioCodigo'
			},			
			{ 
			    name: 'usuarioGestor'
			},
			{ 
			    name: 'numActivoSareb'
			},				
			{ 
			    name: 'carteraCodigo'
			},
			{ 
			    name: 'subcarteraCodigo'
			},
			{ 
			    name: 'nombreCanal'
			},
			{ 
			    name: 'canalCodigo'
			},
			{ 
			    name: 'canalDescripcion'
			},
			{ 
			    name: 'gestoria'
			},
			{ 
			    name: 'ofertante'
			},		
			{ 
			    name: 'documentoOfertante'
			},
			{ 
			    name: 'telefonoOfertante'
			},		
			{ 
			    name: 'emailOfertante'
			},
			{ 
			    name: 'ofertaExpress'
			},
			{ 
			    name: 'numPrinex'
			},
			{ 
			    name: 'codigoPromocionPrinex'
			},
			{ 
			    name: 'codigoEstadoC4C'
			}
	
    ]
});