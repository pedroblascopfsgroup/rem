package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.ArrayList;
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
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ConductasInapropiadasDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.DelegacionDto;
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
import net.sf.json.JSONObject;

@Service
public class ServiciosWebcomManager extends ServiciosWebcomBaseManager implements ServiciosWebcomApi {

	final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ClienteWebcomGenerico clienteWebcom;
	
	@Resource
	private Properties appProperties;

	@Override
	public JSONObject webcomRestEstadoPeticionTrabajo(List<EstadoTrabajoDto> estadoTrabajo) throws ErrorServicioWebcom {
		return this.webcomRestEstadoPeticionTrabajo(estadoTrabajo, null);
	}
	
	public JSONObject webcomRestEstadoPeticionTrabajo(List<EstadoTrabajoDto> estadoTrabajo, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Estado Trabajo");
		JSONObject result = null;

		ParamsList paramsList = createParamsList(estadoTrabajo);

		if (!paramsList.isEmpty()) {
			result = invocarServicioRestWebcom(WebcomEndpoint.estadoPeticionTrabajo(appProperties), paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}
		return result;
	}

	@Override
	public JSONObject webcomRestEstadoOferta(List<EstadoOfertaDto> estadoOferta) throws ErrorServicioWebcom {
		return this.webcomRestEstadoOferta(estadoOferta, null);
	}
	
	
	public JSONObject webcomRestEstadoOferta(List<EstadoOfertaDto> estadoOferta, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Estado Oferta");
		JSONObject result = null;
 
		ParamsList paramsList = createParamsList(estadoOferta);

		if (!paramsList.isEmpty()) {
			result = invocarServicioRestWebcom(WebcomEndpoint.estadoOferta(appProperties), paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}
		return result;
	}

	@Override
	public JSONObject webcomRestStock(List<StockDto> stock) throws ErrorServicioWebcom {
		return this.webcomRestStock(stock, null);
	}
	
	public JSONObject webcomRestStock(List<StockDto> stock, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Stock");
		JSONObject result = null;

		ParamsList paramsList = createParamsList(stock);

		if (!paramsList.isEmpty()) {
			result = invocarServicioRestWebcom(WebcomEndpoint.stock(appProperties),paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}
		return result;
	}

	@Override
	public JSONObject webcomRestEstadoNotificacion(List<NotificacionDto> notificaciones) throws ErrorServicioWebcom {
		return this.webcomRestEstadoNotificacion(notificaciones, null);
	}
	
	public JSONObject webcomRestEstadoNotificacion(List<NotificacionDto> notificaciones, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Estado notificaciones");
		JSONObject result = null;

		ParamsList paramsList = createParamsList(notificaciones);

		if (!paramsList.isEmpty()) {
			result = invocarServicioRestWebcom(WebcomEndpoint.estadoNotificacion(appProperties), paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}
		return result;
	}

	@Override
	public JSONObject webcomRestVentasYcomisiones(List<ComisionesDto> comisiones) throws ErrorServicioWebcom {
		return this.webcomRestVentasYcomisiones(comisiones, null);
	}
	
	public JSONObject webcomRestVentasYcomisiones(List<ComisionesDto> comisiones, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Ventas y Comisiones");
		JSONObject result = null;

		ParamsList paramsList = createParamsList(comisiones);

		if (!paramsList.isEmpty()) {
			result = invocarServicioRestWebcom(WebcomEndpoint.ventasYcomisiones(appProperties), paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}
		return result;
	}

	@Override
	public JSONObject webcomRestProveedores(List<ProveedorDto> proveedores) throws ErrorServicioWebcom {
		return this.webcomRestProveedores(proveedores, null);
	}
	
	public JSONObject webcomRestProveedores(List<ProveedorDto> proveedores, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Envio datos Proveedores");
		JSONObject result = null;
	
		for (ProveedorDto proveedorDto: proveedores) {
			List<ConductasInapropiadasDto> conductaInapropiadasDtoList = proveedorDto.getConductasInapropiadas();
			List<DelegacionDto> delegacionDtoList = proveedorDto.getDelegaciones();
	
			for (ConductasInapropiadasDto conductaInapropiadasDto : conductaInapropiadasDtoList) {
				if(conductaInapropiadasDto.getIdConductaInapropiada().getValue() == null) {
					proveedorDto.setConductasInapropiadas(null);
					break;
				}
			}
			
			for (DelegacionDto delegacionDto : delegacionDtoList) {
				if(delegacionDto.getIdDelegacion().getValue() == null) {
					proveedorDto.setDelegaciones(null);
					break;
				}
			}
		}

		ParamsList paramsList = createParamsList(proveedores);

		if (!paramsList.isEmpty()) {
			result = invocarServicioRestWebcom(WebcomEndpoint.proveedores(appProperties), paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}
		return result;
	}

	@Override
	public JSONObject webcomRestEstadoInformeMediador(List<InformeMediadorDto> informes) throws ErrorServicioWebcom {
		return this.webcomRestEstadoInformeMediador(informes, null);
	}
	
	public JSONObject webcomRestEstadoInformeMediador(List<InformeMediadorDto> informes, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Envio cambios estado Informe Mediador");
		JSONObject result = null;

		ParamsList paramsList = createParamsList(informes);

		if (!paramsList.isEmpty()) {
			result = invocarServicioRestWebcom(WebcomEndpoint.estadoInformeMediador(appProperties), paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}
		return result;
	}

	@Override
	public JSONObject webcomRestCabeceraObrasNuevas(List<CabeceraObrasNuevasDto> cabeceras) throws ErrorServicioWebcom {
		return this.webcomRestCabeceraObrasNuevas(cabeceras, null);
	}
	
	public JSONObject webcomRestCabeceraObrasNuevas(List<CabeceraObrasNuevasDto> cabeceras, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Envio Cabeceras Obras Nuevas");
		JSONObject result = null;

		ParamsList paramsList = createParamsList(cabeceras);

		if (!paramsList.isEmpty()) {
			result = invocarServicioRestWebcom(WebcomEndpoint.cabecerasObrasNuevas(appProperties),paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}
		return result;
	}

	@Override
	public JSONObject webcomRestActivosObrasNuevas(List<ActivoObrasNuevasDto> activos) throws ErrorServicioWebcom {
		return this.webcomRestActivosObrasNuevas(activos, null);
	}
	
	public JSONObject webcomRestActivosObrasNuevas(List<ActivoObrasNuevasDto> activos, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Envio Activos Obras Nuevas");
		JSONObject result = null;

		ParamsList paramsList = createParamsList(activos);

		if (!paramsList.isEmpty()) {
			result = invocarServicioRestWebcom(WebcomEndpoint.activosObrasNuevas(appProperties), paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}
		return result;
	}
	
	@Override
	public JSONObject webcomRestUsuarios(List<UsuarioDto> usuarios) throws ErrorServicioWebcom {
		return this.webcomRestUsuarios(usuarios, null);
	}
	
	public JSONObject webcomRestUsuarios(List<UsuarioDto> usuarios, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Envio Usuarios");
		JSONObject result = null;

		ParamsList paramsList = createParamsList(usuarios);

		if (!paramsList.isEmpty()) {
			result = invocarServicioRestWebcom(WebcomEndpoint.usuarios(appProperties),paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}
		return result;
	}

	@Override
	public JSONObject webcomRestObrasNuevasCampanyas(List<CampanyaObrasNuevasDto> campanyas) throws ErrorServicioWebcom {
		return this.webcomRestObrasNuevasCampanyas(campanyas, null);
	}
	
	public JSONObject webcomRestObrasNuevasCampanyas(List<CampanyaObrasNuevasDto> campanyas, RestLlamada registro) throws ErrorServicioWebcom {
		logger.trace("Invocando servicio Webcom: Envio Obras Nuevas Campanyas");
		JSONObject result = null;

		ParamsList paramsList = createParamsList(campanyas);

		if (!paramsList.isEmpty()) {
			result = invocarServicioRestWebcom(WebcomEndpoint.obrasNuevasCampanyas(appProperties), paramsList, registro);
		} else {
			logger.trace("ParamsList vacío. Nada que enviar");
		}
		return result;
	}

	@Override
	protected ClienteWebcomGenerico getClienteWebcom() {
		return this.clienteWebcom;
	}

	public void setClienteWebcom(ClienteWebcomGenerico clienteWebcom) {
		this.clienteWebcom = clienteWebcom;
	}

}
