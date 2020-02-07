package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;

import es.pfsgroup.plugin.rem.activoproveedor.dao.ActivoProveedorDao;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoOfertaDto;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.DetectorCambiosBD;
import es.pfsgroup.plugin.rem.restclient.webcom.ServiciosWebcomManager;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Component
public class DetectorWebcomEstadoOferta extends DetectorCambiosBD<EstadoOfertaDto> {

	@Autowired
	private ServiciosWebcomManager serviciosWebcom;

	@Autowired
	private RestApi restApi;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private OfertaDao ofertaDao;

	@Autowired
	private ActivoProveedorDao activoProveedorDao;

	private final Log logger = LogFactory.getLog(getClass());

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

	@Override
	public String nombreVistaDatosActuales() {
		return "REM01.VI_OFERTAS_WEBCOM";
	}

	@Override
	public String nombreTablaDatosHistoricos() {
		return "REM01.OWH_OFERTAS_WEBCOM_HIST";
	}

	@Override
	public String clavePrimaria() {
		return "ID_OFERTA_PK";
	}

	@Override
	protected EstadoOfertaDto createDtoInstance() {
		return new EstadoOfertaDto();
	}

	@Override
	public JSONObject invocaServicio(List<EstadoOfertaDto> data, RestLlamada registro) throws ErrorServicioWebcom {
		return serviciosWebcom.webcomRestEstadoOferta(data, registro);
	}

	@Override
	protected Integer getWeight() {
		return 9991;
	}

	@Override
	public boolean isActivo() {
		return true;
	}

	@Override
	public String clavePrimariaJson() {
		return "ID_OFERTA_REM";
	}

	@Override
	public List<String> vistasAuxiliares() {
		return null;
	}

	@Override
	public Boolean procesarSoloCambiosMarcados() {
		return false;
	}

	@Override
	public void procesaResultado(JSONObject resultado) {
		restApi.trace("[DETECCIÓN CAMBIOS] Procesando la respuesta");

		if (resultado.getJSONArray("data") instanceof JSONArray) {
			for (int i = 0; i < resultado.getJSONArray("data").size(); i++) {
				JSONObject oferta = (JSONObject) resultado.getJSONArray("data").get(i);
				if (oferta.containsKey("idOfertaRem")) {
					Oferta ofertaEntity = ofertaApi.getOfertaByNumOfertaRem(oferta.getLong("idOfertaRem"));
					if (ofertaEntity != null) {
						modificaOferta(oferta, ofertaEntity);
					}
				}
			}
		}

	}

	private void modificaOferta(JSONObject oferta, Oferta ofertaEntity) {
		Boolean actualizar = false;
		if (oferta.containsKey("success") && oferta.getBoolean("success")) {
			if (oferta.containsKey("idProveedorPrescriptorRemOrigenLead")) {
				ActivoProveedor proveedor = activoProveedorDao.getProveedorByCodigoRem(oferta.getLong("idProveedorPrescriptorRemOrigenLead"));
				if (proveedor != null) {
					ofertaEntity.setProveedorPrescriptorRemOrigenLead(proveedor);
					actualizar = true;
				}
			}
			if (oferta.containsKey("fechaOrigenLead")) {
				ofertaEntity.setFechaOrigenLead(getFechaOrigenLead(oferta));
				actualizar = true;
			}
			if (oferta.containsKey("codTipoProveedorOrigenCliente")) {
				ofertaEntity.setCodTipoProveedorOrigenCliente(oferta.getString("codTipoProveedorOrigenCliente"));
				actualizar = true;

			}
			if (oferta.containsKey("idProveedorRealizadorRemOrigenLead")) {
				ActivoProveedor proveedor = activoProveedorDao.getProveedorByCodigoRem(oferta.getLong("idProveedorRealizadorRemOrigenLead"));
				if (proveedor != null) {
					ofertaEntity.setProveedorRealizadorRemOrigenLead(proveedor);
					actualizar = true;
				}

			}
			if (actualizar) {
				ofertaDao.guardaRegistroWebcom(ofertaEntity);
			}
		}
	}

	private Date getFechaOrigenLead(JSONObject oferta) {
		Date fechaOrigenLead = null;
		try {
			String dateStr = oferta.getString("fechaOrigenLead");
			if (dateStr != null && !dateStr.equals("")) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
				fechaOrigenLead = sdf.parse(dateStr);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		return fechaOrigenLead;
	}
}
