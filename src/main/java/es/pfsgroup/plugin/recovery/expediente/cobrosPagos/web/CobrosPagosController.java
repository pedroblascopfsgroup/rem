package es.pfsgroup.plugin.recovery.expediente.cobrosPagos.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.expediente.cobrosPagos.api.CobrosPagosApi;
import es.pfsgroup.plugin.recovery.expediente.cobrosPagos.dto.DtoCobrosPagos;
import es.pfsgroup.plugin.recovery.expediente.cobrosPagos.model.RecobroPagoContrato;

/**
 * Controlador que atiende las peticiones de las pantallas de cobros pagos
 * 
 */
@Controller
public class CobrosPagosController {

	static final String DEFAULT_JSON = "plugin/expediente/defaultJSON";
	static final String COBROS_PAGOS_JSON = "plugin/expediente/cobrosPagos/cobrosPagosJSON";
	static final String COBROS_PAGOS_DETALLE = "plugin/expediente/cobrosPagos/cobrosPagosDetalle";

	@Autowired
	private ApiProxyFactory proxyFactory;

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListadoCobrosPagos(ModelMap model, DtoCobrosPagos dto) {

		Page listado = proxyFactory.proxy(CobrosPagosApi.class).getListadoCobrosPagos(dto);
		model.put("listado", listado);

		return COBROS_PAGOS_JSON;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getDetalleCobroPago(ModelMap model, DtoCobrosPagos dto) {

		RecobroPagoContrato cop = proxyFactory.proxy(CobrosPagosApi.class).getDetalleCobroPago(dto);
		model.put("cop", cop);

		return COBROS_PAGOS_DETALLE;
	}

}
