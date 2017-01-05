package es.pfsgroup.plugin.rem.visita;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.VisitaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.DtoVisitasFilter;
import es.pfsgroup.plugin.rem.model.VBusquedaVisitasDetalle;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisita;
import es.pfsgroup.plugin.rem.model.dd.DDSubEstadosVisita;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.VisitaDto;
import es.pfsgroup.plugin.rem.visita.dao.VisitaDao;

@Service("visitaManager")
public class VisitaManager extends BusinessOperationOverrider<VisitaApi> implements VisitaApi {

	protected static final Log logger = LogFactory.getLog(VisitaManager.class);

	@Autowired
	private RestApi restApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private VisitaDao visitaDao;

	@Override
	public String managerName() {
		return "visitaManager";
	}

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Override
	public Visita getVisitaById(Long id) {
		Visita visita = null;

		try {

			visita = visitaDao.get(id);

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return visita;
	}

	@Override
	public Visita getVisitaByIdVisitaWebcom(Long idVisitaWebcom) {
		Visita visita = null;
		List<Visita> lista = null;
		VisitaDto visitaDto = null;

		try {

			if (Checks.esNulo(idVisitaWebcom)) {
				throw new Exception("El parámetro idVisitaWebcom es obligatorio.");

			} else {

				visitaDto = new VisitaDto();
				visitaDto.setIdVisitaWebcom(idVisitaWebcom);

				lista = visitaDao.getListaVisitas(visitaDto);
				if (!Checks.esNulo(lista) && lista.size() > 0) {
					visita = lista.get(0);
				}
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return visita;
	}

	@Override
	public Visita getVisitaByNumVisitaRem(Long numVisitaRem) {
		Visita visita = null;
		List<Visita> lista = null;
		VisitaDto visitaDto = null;

		try {

			if (Checks.esNulo(numVisitaRem)) {
				throw new Exception("El parámetro idVisitaRem es obligatorio.");

			} else {

				visitaDto = new VisitaDto();
				visitaDto.setIdVisitaRem(numVisitaRem);

				lista = visitaDao.getListaVisitas(visitaDto);
				if (!Checks.esNulo(lista) && lista.size() > 0) {
					visita = lista.get(0);
				}
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return visita;
	}

	@Override
	public Visita getVisitaByIdVisitaWebcomNumVisitaRem(Long idVisitaWebcom, Long numVisitaRem) throws Exception {
		Visita visita = null;
		List<Visita> lista = null;
		VisitaDto visitaDto = null;

		if (Checks.esNulo(idVisitaWebcom)) {
			throw new Exception("El parámetro idVisitaWebcom es obligatorio.");

		} else if (Checks.esNulo(numVisitaRem)) {
			throw new Exception("El parámetro idVisitaRem es obligatorio.");

		} else {

			visitaDto = new VisitaDto();
			visitaDto.setIdVisitaRem(numVisitaRem);
			visitaDto.setIdVisitaWebcom(idVisitaWebcom);

			lista = visitaDao.getListaVisitas(visitaDto);
			if (!Checks.esNulo(lista) && lista.size() > 0) {
				visita = lista.get(0);
			}
		}

		return visita;
	}

	@Override
	public DtoPage getListVisitas(DtoVisitasFilter dtoVisitasFilter) {

		return visitaDao.getListVisitas(dtoVisitasFilter);
	}

	@Override
	public List<Visita> getListaVisitas(VisitaDto visitaDto) {
		List<Visita> lista = null;

		try {

			lista = visitaDao.getListaVisitas(visitaDto);

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return lista;
	}

	@Override
	public HashMap<String, String> validateVisitaPostRequestData(VisitaDto visitaDto, Object jsonFields, Boolean alta)
			throws Exception {
		HashMap<String, String> hashErrores = null;

		if (alta) {
			hashErrores = restApi.validateRequestObject(visitaDto, TIPO_VALIDACION.INSERT);
		} else {
			hashErrores = restApi.validateRequestObject(visitaDto, TIPO_VALIDACION.UPDATE);
		}

		if (!Checks.esNulo(visitaDto.getIdClienteRem())) {
			ClienteComercial cliente = (ClienteComercial) genericDao.get(ClienteComercial.class,
					genericDao.createFilter(FilterType.EQUALS, "idClienteRem", visitaDto.getIdClienteRem()));
			if (Checks.esNulo(cliente)) {
				hashErrores.put("idClienteRem", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(visitaDto.getIdActivoHaya())) {
			Activo activo = (Activo) genericDao.get(Activo.class,
					genericDao.createFilter(FilterType.EQUALS, "numActivo", visitaDto.getIdActivoHaya()));
			if (Checks.esNulo(activo)) {
				hashErrores.put("idActivoHaya", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(visitaDto.getIdUsuarioRemAccion())) {
			Usuario user = (Usuario) genericDao.get(Usuario.class,
					genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdUsuarioRemAccion()));
			if (Checks.esNulo(user)) {
				hashErrores.put("idUsuarioRemAccion", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		if (!Checks.esNulo(visitaDto.getCodEstadoVisita())) {
			DDEstadosVisita estadoVis = (DDEstadosVisita) genericDao.get(DDEstadosVisita.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", visitaDto.getCodEstadoVisita()));
			if (Checks.esNulo(estadoVis)) {
				hashErrores.put("codEstadoVisita", RestApi.REST_MSG_UNKNOWN_KEY);
			}
		}
		
		if(Checks.esNulo(visitaDto.getCodDetalleEstadoVisita()) && !Checks.esNulo(visitaDto.getCodEstadoVisita()) && 
				(visitaDto.getCodEstadoVisita().equalsIgnoreCase(DDEstadosVisita.CODIGO_REALIZADA) || visitaDto.getCodEstadoVisita().equalsIgnoreCase(DDEstadosVisita.CODIGO_NO_REALIZADA))){
			//El codDetalleEstadoVisita solo es obligatorio si la visita está completada, es decir, estados "Realizada" y "No realizada".
			hashErrores.put("codDetalleEstadoVisita", RestApi.REST_MSG_MISSING_REQUIRED);
		}

		if (!Checks.esNulo(visitaDto.getCodDetalleEstadoVisita())) {
			DDSubEstadosVisita subEstVis = (DDSubEstadosVisita) genericDao.get(DDSubEstadosVisita.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", visitaDto.getCodDetalleEstadoVisita()));
			if (Checks.esNulo(subEstVis)) {
				hashErrores.put("codDetalleEstadoVisita", RestApi.REST_MSG_UNKNOWN_KEY);
			}else{
				if(Checks.esNulo(subEstVis.getEstadoVisita()) || 
				  (!Checks.esNulo(subEstVis.getEstadoVisita()) && !subEstVis.getEstadoVisita().getCodigo().equalsIgnoreCase(visitaDto.getCodEstadoVisita()))){
					hashErrores.put("codDetalleEstadoVisita", RestApi.REST_MSG_UNKNOWN_KEY);
				}
			}
		}
		if (!Checks.esNulo(visitaDto.getIdProveedorRemFdv())) {
			ActivoProveedor fdv = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
					genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemFdv()));
			if (Checks.esNulo(fdv)) {
				hashErrores.put("idProveedorRemFdv", RestApi.REST_MSG_UNKNOWN_KEY);
			}else {
				if(fdv.getTipoProveedor()==null || !fdv.getTipoProveedor().getCodigo().equals(DDTipoProveedor.COD_FUERZA_VENTA_DIRECTA)){
					hashErrores.put("idProveedorRemFdv", RestApi.REST_MSG_UNKNOWN_KEY);
				}
			}
		}
		if (!Checks.esNulo(visitaDto.getIdProveedorRemCustodio())) {
			ActivoProveedor cust = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
					genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemCustodio()));
			if (Checks.esNulo(cust)) {
				hashErrores.put("idProveedorRemCustodio", RestApi.REST_MSG_UNKNOWN_KEY);
			}
			/*else {
				//el proveedor tiene que ser custodio
				if ((cust.getCustodio() != null && !cust.getCustodio().equals(new Integer(1)))
						|| cust.getCustodio() == null) {
					hashErrores.put("idProveedorRemCustodio", RestApi.REST_MSG_UNKNOWN_KEY);
				}
			}*/
		}
	

		return hashErrores;
	}

	@Override
	@Transactional(readOnly = false)
	public HashMap<String, String> saveVisita(VisitaDto visitaDto) throws Exception {
		Visita visita = null;
		HashMap<String, String> errorsList = null;

		// ValidateAlta
		errorsList = validateVisitaPostRequestData(visitaDto, null, true);
		if (errorsList.isEmpty()) {

			visita = new Visita();
			beanUtilNotNull.copyProperties(visita, visitaDto);
			visita.setNumVisitaRem(visitaDao.getNextNumVisitaRem());

			if (!Checks.esNulo(visitaDto.getIdClienteRem())) {
				ClienteComercial cliente = (ClienteComercial) genericDao.get(ClienteComercial.class,
						genericDao.createFilter(FilterType.EQUALS, "idClienteRem", visitaDto.getIdClienteRem()));
				if (!Checks.esNulo(cliente)) {
					visita.setCliente(cliente);
				}
			}
			if (!Checks.esNulo(visitaDto.getIdActivoHaya())) {
				Activo activo = (Activo) genericDao.get(Activo.class,
						genericDao.createFilter(FilterType.EQUALS, "numActivo", visitaDto.getIdActivoHaya()));
				if (!Checks.esNulo(activo)) {
					visita.setActivo(activo);
				}
			}
			if (!Checks.esNulo(visitaDto.getIdUsuarioRemAccion())) {
				Usuario user = (Usuario) genericDao.get(Usuario.class,
						genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdUsuarioRemAccion()));
				if (!Checks.esNulo(user)) {
					visita.setUsuarioAccion(user);
				}
			}
			if (!Checks.esNulo(visitaDto.getCodEstadoVisita())) {
				DDEstadosVisita estadoVis = (DDEstadosVisita) genericDao.get(DDEstadosVisita.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", visitaDto.getCodEstadoVisita()));
				if (!Checks.esNulo(estadoVis)) {
					visita.setEstadoVisita(estadoVis);
				}
			}
			if (!Checks.esNulo(visitaDto.getCodDetalleEstadoVisita())) {
				DDSubEstadosVisita subEstVis = (DDSubEstadosVisita) genericDao.get(DDSubEstadosVisita.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", visitaDto.getCodDetalleEstadoVisita()));
				if (!Checks.esNulo(subEstVis)) {
					visita.setSubEstadoVisita(subEstVis);
				}
			}
			if (!Checks.esNulo(visitaDto.getIdProveedorRemPrescriptor())) {
				ActivoProveedor prescriptor = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
						genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemPrescriptor()));
				if (!Checks.esNulo(prescriptor)) {
					visita.setPrescriptor(prescriptor);
				}
			}

			if (!Checks.esNulo(visitaDto.getIdProveedorRemResponsable())) {
				ActivoProveedor apiResp = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
						genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemResponsable()));
				if (!Checks.esNulo(apiResp)) {
					visita.setApiResponsable(apiResp);
				}
			}

			if (!Checks.esNulo(visitaDto.getIdProveedorRemCustodio())) {
				ActivoProveedor apiCust = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
						genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemCustodio()));
				if (!Checks.esNulo(apiCust)) {
					visita.setApiCustodio(apiCust);
				}
			}
			if (!Checks.esNulo(visitaDto.getIdProveedorRemFdv())) {
				ActivoProveedor fdv = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
						genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemFdv()));
				if (!Checks.esNulo(fdv)) {
					visita.setFdv(fdv);
				}
			}
			if (!Checks.esNulo(visitaDto.getIdProveedorRemVisita())) {
				ActivoProveedor pveVisita = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
						genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemVisita()));
				if (!Checks.esNulo(pveVisita)) {
					visita.setProveedorVisita(pveVisita);
				}
			}
			if (!Checks.esNulo(visitaDto.getFechaAccion())) {
				visita.setFechaSolicitud(visitaDto.getFechaAccion());
			}

			if (!Checks.esNulo(visitaDto.getCodEstadoVisita()) && !Checks.esNulo(visitaDto.getFecha())) {
				if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_ALTA)) {
					visita.setFechaVisita(visitaDto.getFecha());
				} else if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_CONCERTADA)) {
					visita.setFechaConcertacion(visitaDto.getFecha());
				} else if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_CONTACTO)) {
					visita.setFechaContacto(visitaDto.getFecha());
				} else if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_REALIZADA)) {
					visita.setFechaVisita(visitaDto.getFecha());
				} else if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_NO_REALIZADA)) {
					visita.setFechaVisita(visitaDto.getFecha());
				}
			}

			visitaDao.save(visita);
		}

		return errorsList;
	}

	@Override
	@Transactional(readOnly = false)
	public HashMap<String, String> updateVisita(Visita visita, VisitaDto visitaDto, Object jsonFields)
			throws Exception {
		HashMap<String, String> errorsList = null;

		// ValidateUpdate
		errorsList = validateVisitaPostRequestData(visitaDto, jsonFields, false);
		if (errorsList.isEmpty()) {

			if (((JSONObject) jsonFields).containsKey("idClienteRem")) {
				if (!Checks.esNulo(visitaDto.getIdClienteRem())) {
					ClienteComercial cliente = (ClienteComercial) genericDao.get(ClienteComercial.class,
							genericDao.createFilter(FilterType.EQUALS, "idClienteRem", visitaDto.getIdClienteRem()));
					if (!Checks.esNulo(cliente)) {
						visita.setCliente(cliente);
					}
				} else {
					visita.setCliente(null);
				}
			} else {
				visita.setCliente(null);
			}

			if (((JSONObject) jsonFields).containsKey("idActivoHaya")) {
				if (!Checks.esNulo(visitaDto.getIdActivoHaya())) {
					Activo activo = (Activo) genericDao.get(Activo.class,
							genericDao.createFilter(FilterType.EQUALS, "numActivo", visitaDto.getIdActivoHaya()));
					if (!Checks.esNulo(activo)) {
						visita.setActivo(activo);
					}
				} else {
					visita.setActivo(null);
				}
			}
			if (((JSONObject) jsonFields).containsKey("codEstadoVisita")) {
				if (!Checks.esNulo(visitaDto.getCodEstadoVisita())) {
					DDEstadosVisita estadoVis = (DDEstadosVisita) genericDao.get(DDEstadosVisita.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", visitaDto.getCodEstadoVisita()));
					if (!Checks.esNulo(estadoVis)) {
						visita.setEstadoVisita(estadoVis);
					}
				} else {
					visita.setEstadoVisita(null);
				}
			}
			if (((JSONObject) jsonFields).containsKey("codDetalleEstadoVisita")) {
				if (!Checks.esNulo(visitaDto.getCodDetalleEstadoVisita())) {
					DDSubEstadosVisita subEstVis = (DDSubEstadosVisita) genericDao.get(DDSubEstadosVisita.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo",
									visitaDto.getCodDetalleEstadoVisita()));
					if (!Checks.esNulo(subEstVis)) {
						visita.setSubEstadoVisita(subEstVis);
					}
				} else {
					visita.setSubEstadoVisita(null);
				}
			}
			if (((JSONObject) jsonFields).containsKey("idUsuarioRemAccion")) {
				if (!Checks.esNulo(visitaDto.getIdUsuarioRemAccion())) {
					Usuario user = (Usuario) genericDao.get(Usuario.class,
							genericDao.createFilter(FilterType.EQUALS, "id", visitaDto.getIdUsuarioRemAccion()));
					if (!Checks.esNulo(user)) {
						visita.setUsuarioAccion(user);
					}
				} else {
					visita.setUsuarioAccion(null);
				}
			}
			if (((JSONObject) jsonFields).containsKey("idProveedorRemPrescriptor")) {
				if (!Checks.esNulo(visitaDto.getIdProveedorRemPrescriptor())) {
					ActivoProveedor prescriptor = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
							genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemPrescriptor()));
					if (!Checks.esNulo(prescriptor)) {
						visita.setPrescriptor(prescriptor);
					}
				} else {
					visita.setPrescriptor(null);
				}
			}

			if (((JSONObject) jsonFields).containsKey("idProveedorRemResponsable")) {
				if (!Checks.esNulo(visitaDto.getIdProveedorRemResponsable())) {
					ActivoProveedor apiResp = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
							genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemResponsable()));
					if (!Checks.esNulo(apiResp)) {
						visita.setApiResponsable(apiResp);
					}
				} else {
					visita.setApiResponsable(null);
				}
			}

			if (((JSONObject) jsonFields).containsKey("idProveedorRemCustodio")) {
				if (!Checks.esNulo(visitaDto.getIdProveedorRemCustodio())) {
					ActivoProveedor apiCust = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
							genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemCustodio()));
					if (!Checks.esNulo(apiCust)) {
						visita.setApiCustodio(apiCust);
					}
				} else {
					visita.setApiCustodio(null);
				}
			}

			if (((JSONObject) jsonFields).containsKey("idProveedorRemFdv")) {
				if (!Checks.esNulo(visitaDto.getIdProveedorRemFdv())) {
					ActivoProveedor fdv = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
							genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemFdv()));
					if (!Checks.esNulo(fdv)) {
						visita.setFdv(fdv);
					}
				} else {
					visita.setFdv(null);
				}
			}

			if (((JSONObject) jsonFields).containsKey("idProveedorRemVisita")) {
				if (!Checks.esNulo(visitaDto.getIdProveedorRemVisita())) {
					ActivoProveedor pveVisita = (ActivoProveedor) genericDao.get(ActivoProveedor.class,
							genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", visitaDto.getIdProveedorRemVisita()));
					if (!Checks.esNulo(pveVisita)) {
						visita.setProveedorVisita(pveVisita);
					}
				} else {
					visita.setProveedorVisita(null);
				}
			}

			if (((JSONObject) jsonFields).containsKey("observaciones")) {
				visita.setObservaciones(visitaDto.getObservaciones());
			}		

			if (((JSONObject) jsonFields).containsKey("fecha")) {
				if (!Checks.esNulo(visitaDto.getCodEstadoVisita()) && !Checks.esNulo(visitaDto.getFecha())) {
					if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_ALTA)) {
						visita.setFechaVisita(visitaDto.getFecha());
					} else if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_CONCERTADA)) {
						visita.setFechaConcertacion(visitaDto.getFecha());
					} else if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_CONTACTO)) {
						visita.setFechaContacto(visitaDto.getFecha());
					} else if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_REALIZADA)) {
						visita.setFechaVisita(visitaDto.getFecha());
					} else if (visitaDto.getCodEstadoVisita().equals(DDEstadosVisita.CODIGO_NO_REALIZADA)) {
						visita.setFechaVisita(visitaDto.getFecha());
					}
				}
			}

			visitaDao.saveOrUpdate(visita);
		}

		return errorsList;
	}

	@Override
	public List<String> validateVisitaDeleteRequestData(VisitaDto visitaDto) {
		List<String> listaErrores = new ArrayList<String>();
		Visita visita = null;

		try {

			if (Checks.esNulo(visitaDto.getIdVisitaWebcom())) {
				listaErrores.add("El campo IdVisitaWebcom es nulo y es obligatorio.");

			} else if (Checks.esNulo(visitaDto.getIdVisitaRem())) {
				listaErrores.add("El campo IdVisitaRem es nulo y es obligatorio.");

			} else {
				visita = getVisitaByIdVisitaWebcomNumVisitaRem(visitaDto.getIdVisitaWebcom(),
						visitaDto.getIdVisitaRem());
				if (Checks.esNulo(visita)) {
					listaErrores.add("No existe en REM la visita con idVisitaWebcom: " + visitaDto.getIdVisitaWebcom()
							+ " e idVisitaRem: " + visitaDto.getIdVisitaRem());
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			listaErrores.add("Ha ocurrido un error al validar los parámetros de la visita idVisitaWebcom: "
					+ visitaDto.getIdVisitaWebcom() + ". Traza: " + e.getMessage());
			return listaErrores;
		}

		return listaErrores;
	}

	@Override
	@Transactional(readOnly = false)
	public List<String> deleteVisita(VisitaDto visitaDto) {
		List<String> errorsList = null;
		Visita visita = null;

		try {

			// ValidateDelete
			errorsList = validateVisitaDeleteRequestData(visitaDto);
			if (errorsList.isEmpty()) {
				visita = getVisitaByIdVisitaWebcomNumVisitaRem(visitaDto.getIdVisitaWebcom(),
						visitaDto.getIdVisitaRem());
				if (!Checks.esNulo(visita)) {
					visitaDao.delete(visita);
				} else {
					errorsList.add("No existe en REM la visita con idVisitaWebcom: " + visitaDto.getIdVisitaWebcom()
							+ " e idVisitaRem: " + visitaDto.getIdVisitaRem());
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			errorsList.add("Ha ocurrido un error en base de datos al eliminar la visita idVisitaWebcom: "
					+ visitaDto.getIdVisitaWebcom() + " e idVisitaRem: " + visitaDto.getIdVisitaRem() + ". Traza: "
					+ e.getMessage());
			return errorsList;
		}

		return errorsList;
	}

	@Override
	public DtoPage getListVisitasDetalle(DtoVisitasFilter dtoVisitasFilter) {

		return visitaDao.getListVisitasDetalle(dtoVisitasFilter);

	}
	
	@Override
	public List<Visita> getListaVisitasOrdenada(DtoVisitasFilter dtoVisitasFilter) {
		 List<Visita> lvisita = null;
		
		 lvisita = visitaDao.getListaVisitasOrdenada(dtoVisitasFilter);

		 return lvisita;
	}

	@Override
	@Transactional(readOnly = false)
	public ArrayList<Map<String, Object>> saveOrUpdateVisitas(List<VisitaDto> listaVisitaDto, JSONObject jsonFields)
			throws Exception {
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		VisitaDto visitaDto = null;
		Map<String, Object> map = null;
		HashMap<String, String> errorsList = null;
		Visita visita = null;
		for (int i = 0; i < listaVisitaDto.size(); i++) {

			Visita vis = null;
			errorsList = new HashMap<String, String>();
			map = new HashMap<String, Object>();
			visitaDto = listaVisitaDto.get(i);

			visita = this.getVisitaByIdVisitaWebcom(visitaDto.getIdVisitaWebcom());
			if (Checks.esNulo(visita)) {
				errorsList = this.saveVisita(visitaDto);

			} else {
				errorsList = this.updateVisita(visita, visitaDto, jsonFields.getJSONArray("data").get(i));

			}

			if (!Checks.esNulo(errorsList) && errorsList.isEmpty()) {
				vis = this.getVisitaByIdVisitaWebcom(visitaDto.getIdVisitaWebcom());
				map.put("idVisitaWebcom", vis.getIdVisitaWebcom());
				map.put("idVisitaRem", vis.getNumVisitaRem());
				map.put("success", true);
			} else {
				map.put("idVisitaWebcom", visitaDto.getIdVisitaWebcom());
				map.put("idVisitaRem", visitaDto.getIdVisitaRem());
				map.put("success", false);
				map.put("invalidFields", errorsList);
			}
			listaRespuesta.add(map);

		}
		return listaRespuesta;
	}

	@Override
	public VBusquedaVisitasDetalle getVisitaDetalle(DtoVisitasFilter dtoVisitasFilter) {

		return visitaDao.getVisitaDetalle(dtoVisitasFilter);
	}
}