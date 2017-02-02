package es.pfsgroup.plugin.rem.activo;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.DtoSubdivisiones;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi;
import es.pfsgroup.plugin.rem.rest.api.GestorDocumentalFotosApi.PROPIEDAD;
import es.pfsgroup.plugin.rem.rest.dto.File;
import es.pfsgroup.plugin.rem.rest.dto.FileResponse;

@Service("activoAgrupacionManager")
public class ActivoAgrupacionManager implements ActivoAgrupacionApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

	protected static final Log logger = LogFactory.getLog(ActivoAgrupacionManager.class);

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoAgrupacionDao activoAgrupacionDao;

	@Autowired
	GestorDocumentalFotosApi gestorDocumentalFotos;

	@Autowired
	private ActivoAdapter activoAdapter;

	// @Override
	// public String managerName() {
	// return "activoAgrupacionManager";
	// }

	@Autowired
	private ActivoAgrupacionFactoryApi activoAgrupacionFactoryApi;

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.get")
	public ActivoAgrupacion get(Long id) {
		return activoAgrupacionDao.get(id);
	}

	public Long getAgrupacionIdByNumAgrupRem(Long numAgrupRem) {
		return activoAgrupacionDao.getAgrupacionIdByNumAgrupRem(numAgrupRem);
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.saveOrUpdate")
	@Transactional
	public boolean saveOrUpdate(ActivoAgrupacion activoAgrupacion) {
		activoAgrupacionDao.saveOrUpdate(activoAgrupacion);
		return true;
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.deleteById")
	@Transactional
	public boolean deleteById(Long id) {
		activoAgrupacionDao.deleteById(id);
		return true;
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.getListAgrupaciones")
	public Page getListAgrupaciones(DtoAgrupacionFilter dto, Usuario usuarioLogado) {
		return activoAgrupacionDao.getListAgrupaciones(dto, usuarioLogado);
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.getListActivosAgrupacionById")
	public Page getListActivosAgrupacionById(DtoAgrupacionFilter dto, Usuario usuarioLogado) {
		return activoAgrupacionDao.getListActivosAgrupacionById(dto, usuarioLogado);
	}

	@Override
	public Long getNextNumAgrupacionRemManual() {
		return activoAgrupacionDao.getNextNumAgrupacionRemManual();
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.haveActivoPrincipal")
	public Long haveActivoPrincipal(Long id) {
		return activoAgrupacionDao.haveActivoPrincipal(id);
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.haveActivoRestringidaAndObraNueva")
	public Long haveActivoRestringidaAndObraNueva(Long id) {
		return activoAgrupacionDao.haveActivoRestringidaAndObraNueva(id);
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.uploadFoto")
	@Transactional(readOnly = false)
	public String uploadFoto(WebFileItem fileItem) {

		Long idAgrupacion = Long.parseLong(fileItem.getParameter("idEntidad"));
		ActivoAgrupacion agrupacion = this.get(idAgrupacion);

		ActivoFoto activoFoto = null;
		FileResponse fileReponse;
		try {
			if (gestorDocumentalFotos.isActive()) {

				fileReponse = gestorDocumentalFotos.upload(fileItem.getFileItem().getFile(),
						fileItem.getFileItem().getFileName(), PROPIEDAD.AGRUPACION, agrupacion.getNumAgrupRem(), null,
						fileItem.getParameter("descripcion"), null, null, null);
				activoFoto = new ActivoFoto(fileReponse.getData());

			} else {
				activoFoto = new ActivoFoto(fileItem.getFileItem());
			}

			activoFoto.setAgrupacion(agrupacion);

			/*
			 * Filter filtro = genericDao.createFilter(FilterType.EQUALS,
			 * "codigo", fileItem.getParameter("tipo")); DDTipoFoto tipoFoto =
			 * (DDTipoFoto) genericDao.get(DDTipoFoto.class, filtro);
			 * 
			 * activoFoto.setTipoFoto(tipoFoto);
			 */

			activoFoto.setTamanyo(fileItem.getFileItem().getLength());

			activoFoto.setNombre(fileItem.getFileItem().getFileName());

			activoFoto.setDescripcion(fileItem.getParameter("descripcion"));

			activoFoto.setPrincipal(true);

			activoFoto.setFechaDocumento(new Date());

			// activoFoto.setInteriorExterior(Boolean.valueOf(fileItem.getParameter("interiorExterior")));

			/*
			 * Integer orden =
			 * activoDao.getMaxOrdenFotoById(Long.parseLong(fileItem.
			 * getParameter( "idEntidad"))); orden++;
			 * activoFoto.setOrden(orden);
			 */

			Auditoria.save(activoFoto);

			agrupacion.getFotos().add(activoFoto);

			activoAgrupacionDao.save(agrupacion);
		} catch (Exception e) {

		}

		return "success";

	}

	@Override
	public String uploadFoto(File fileItem) {
		Long agrupacionId = Long.parseLong(fileItem.getMetadata().get("id_agrupacion_haya"));
		ActivoAgrupacion agrupacion = this.get(agrupacionId);
		ActivoFoto activoFoto = activoAdapter.getFotoActivoByRemoteId(fileItem.getId());
		if (activoFoto == null) {
			activoFoto = new ActivoFoto(fileItem);
		}

		try {

			activoFoto.setAgrupacion(agrupacion);

			activoFoto.setNombre(fileItem.getBasename());

			if (fileItem.getMetadata().containsKey("descripcion")) {
				activoFoto.setDescripcion(fileItem.getMetadata().get("descripcion"));
			}

			activoFoto.setPrincipal(false);

			Date fechaSubida = new Date();
			if (fileItem.getMetadata().containsKey("fecha_subida")) {
				try {
					fechaSubida = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S")
							.parse(fileItem.getMetadata().get("fecha_subida"));
				} catch (Exception e) {
					logger.error("El webservice del Gestor documental ha enviado una fecha sin formato");
				}
			}

			activoFoto.setFechaDocumento(fechaSubida);

			Auditoria.save(activoFoto);

			agrupacion.getFotos().add(activoFoto);

			genericDao.save(ActivoAgrupacion.class, agrupacion);
		} catch (Exception e) {
			logger.error(e);
		}
		return "success";
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.uploadFotoSubdivision")
	@Transactional(readOnly = false)
	public String uploadFotoSubdivision(WebFileItem fileItem) {

		BigDecimal subdivisionId = new BigDecimal(fileItem.getParameter("id"));
		Long agrupacionId = Long.parseLong(fileItem.getParameter("agrId"));
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", agrupacionId);
		ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class, filtro);
		FileResponse fileReponse;
		ActivoFoto activoFoto;
		Integer orden = activoApi.getMaxOrdenFotoByIdSubdivision(agrupacionId, subdivisionId);
		orden++;
		try {
			if (gestorDocumentalFotos.isActive()) {

				fileReponse = gestorDocumentalFotos.uploadSubdivision(fileItem.getFileItem().getFile(),
						fileItem.getFileItem().getFileName(), subdivisionId, agrupacionId,
						fileItem.getParameter("descripcion"));
				activoFoto = new ActivoFoto(fileReponse.getData());

			} else {
				activoFoto = new ActivoFoto(fileItem.getFileItem());
			}

			activoFoto.setSubdivision(subdivisionId);

			activoFoto.setAgrupacion(agrupacion);

			activoFoto.setTamanyo(fileItem.getFileItem().getLength());

			activoFoto.setNombre(fileItem.getFileItem().getFileName());

			activoFoto.setDescripcion(fileItem.getParameter("descripcion"));

			activoFoto.setPrincipal(false);

			activoFoto.setFechaDocumento(new Date());

			activoFoto.setOrden(orden);

			Auditoria.save(activoFoto);

			agrupacion.getFotos().add(activoFoto);

			genericDao.save(ActivoAgrupacion.class, agrupacion);
		} catch (Exception e) {
			logger.error(e);
		}
		return "success";
	}

	public String uploadFotoSubdivision(File fileItem) {
		BigDecimal subdivisionId = new BigDecimal(fileItem.getMetadata().get("id_subdivision_haya"));
		Long agrupacionId = Long.parseLong(fileItem.getMetadata().get("id_agrupacion_haya"));
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", agrupacionId);
		ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class, filtro);
		ActivoFoto activoFoto;
		Integer orden = activoApi.getMaxOrdenFotoByIdSubdivision(agrupacionId, subdivisionId);
		orden++;
		try {
			activoFoto = activoAdapter.getFotoActivoByRemoteId(fileItem.getId());
			if (activoFoto == null) {
				activoFoto = new ActivoFoto(fileItem);
			}

			activoFoto.setSubdivision(subdivisionId);

			activoFoto.setAgrupacion(agrupacion);

			activoFoto.setNombre(fileItem.getBasename());

			if (fileItem.getMetadata().containsKey("descripcion")) {
				activoFoto.setDescripcion(fileItem.getMetadata().get("descripcion"));
			}

			activoFoto.setPrincipal(false);

			Date fechaSubida = new Date();
			if (fileItem.getMetadata().containsKey("fecha_subida")) {
				try {
					fechaSubida = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S")
							.parse(fileItem.getMetadata().get("fecha_subida"));
				} catch (Exception e) {
					logger.error("El webservice del Gestor documental ha enviado una fecha sin formato");
				}
			}

			activoFoto.setFechaDocumento(fechaSubida);

			activoFoto.setOrden(orden);

			Auditoria.save(activoFoto);

			agrupacion.getFotos().add(activoFoto);

			genericDao.save(ActivoAgrupacion.class, agrupacion);
		} catch (Exception e) {
			logger.error(e);
		}
		return "success";
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionManager.getFotosActivosAgrupacionById")
	public List<ActivoFoto> getFotosActivosAgrupacionById(Long id) {
		return activoAgrupacionDao.getFotosActivosAgrupacionById(id);
	}

	@Override
	public boolean createAgrupacion(DtoAgrupacionesCreateDelete dtoAgrupacion) {

		if (dtoAgrupacion.getTipoAgrupacion() == null) {
			return false;
		}

		return activoAgrupacionFactoryApi.create(dtoAgrupacion);

	}

	@Override
	public Page getListSubdivisionesAgrupacionById(DtoAgrupacionFilter agrupacionFilter) {
		return activoAgrupacionDao.getListSubdivisionesAgrupacionById(agrupacionFilter);
	}

	@Override
	public Page getListActivosSubdivisionById(DtoSubdivisiones subdivision) {
		return activoAgrupacionDao.getListActivosSubdivisionById(subdivision);
	}

	@Override
	public List<ActivoFoto> getFotosSubdivision(DtoSubdivisiones subdivision) {
		return activoAgrupacionDao.getFotosSubdivision(subdivision);
	}

	@Override
	public List<ActivoFoto> getFotosAgrupacionById(Long id) {

		return activoAgrupacionDao.getFotosAgrupacionById(id);

	}

}