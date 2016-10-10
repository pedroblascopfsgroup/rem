package es.pfsgroup.plugin.rem.gastosExpediente;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.api.GastosExpedienteApi;
import es.pfsgroup.plugin.rem.gastosExpediente.dao.GastosExpedienteDao;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.ComisionDto;
import net.sf.json.JSONObject;

@Service("gastosExpedienteManager")
public class GastosExpedienteManager extends BusinessOperationOverrider<GastosExpedienteApi>
		implements GastosExpedienteApi {

	protected static final Log logger = LogFactory.getLog(GastosExpedienteManager.class);

	@Autowired
	private RestApi restApi;

	@Autowired
	private GenericABMDao genericDao;

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
	public List<String> validateComisionPostRequestData(ComisionDto comisionDto) {
		List<String> listaErrores = new ArrayList<String>();
		GastosExpediente gasto = null;

		try {

			// Validación parámetros entrada
			HashMap<String, List<String>> error = restApi.validateRequestObject(comisionDto);
			if (!Checks.esNulo(error) && !error.isEmpty()) {
				listaErrores
						.add("No se cumple la especificación de parámetros para la comision con los siguientes datos: idOfertaRem-"
								+ comisionDto.getIdOfertaRem() + " idOfertaWebcom-" + comisionDto.getIdOfertaWebcom()
								+ " idProveedorRem-" + comisionDto.getIdProveedorRem() + " esPrescripcion-"
								+ comisionDto.getEsPrescripcion() + " esColaboracion-" + comisionDto.getEsColaboracion()
								+ " esResponsable-" + comisionDto.getEsResponsable() + " esFdv-"
								+ comisionDto.getEsFdv() + " .Traza: " + error);
			}

			if (!Checks.esNulo(comisionDto.getIdOfertaRem())) {
				Oferta oferta = (Oferta) genericDao.get(Oferta.class,
						genericDao.createFilter(FilterType.EQUALS, "numOferta", comisionDto.getIdOfertaRem()));
				if (Checks.esNulo(oferta)) {
					listaErrores.add("No existe la oferta en REM especificada en el campo idOfertaRem: "
							+ comisionDto.getIdOfertaRem());
				}
			}

			if (!Checks.esNulo(comisionDto.getIdProveedorRem())) {
				ActivoProveedor pve = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
						genericDao.createFilter(FilterType.EQUALS, "id", comisionDto.getIdProveedorRem()));
				if (Checks.esNulo(pve)) {
					listaErrores.add("No existe el proveedor en REM especificado en el campo idProveedorRem: "
							+ comisionDto.getIdProveedorRem());
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			listaErrores
					.add("Ha ocurrido un error al validar los parámetros de la comision con los siguientes datos: idOfertaRem-"
							+ comisionDto.getIdOfertaRem() + " idOfertaWebcom-" + comisionDto.getIdOfertaWebcom()
							+ " idProveedorRem-" + comisionDto.getIdProveedorRem() + " esPrescripcion-"
							+ comisionDto.getEsPrescripcion() + " esColaboracion-" + comisionDto.getEsColaboracion()
							+ " esResponsable-" + comisionDto.getEsResponsable() + " esFdv-" + comisionDto.getEsFdv()
							+ ". Traza: " + e.getMessage());
			return listaErrores;
		}

		return listaErrores;
	}

	@Override
	@Transactional(readOnly = false)
	public List<String> updateAceptacionGasto(GastosExpediente gasto, ComisionDto comisionDto, Object jsonFields) {
		List<String> errorsList = null;

		try {

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

		} catch (Exception e) {
			logger.error(e);
			logger.error(
					"Ha ocurrido un error en base de datos al actualizar la comision con los siguientes datos: idOfertaRem-"
							+ comisionDto.getIdOfertaRem() + " idOfertaWebcom-" + comisionDto.getIdOfertaWebcom()
							+ " idProveedorRem-" + comisionDto.getIdProveedorRem() + " esPrescripcion-"
							+ comisionDto.getEsPrescripcion() + " esColaboracion-" + comisionDto.getEsColaboracion()
							+ " esResponsable-" + comisionDto.getEsResponsable() + " esFdv-" + comisionDto.getEsFdv()
							+ ". Traza: " + e.getMessage());
		}

		return errorsList;
	}

}
