package es.pfsgroup.plugin.rem.factory.observaciones;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoObservacion;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoObservacionActivo;

public abstract class GridObservaciones extends GridObservacionesConstants {

	protected final Log logger = LogFactory.getLog(this.getClass());

	@Autowired
	protected ActivoApi activoApi;

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	protected GenericABMDao genericDao;

	@Autowired
	private ActivoDao activoDao;

	private BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	protected Activo getActivoById(Long id) {
		return activoApi.get(id);
	}

	protected List<DtoObservacion> getObservacionesListByIdAndCodes(Long id, String[] codes) {
		List<DtoObservacion> listaDtoObservaciones = new ArrayList<DtoObservacion>();
		if (id != null) {
			List<ActivoObservacion> observaciones = activoDao.getObservacionesActivo(id, codes);
			listaDtoObservaciones = getDtoListObservaciones(observaciones);
		}

		return listaDtoObservaciones;
	}

	public boolean createObservacionByDto(DtoObservacion dtoObservacion, Long idActivo) {
		ActivoObservacion activoObservacion = new ActivoObservacion();
		Activo activo = activoApi.get(idActivo);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();

		try {
			activoObservacion.setObservacion(dtoObservacion.getObservacion());
			activoObservacion.setFecha(new Date());
			activoObservacion.setUsuario(usuarioLogado);
			activoObservacion.setActivo(activo);

			if (dtoObservacion.getTipoObservacionCodigo() != null) {
				DDTipoObservacionActivo tipoObservacion = (DDTipoObservacionActivo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoObservacionActivo.class,
								dtoObservacion.getTipoObservacionCodigo());
				if (tipoObservacion != null) {
					activoObservacion.setTipoObservacion(tipoObservacion);
				}
			}

			genericDao.save(ActivoObservacion.class, activoObservacion);
		} catch (Exception e) {
			logger.error("Error en " + getClass().getName() + ", createObservacionesActivo", e);
			return false;
		}

		return true;
	}

	protected boolean deleteObservacionById(Long idObservacion) {
		try {
			genericDao.deleteById(ActivoObservacion.class, idObservacion);

		} catch (Exception e) {
			logger.error("Error en " + getClass().getName() + ", deleteObservacion", e);
		}

		return true;
	}

	protected String getTipoObservacion(Long id) {

		ActivoObservacion observacion = genericDao.get(ActivoObservacion.class,
				genericDao.createFilter(FilterType.EQUALS, "id", id));
		if (observacion != null && observacion.getTipoObservacion() != null) {
			return observacion.getTipoObservacion().getCodigo();
		}

		return null;

	}

	@Transactional(readOnly = false)
	public boolean saveObservacionByDto(DtoObservacion dtoObservacion) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(dtoObservacion.getId()));
		ActivoObservacion activoObservacion = genericDao.get(ActivoObservacion.class, filtro);
		try {
			beanUtilNotNull.copyProperties(activoObservacion, dtoObservacion);
			if (dtoObservacion.getTipoObservacionCodigo() != null) {
				DDTipoObservacionActivo tipoObservacion = (DDTipoObservacionActivo) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDTipoObservacionActivo.class,
								dtoObservacion.getTipoObservacionCodigo());
				if (tipoObservacion != null) {
					activoObservacion.setTipoObservacion(tipoObservacion);
				}
			}
			genericDao.save(ActivoObservacion.class, activoObservacion);

		} catch (IllegalAccessException e) {
			logger.error("Error en " + getClass().getName() + ", saveObservacionesActivo", e);
		} catch (InvocationTargetException e) {
			logger.error("Error en " + getClass().getName() + ", saveObservacionesActivo", e);
		}

		return true;
	}

	private List<DtoObservacion> getDtoListObservaciones(List<ActivoObservacion> observaciones) {
		List<DtoObservacion> listaDtoObservaciones = new ArrayList<DtoObservacion>();
		for (ActivoObservacion observacion : observaciones) {
			DtoObservacion observacionDto = new DtoObservacion();
			try {
				BeanUtils.copyProperties(observacionDto, observacion);
				if (observacion.getUsuario() != null) {
					StringBuilder nombreCompleto = new StringBuilder();
					nombreCompleto.append(observacion.getUsuario().getNombre());
					Long idUsuario = observacion.getUsuario().getId();
					if (observacion.getUsuario().getApellido1() != null 
							&& observacion.getUsuario().getApellido2() != null) {
						nombreCompleto.insert(0, observacion.getUsuario().getApellido1() + " " 
							+ observacion.getUsuario().getApellido2() + ", ");
					}else if(observacion.getUsuario().getApellido1() != null){
						nombreCompleto.append(" " + observacion.getUsuario().getApellido1());
					}
					if (observacion.getTipoObservacion() != null) {
						BeanUtils.copyProperty(observacionDto, "tipoObservacionCodigo",
								observacion.getTipoObservacion().getCodigo());
					}
					BeanUtils.copyProperty(observacionDto, "nombreCompleto", nombreCompleto);
					BeanUtils.copyProperty(observacionDto, "idUsuario", idUsuario);
				}
			} catch (IllegalAccessException e) {
				logger.error("Error en " + getClass().getName(), e);
			} catch (InvocationTargetException e) {
				logger.error("Error en " + getClass().getName(), e);
			}
			listaDtoObservaciones.add(observacionDto);
		}
		return listaDtoObservaciones;
	}

}
