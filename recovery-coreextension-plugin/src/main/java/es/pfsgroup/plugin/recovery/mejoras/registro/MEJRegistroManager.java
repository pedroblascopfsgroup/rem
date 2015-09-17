package es.pfsgroup.plugin.recovery.mejoras.registro;

import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.prorroga.model.CausaProrroga;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroInfo;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJTrazaDto;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJDDTipoRegistro;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJInfoRegistro;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJRegistro;

@Component
public class MEJRegistroManager implements MEJRegistroApi{
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Override
	@BusinessOperation(MEJ_BO_REG_BUSCA_TRAZA_EVENTO)
	public List<? extends MEJRegistroInfo> buscaTrazasEvento(MEJTrazaDto dto) {
		if (Checks.esNulo(dto.getTipoEvento())) {
			throw new IllegalArgumentException("tipoEvento IS NULL");
		}
		if (Checks.esNulo(dto.getTipoUnidadGestion())) {
			throw new IllegalArgumentException("tipoUnidadGestion IS NULL");
		}
		if (Checks.esNulo(dto.getIdUnidadGestion())) {
			throw new IllegalArgumentException("idUnidadGestion IS NULL");
		}

		Filter ftipoevento = genericDao.createFilter(FilterType.EQUALS,
				"tipo.codigo", dto.getTipoEvento());
		Filter ftipoug = genericDao.createFilter(FilterType.EQUALS,
				"tipoEntidadInformacion", dto.getTipoUnidadGestion());
		Filter fidug = genericDao.createFilter(FilterType.EQUALS,
				"idEntidadInformacion", dto.getIdUnidadGestion());

		return genericDao.getList(MEJRegistro.class, ftipoevento, ftipoug, fidug);
	}

	@Override
	@BusinessOperation(MEJ_BO_REG_GETTRAZA)
	public MEJRegistroInfo get(Long id) {
		return genericDao.get(MEJRegistro.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
	}

	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation(MEJ_BO_GETMAPA_REGISTRO)
	public Map<String, String> getMapaRegistro(Long id) {
		MEJRegistroInfo registro = get(id);
		if(!Checks.esNulo(registro)){
			List<MEJInfoRegistro> listaRegistro = (List<MEJInfoRegistro>) registro.getInfoRegistro();
			HashMap<String, String> map = new HashMap<String, String>();
			for (MEJInfoRegistro info : listaRegistro) {
				if (info.getClave()	.equals(MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_ID_TAREA_NOTIFICACION)) {
					Long idTarea = Long.parseLong(info.getValor());
					Filter filtroTarea = genericDao.createFilter(FilterType.EQUALS, "id", idTarea);
					TareaNotificacion tarea = null;
					if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(registro.getTipoEntidadInformacion())) {
						TareaExterna tex = genericDao.get(TareaExterna.class, filtroTarea);
						tarea = tex.getTareaPadre();
					} else {
						tarea = genericDao.get(TareaNotificacion.class, filtroTarea);
					}
					if (tarea != null) {
						map.put(info.getClave(), tarea.getDescripcionTarea());
						map.put("subtipoTarea", tarea.getSubtipoTarea().getCodigoSubtarea());
					}
				} else if (info.getClave().equals(	MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_MOTIVO)) {
					Filter filtroMotivo = genericDao.createFilter(FilterType.EQUALS, "codigo", info.getValor());
					CausaProrroga motivo = genericDao.get(CausaProrroga.class,filtroMotivo);
					map.put(info.getClave(), motivo.getDescripcion());
				}else if (info.getClave().equals(MEJDDTipoRegistro.TrazaRevisionRecurso.CLAVE_ID_RECURSO)) {
						Filter filtroRecurso = genericDao.createFilter(FilterType.EQUALS, "id",Long.parseLong(info.getValor()));
						MEJRecurso recurso = genericDao.get(MEJRecurso.class,filtroRecurso);
						map.put(info.getClave(), recurso.getTipoRecurso().getDescripcionLarga());
				}else if (info.getClave().equals(MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_FECHA_VENCIMIENTO_ORIGINAL)) {
					Long fechaLong = Long.parseLong(info.getValor());
					Date fechaOriginal = new Date(fechaLong);
					map.put(info.getClave(), DateFormat.toString(fechaOriginal));
				} else if (info	.getClave().equals(MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_FECHA_VENCIMIENTO_PROPUESTA)) {
					Long fechaLong = Long.parseLong(info.getValor());
					Date fechaOriginal = new Date(fechaLong);
					map.put(info.getClave(), DateFormat.toString(fechaOriginal));
				} else if (info.getClave().equals(MEJDDTipoRegistro.TrazaRevisionRecurso.CLAVE_FECHA_REVISION_RECURSO)) {
					Long fechaLong = Long.parseLong(info.getValor());
					Date fechaRevision = new Date(fechaLong);
					map.put(info.getClave(), DateFormat.toString(fechaRevision));
				}else if (info.getClave().equals(MEJDDTipoRegistro.TrazaRevisionRecurso.CLAVE_FECHA_VENCIMIENTO_INICIAL)) {
					Long fechaLong = Long.parseLong(info.getValor());
					Date fechaVencimientoIni = new Date(fechaLong);
					map.put(info.getClave(), DateFormat.toString(fechaVencimientoIni));
				}else if (info.getClave().equals(MEJDDTipoRegistro.TrazaRevisionRecurso.CLAVE_FECHA_VENCIMIENTO_FINAL)) {
					Long fechaLong = Long.parseLong(info.getValor());
					Date fechaVencimientoFin = new Date(fechaLong);
					map.put(info.getClave(), DateFormat.toString(fechaVencimientoFin));
				}else {
					map.put(info.getClave(), info.getValor());
					if(info.getRegistro() != null && info.getRegistro().getTipo() != null){
						map.put("tipoRegistro", info.getRegistro().getTipo().getCodigo());
					}else{
						map.put("tipoRegistro", "");
					}
				}
			}
			return map;
		}
		return null;
	}
	
	

