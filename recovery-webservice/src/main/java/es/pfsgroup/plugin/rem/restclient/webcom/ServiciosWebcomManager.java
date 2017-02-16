package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.ServiciosWebcomApi;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ActivoObrasNuevasDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.CabeceraObrasNuevasDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.CampanyaObrasNuevasDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ComisionesDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoOfertaDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoTrabajoDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.InformeMediadorDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.NotificacionDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ProveedorDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.UsuarioDto;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebcomGenerico;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.WebcomEndpoint;

@Service
public class ServiciosWebcomManager extends ServiciosWebcomBaseManager implements ServiciosWebcomApi {

	final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ClienteWebcomGenerico clienteWebcom;
	
	@Resource
	private Properties appProperties;

	@Override
	public void webcomRestEstadoPeticionTrabajo(List<EstadoTrabajoDto> estadoTrabajo) throws ErrorServicioWebcom {
		this.webcomRestEstadoPeticionTrabajo(estadoTrabajo, null);
	}
	
	public void webcomRestEstadoPeticionTrabajo(List<EstadoTrabajoDto> estadoTrabajo, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Estado Trabajo");

		ParamsList paramsList = createParamsList(estadoTrabajo);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(WebcomEndpoint.estadoPeticionTrabajo(appProperties), paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}
	}

	@Override
	public void webcomRestEstadoOferta(List<EstadoOfertaDto> estadoOferta) throws ErrorServicioWebcom {
		this.webcomRestEstadoOferta(estadoOferta, null);
	}
	
	
	public void webcomRestEstadoOferta(List<EstadoOfertaDto> estadoOferta, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Estado Oferta");
 
		ParamsList paramsList = createParamsList(estadoOferta);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(WebcomEndpoint.estadoOferta(appProperties), paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}

	}

	@Override
	public void webcomRestStock(List<StockDto> stock) throws ErrorServicioWebcom {
		this.webcomRestStock(stock, null);
	}
	
	public void webcomRestStock(List<StockDto> stock, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Stock");

		ParamsList paramsList = createParamsList(stock);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(WebcomEndpoint.stock(appProperties),paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}

	}

	@Override
	public void webcomRestEstadoNotificacion(List<NotificacionDto> notificaciones) throws ErrorServicioWebcom {
		this.webcomRestEstadoNotificacion(notificaciones, null);
	}
	
	public void webcomRestEstadoNotificacion(List<NotificacionDto> notificaciones, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Estado notificaciones");

		ParamsList paramsList = createParamsList(notificaciones);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(WebcomEndpoint.estadoNotificacion(appProperties), paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}

	}

	@Override
	public void webcomRestVentasYcomisiones(List<ComisionesDto> comisiones) throws ErrorServicioWebcom {
		this.webcomRestVentasYcomisiones(comisiones, null);
	}
	
	public void webcomRestVentasYcomisiones(List<ComisionesDto> comisiones, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Ventas y Comisiones");

		ParamsList paramsList = createParamsList(comisiones);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(WebcomEndpoint.ventasYcomisiones(appProperties), paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}

	}

	@Override
	public void webcomRestProveedores(List<ProveedorDto> proveedores) throws ErrorServicioWebcom {
		this.webcomRestProveedores(proveedores, null);
	}
	
	public void webcomRestProveedores(List<ProveedorDto> proveedores, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Envio datos Proveedores");

		ParamsList paramsList = createParamsList(proveedores);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(WebcomEndpoint.proveedores(appProperties), paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}

	}

	@Override
	public void webcomRestEstadoInformeMediador(List<InformeMediadorDto> informes) throws ErrorServicioWebcom {
		this.webcomRestEstadoInformeMediador(informes, null);
	}
	
	public void webcomRestEstadoInformeMediador(List<InformeMediadorDto> informes, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Envio cambios estado Informe Mediador");

		ParamsList paramsList = createParamsList(informes);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(WebcomEndpoint.estadoInformeMediador(appProperties), paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}

	}

	@Override
	public void webcomRestCabeceraObrasNuevas(List<CabeceraObrasNuevasDto> cabeceras) throws ErrorServicioWebcom {
		this.webcomRestCabeceraObrasNuevas(cabeceras, null);
	}
	
	public void webcomRestCabeceraObrasNuevas(List<CabeceraObrasNuevasDto> cabeceras, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Envio Cabeceras Obras Nuevas");

		ParamsList paramsList = createParamsList(cabeceras);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(WebcomEndpoint.cabecerasObrasNuevas(appProperties),paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}

	}

	@Override
	public void webcomRestActivosObrasNuevas(List<ActivoObrasNuevasDto> activos) throws ErrorServicioWebcom {
		this.webcomRestActivosObrasNuevas(activos, null);
	}
	
	public void webcomRestActivosObrasNuevas(List<ActivoObrasNuevasDto> activos, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Envio Activos Obras Nuevas");

		ParamsList paramsList = createParamsList(activos);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(WebcomEndpoint.activosObrasNuevas(appProperties), paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}

	}
	
	@Override
	public void webcomRestUsuarios(List<UsuarioDto> usuarios) throws ErrorServicioWebcom {
		this.webcomRestUsuarios(usuarios, null);
	}
	
	public void webcomRestUsuarios(List<UsuarioDto> usuarios, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Envio Usuarios");

		ParamsList paramsList = createParamsList(usuarios);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(WebcomEndpoint.usuarios(appProperties),paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}
		
	}

	@Override
	public void webcomRestObrasNuevasCampanyas(List<CampanyaObrasNuevasDto> campanyas) throws ErrorServicioWebcom {
		this.webcomRestObrasNuevasCampanyas(campanyas, null);
	}
	
	public void webcomRestObrasNuevasCampanyas(List<CampanyaObrasNuevasDto> campanyas, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Envio Obras Nuevas Campanyas");

		ParamsList paramsList = createParamsList(campanyas);

		if (!paramsList.isEmpty()) {
			invocarServicioRestWebcom(WebcomEndpoint.obrasNuevasCampanyas(appProperties), paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}
	}

	@Override
	protected ClienteWebcomGenerico getClienteWebcom() {
		return this.clienteWebcom;
	}

	public void setClienteWebcom(ClienteWebcomGenerico clienteWebcom) {
		this.clienteWebcom = clienteWebcom;
	}

}
