package es.pfsgroup.plugin.rem.gastosExpediente;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.exception.UserException;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.api.GastosExpedienteApi;
import es.pfsgroup.plugin.rem.gastosExpediente.dao.GastosExpedienteDao;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.ComisionDto;
import net.sf.json.JSONObject;

@Service("gastosExpedienteManager")
public class GastosExpedienteManager extends BusinessOperationOverrider<GastosExpedienteApi>
		implements GastosExpedienteApi {

	protected static final Log logger = LogFactory.getLog(GastosExpedienteManager.class);

	@Autowired
	private RestApi restApi;

	@Autowired
	private GastosExpedienteDao gastosExpedienteDao;

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public String managerName() {
		return "gastosExpedienteManager";
	}

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Override
	public GastosExpediente findOne(Long id) {
		GastosExpediente gasto = null;

		try {
			if (Checks.esNulo(id)) {
				throw new UserException("El campo id es obligatorio.");
			} else {
				gasto = gastosExpedienteDao.get(id);
			}

		} catch (Exception ex) {
			logger.error(ex.getMessage(),ex);
		}

		return gasto;
	}

	@Override
	public List<GastosExpediente> getListaGastosExpediente(ComisionDto comisionDto) {
		List<GastosExpediente> lista = null;

		try {

			lista = gastosExpedienteDao.getListaGastosExpediente(comisionDto);

		} catch (Exception ex) {
			logger.error(ex.getMessage(),ex);
		}

		return lista;
	}

	@Override
	@Transactional(readOnly = false)
	public void updateAceptacionGasto(GastosExpediente gasto, ComisionDto comisionDto, Object jsonFields) {
		if (((JSONObject) jsonFields).containsKey("observaciones")) {
			gasto.setObservaciones(comisionDto.getObservaciones());
		}
		if (((JSONObject) jsonFields).containsKey("aceptacion")) {
			if (!Checks.esNulo(comisionDto.getAceptacion())) {
				if (comisionDto.getAceptacion()) {
					gasto.setAprobado(Integer.valueOf(1));
				} else {
					gasto.setAprobado(Integer.valueOf(0));
				}
			} else {
				gasto.setAprobado(null);
			}
		}

		gastosExpedienteDao.saveOrUpdate(gasto);

	}

	@Override
	@Transactional(readOnly = false)
	public ArrayList<Map<String, Object>> updateAceptacionesGasto(List<ComisionDto> listaComisionDto,
			JSONObject jsonFields) {
		Map<String, Object> map = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		HashMap<String, String> errorsList = null;
		for (int i = 0; i < listaComisionDto.size(); i++) {

			map = new HashMap<String, Object>();
			ComisionDto comisionDto = listaComisionDto.get(i);
			errorsList = restApi.validateRequestObject(comisionDto, TIPO_VALIDACION.INSERT);
			boolean succes = false;
			GastosExpediente gasto = null;
			if (Checks.esNulo(errorsList) || errorsList.isEmpty()) {
				try {
					gasto = this.findOne(comisionDto.getIdComisionRem());
					this.updateAceptacionGasto(gasto, comisionDto, jsonFields.getJSONArray("data").get(i));
					succes = true;
				} catch (Exception e) {
					succes = false;
					logger.error("error aceptando el gasto", e);
				}

			}
			if (succes) {
				map.put("idComisionRem", gasto.getId());
				map.put("idOfertaWebcom", gasto.getExpediente().getOferta().getIdWebCom());
				map.put("idOfertaRem", gasto.getExpediente().getOferta().getNumOferta());
				map.put("idProveedorRem", comisionDto.getIdProveedorRem());
				map.put("esPrescripcion", comisionDto.getEsPrescripcion());
				map.put("esColaboracion", comisionDto.getEsColaboracion());
				map.put("esResponsable", comisionDto.getEsResponsable());
				map.put("esFdv", comisionDto.getEsFdv());
				map.put("esDoblePrescripcion", comisionDto.getEsDoblePrescripcion());
				map.put("success", succes);
			} else {
				map.put("idComisionRem", comisionDto.getIdComisionRem());
				map.put("idOfertaWebcom", comisionDto.getIdOfertaWebcom());
				map.put("idOfertaRem", comisionDto.getIdOfertaRem());
				map.put("idProveedorRem", comisionDto.getIdProveedorRem());
				map.put("esPrescripcion", comisionDto.getEsPrescripcion());
				map.put("esColaboracion", comisionDto.getEsColaboracion());
				map.put("esResponsable", comisionDto.getEsResponsable());
				map.put("esFdv", comisionDto.getEsFdv());
				map.put("esDoblePrescripcion", comisionDto.getEsDoblePrescripcion());
				map.put("success", succes);
				map.put("invalidFields", errorsList);
			}

			listaRespuesta.add(map);

		}
		return listaRespuesta;

	}

	@Override
	@Transactional(readOnly = false)
	public GastosExpediente getGastoExpedienteByActivoYAccion(Long idActivo, Long idExpediente, String accion) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "accionGastos.codigo", accion);
		Filter filtro4 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);

		return genericDao.get(GastosExpediente.class, filtro, filtro2, filtro3, filtro4);
	}

	@Override
	@Transactional(readOnly = false)
	public void deleteGastosExpediente(Long idExpediente) {

		List<GastosExpediente> gastos = genericDao.getList(GastosExpediente.class,
				genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente),
				genericDao.createFilter(FilterType.EQUALS, "editado", Integer.valueOf(0)));

		if (gastos != null && !gastos.isEmpty()) {
			for (GastosExpediente gasto : gastos) {
				genericDao.deleteById(GastosExpediente.class, gasto.getId());
			}
		}
	}
}
