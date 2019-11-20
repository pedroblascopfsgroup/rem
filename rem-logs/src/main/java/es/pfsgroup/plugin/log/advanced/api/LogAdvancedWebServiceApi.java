package es.pfsgroup.plugin.log.advanced.api;

import es.pfsgroup.plugin.log.advanced.dto.LogDevoWebServiceDto;


public interface LogAdvancedWebServiceApi {
	
	static final String WEB_SERVICE_OFERTAS = "/ofertas";
	static final String WEB_SERVICE_CLIENTES_POST = "/clientes - POST";
	static final String WEB_SERVICE_CLIENTES_DELETE = "/clientes - DELETE";
	static final String WEB_SERVICE_COMISIONES = "/comisiones";
	static final String WEB_SERVICE_CONFIRMACION_OPERACION = "/confirmacionoperacion";
	static final String WEB_SERVICE_FOTOS = "/fotos";
	static final String WEB_SERVICE_FOTOS_FUERATOKEN = "/fotos/fueratoken";
	static final String WEB_SERVICE_FOTOS_DOWNLOAD = "/fotos/download";
	static final String WEB_SERVICE_ALTA_DOCUMENTO = "/generic/altaDocumento";
	static final String WEB_SERVICE_INFORME_MEDIADOR = "/informemediador";
	static final String WEB_SERVICE_NOTIFICACIONES = "/notificaciones";
	static final String WEB_SERVICE_AVANZA_OFERTA = "/ofertas/avanzaOferta";
	static final String WEB_SERVICE_OPERACION_VENTA= "/operacionventa";
	static final String WEB_SERVICE_PORTALES = "/portales";
	static final String WEB_SERVICE_PROPUESTA_RESOLUCION = "/propuestaresolucion";
	static final String WEB_SERVICE_REINTEGRO = "/reintegro";
	static final String WEB_SERVICE_RESERVA = "/reserva";
	static final String WEB_SERVICE_RESOLUCION_COMITE = "/resolucioncomite";
	static final String WEB_SERVICE_TAREAS_AVANZA = "/tareas/avanza";
	static final String WEB_SERVICE_TRABAJO = "/trabajo";
	static final String WEB_SERVICE_TRABAJO_ACT_TECNICAS= "/trabajo/getActuacionesTecnicas";
	static final String WEB_SERVICE_AVANZA_TRABAJO = "/avanzaTrabajo";
	static final String WEB_SERVICE_VISITAS = "/visitas";

	static final String WEB_SERVICE_OFERTAS_VIVAS = "ofertas/getOfertasVivasActGestoria";
	static final String WEB_SERVICE_OFERTAS_CONTRASTE = "ofertas/avanzarTareaContrasteListas";
	static final String WEB_SERVICE_OFERTAS_LLAMADA_PBC = "ofertas/llamadaPBC";
	


	

	public void registerLog(LogDevoWebServiceDto dto);

}