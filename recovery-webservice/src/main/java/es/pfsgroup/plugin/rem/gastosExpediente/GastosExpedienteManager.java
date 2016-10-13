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

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
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
				throw new Exception("El campo id es obligatorio.");
			} else {
				gasto = gastosExpedienteDao.get(id);
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return gasto;
	}

	@Override
	public List<GastosExpediente> getListaGastosExpediente(ComisionDto comisionDto) {
		List<GastosExpediente> lista = null;

		try {

			lista = gastosExpedienteDao.getListaGastosExpediente(comisionDto);

		} catch (Exception ex) {
			ex.printStackTrace();
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
		HashMap<String, List<String>> errorsList = null;
		for (int i = 0; i < listaComisionDto.size(); i++) {

			map = new HashMap<String, Object>();
			ComisionDto comisionDto = listaComisionDto.get(i);

			List<GastosExpediente> listaGastos = this.getListaGastosExpediente(comisionDto);
			if (Checks.esNulo(listaGastos) || (!Checks.esNulo(listaGastos) && listaGastos.size() != 1)) {
				restApi.obtenerMapaErrores(errorsList, "idOfertaWebcom").add(RestApi.REST_MSG_UNKNOWN_KEY);

			} else {
				errorsList = restApi.validateRequestObject(listaGastos.get(0), TIPO_VALIDACION.INSERT);
				if (errorsList.size() == 0) {
					this.updateAceptacionGasto(listaGastos.get(0), comisionDto, jsonFields.getJSONArray("data").get(i));
				}

			}

			if (!Checks.esNulo(errorsList) && errorsList.isEmpty() && !Checks.esNulo(listaGastos)) {
				map.put("idOfertaWebcom", listaGastos.get(0).getExpediente().getOferta().getIdWebCom());
				map.put("idOfertaRem", listaGastos.get(0).getExpediente().getOferta().getNumOferta());
				map.put("success", true);
			} else {
				map.put("idOfertaWebcom", comisionDto.getIdOfertaWebcom());
				map.put("idOfertaRem", comisionDto.getIdOfertaRem());
				map.put("success", false);
				map.put("invalidFields", errorsList);
			}
			listaRespuesta.add(map);

		}
		return listaRespuesta;

	}

}
