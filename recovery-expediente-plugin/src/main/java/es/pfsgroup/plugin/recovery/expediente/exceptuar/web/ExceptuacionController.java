package es.pfsgroup.plugin.recovery.expediente.exceptuar.web;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.exceptuar.api.ExceptuacionApi;
import es.capgemini.pfs.exceptuar.dto.DtoExceptuacion;
import es.capgemini.pfs.exceptuar.model.Exceptuacion;
import es.capgemini.pfs.exceptuar.model.ExceptuacionMotivo;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.expediente.incidencia.dto.DtoIncidenciaExpediente;

/**
 * Controlador que atiende las peticiones de las pantallas de incidencias
 * expedientes.
 * 
 */
@Controller
public class ExceptuacionController {

	static final String DEFAULT_JSON = "plugin/expediente/defaultJSON";
	static final String EXISTE_EXCEPTUACION_JSON = "plugin/expediente/exceptuacion/json/existeExceptuacionJSON";
	static final String EXCEPTUACION_JSON = "plugin/expediente/exceptuacion/json/exceptuacionJSON";
	static final String VENTANA_EXCEPTUACION_PERSONA = "plugin/expediente/exceptuacion/cliente/button/ventanaExceptuacionPersona";
	static final String VENTANA_EXCEPTUACION_CONTRATO = "plugin/expediente/exceptuacion/contrato/button/ventanaExceptuacionContrato";
	static final String VENTANA_EXCEPTUACION = "plugin/expediente/exceptuacion/ventanaExceptuacion";

	@Autowired
	private ApiProxyFactory proxyFactory;

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abrirVentanaExceptuacion(ModelMap model, Long id, String tipo) {

		model.put("id", id);
		model.put("tipo", tipo);

//		if (DtoExceptuacion.TIPO_PERSONA.equals(tipo)) {
//			return VENTANA_EXCEPTUACION_PERSONA;
//		} else if (DtoExceptuacion.TIPO_CONTRATO.equals(tipo)) {
//			return VENTANA_EXCEPTUACION_CONTRATO;
//		}

		return VENTANA_EXCEPTUACION;

	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getExceptuacion(ModelMap model, DtoExceptuacion dto) {

		Exceptuacion exc = proxyFactory.proxy(ExceptuacionApi.class).getExceptuacionByIdTipo(dto.getIdEntidad(), dto.getTipo());

		model.put("fechaHasta", exc.getFechaHasta());
		model.put("idMotivo", exc.getMotivo().getId());
		model.put("descripcionMotivo", exc.getMotivo().getDescripcion());
		model.put("comentarios", exc.getComentario());
		model.put("excId", exc.getId());

		return EXCEPTUACION_JSON;
	}

	@RequestMapping
	public String guardarExceptuacion(ModelMap model, DtoExceptuacion dto) {

		proxyFactory.proxy(ExceptuacionApi.class).guardarExceptuacion(dto);
		return "default";
	}

	@RequestMapping
	public String borrarExceptuacion(ModelMap model, Long excId) {

		proxyFactory.proxy(ExceptuacionApi.class).borrarExceptuacion(excId);
		return "default";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListadoMotivosExceptuacion(ModelMap model, DtoIncidenciaExpediente dto) {

		List<ExceptuacionMotivo> listado = proxyFactory.proxy(ExceptuacionApi.class).getListadoMotivosExceptuacion();
		model.put("listado", listado);

		return DEFAULT_JSON;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String existeExceptuacion(ModelMap model, Long id, String tipo) {

		Boolean existe = proxyFactory.proxy(ExceptuacionApi.class).existeExceptuacion(id, tipo);
		model.put("existe", existe);

		return EXISTE_EXCEPTUACION_JSON;
	}

}