	@Transactional(readOnly = false)
	@Override
	@BusinessOperation(MEJ_BO_REG_GUARDA_TRAZA_EVENTO_PARAM)
	public void guardatTrazaEventoParam(final long idUsuario, final long idUg, final String codUg, final String tipoEvento, final Map<String, Object> infoEvento){
		
		MEJTrazaDto dto = new MEJTrazaDto() {
			@Override
			public long getUsuario() {
				return idUsuario;
			}
			
			@Override
			public String getTipoUnidadGestion() {
				return codUg;
			}
			
			@Override
			public String getTipoEvento() {
				return tipoEvento;
			}
			
			@Override
			public Map<String, Object> getInformacionAdicional() {
				return infoEvento;
			}
			
			@Override
			public long getIdUnidadGestion() {
				return idUg;
			}
		};
		guardatTrazaEvento(dto);
	}

	
	@Transactional(readOnly = false)
	@Override
	@BusinessOperation(MEJ_BO_REG_GUARDA_TRAZA_EVENTO)
	public void guardatTrazaEvento(MEJTrazaDto dto) {
		MEJRegistro registro = creaNuevoRegistro(dto);

		MEJRegistro saved = genericDao.save(MEJRegistro.class, registro);

		saveInformacionAdicional(dto, saved);
		
	}
	
	/**
	 * Crea una nueva instancia de SANRegistro a partir de un DTO
	 * 
	 * @param dto
	 * @return
	 */
	private MEJRegistro creaNuevoRegistro(MEJTrazaDto dto) {
		assertArgument("tipoEvento IS REQUIRED", !Checks.esNulo(dto
				.getTipoEvento()));
		assertArgument("tipoUnidadGestion IS REQUIRED", !Checks.esNulo(dto
				.getTipoUnidadGestion()));
		assertArgument("idUnidadGestion IS REQUIRED", !Checks.esNulo(dto
				.getIdUnidadGestion()));
		assertArgument("tipoUnidadGestion IS REQUIRED", !Checks.esNulo(dto
				.getTipoUnidadGestion()));
		MEJRegistro r = new MEJRegistro();
		r.setTipo(genericDao
				.get(MEJDDTipoRegistro.class, genericDao.createFilter(
						FilterType.EQUALS, "codigo", dto.getTipoEvento())));
		r.setTipoEntidadInformacion(dto.getTipoUnidadGestion());
		r.setIdEntidadInformacion(dto.getIdUnidadGestion());
		r.setUsuario(getUsuario(dto.getUsuario()));
		return r;

	}
	
	/**
	 * Comprueba que un argumento sea correcto, lanzando una excepci�n
	 * IllegalArgumentException en caso contrario
	 * 
	 * @param msg
	 *            Mensaje que tendr� la excepci�n
	 * @param condition
	 *            Condici�n a evaluar para saber si el argumento es correcto
	 */
	private void assertArgument(String msg, boolean condition) {
		if (!condition) {
			throw new IllegalArgumentException(msg);
		}
	}
	
	private Usuario getUsuario(long id) {
		Usuario u = proxyFactory.proxy(UsuarioApi.class).get(id);
		if (u == null) {
			throw new IllegalArgumentException("usuario NO ACCESIBLE {id=" + id
					+ "}");
		}
		return u;
	}

	private void saveInformacionAdicional(MEJTrazaDto dto,
			MEJRegistro registro) {
		if (dto.getInformacionAdicional() != null) {
			Iterator<Entry<String, Object>> it = dto.getInformacionAdicional()
					.entrySet().iterator();
			while (it.hasNext()) {
				Entry<String, Object> e = it.next();
				MEJInfoRegistro info = new MEJInfoRegistro();
				info.setRegistro(registro);
				info.setClave(e.getKey());
				if (e.getValue() != null) {
					if (e.getValue() instanceof Date) {
						info.setValor("" + ((Date) e.getValue()).getTime());
					} else {
						info.setValor(e.getValue().toString());
					}
				} else {
					info.setValor("null");
				}
				genericDao.save(MEJInfoRegistro.class, info);
				registro.addInfo(info);
			}
		}
	}
	

}
