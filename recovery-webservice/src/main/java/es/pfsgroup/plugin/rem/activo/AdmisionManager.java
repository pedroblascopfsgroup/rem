package es.pfsgroup.plugin.rem.activo;

import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.admision.exception.AdmisionException;
import es.pfsgroup.plugin.rem.api.AdmisionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgendaRevisionTitulo;
import es.pfsgroup.plugin.rem.model.ActivoCaixa;
import es.pfsgroup.plugin.rem.model.ActivoObservacion;
import es.pfsgroup.plugin.rem.model.DtoActivoAgendaRevisionTitulo;
import es.pfsgroup.plugin.rem.model.DtoAdmisionRevisionTitulo;
import es.pfsgroup.plugin.rem.model.dd.ActivoAdmisionRevisionTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDAnotacionConcurso;
import es.pfsgroup.plugin.rem.model.dd.DDAutorizacionTransmision;
import es.pfsgroup.plugin.rem.model.dd.DDBoletines;
import es.pfsgroup.plugin.rem.model.dd.DDCedulaHabitabilidad;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGestion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoRegistralActivo;
import es.pfsgroup.plugin.rem.model.dd.DDLicenciaPrimeraOcupacion;
import es.pfsgroup.plugin.rem.model.dd.DDProteccionOficial;
import es.pfsgroup.plugin.rem.model.dd.DDSeguroDecenal;
import es.pfsgroup.plugin.rem.model.dd.DDSiNoNoAplica;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionConstructivaRegistral;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionInicialCargas;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionInicialInscripcion;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionPosesoriaInicial;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipologiaAgenda;
import es.pfsgroup.plugin.rem.model.dd.DDTipoArrendamiento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoExpedienteAdministrativo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoIncidencia;
import es.pfsgroup.plugin.rem.model.dd.DDTipoIncidenciaRegistral;
import es.pfsgroup.plugin.rem.model.dd.DDTipoObservacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOcupacionLegal;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTitularidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;


@Service("admisionManager")
public class AdmisionManager extends BusinessOperationOverrider<AdmisionApi> implements AdmisionApi {
	
	protected static final Log logger = LogFactory.getLog(AdmisionManager.class);
	private static final String CODE = "codigo";
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Override
	public String managerName() {
		return "admisionManager";
	}	
	
	
	
	@Override
	public ActivoAgendaRevisionTitulo getActivoAgendaRevisionTituloById(Long id) {
		return genericGet(ActivoAgendaRevisionTitulo.class, "id", id);
	}
	
	@Override
	public List<DtoActivoAgendaRevisionTitulo> getListAgendaRevisionTitulo(Long idActivo) throws Exception {

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		List<ActivoAgendaRevisionTitulo> listaActivoAgendaRevisionTitulo = genericDao.getList(ActivoAgendaRevisionTitulo.class, filter);
		List<DtoActivoAgendaRevisionTitulo> listaActivoRevisionTituloDto = new ArrayList<DtoActivoAgendaRevisionTitulo>();
		
		if(listaActivoAgendaRevisionTitulo != null && !listaActivoAgendaRevisionTitulo.isEmpty()) {
			for (ActivoAgendaRevisionTitulo activoAgendaRevisionTitulo : listaActivoAgendaRevisionTitulo) {
				DtoActivoAgendaRevisionTitulo dto = new DtoActivoAgendaRevisionTitulo();
				
				dto.setIdActivoAgendaRevisionTitulo(activoAgendaRevisionTitulo.getId());
				dto.setObservaciones(activoAgendaRevisionTitulo.getObservaciones());
				dto.setFechaAlta(activoAgendaRevisionTitulo.getFechaAlta());

				if(activoAgendaRevisionTitulo.getSubtipologiaAgenda() != null) {
					dto.setSubtipologiaCodigo(activoAgendaRevisionTitulo.getSubtipologiaAgenda().getCodigo());
					dto.setSubtipologiaDescripcion(activoAgendaRevisionTitulo.getSubtipologiaAgenda().getDescripcion());
				}
				if(activoAgendaRevisionTitulo.getUsuario() != null) {
					filter = genericDao.createFilter(FilterType.EQUALS, "id", activoAgendaRevisionTitulo.getUsuario().getId());
					Usuario usuario = genericDao.get(Usuario.class, filter);
					if(usuario != null) {
						dto.setGestorAlta(usuario.getUsername());
					}
				}
				listaActivoRevisionTituloDto.add(dto);
			}
		}else {
			return null;
		}
		
		return listaActivoRevisionTituloDto;
	}

	@Override
	@Transactional(readOnly = false)
	public void createAgendaRevisionTitulo(Long idActivo, String subtipologiaCodigo, String observaciones) throws Exception {
		
		ActivoAgendaRevisionTitulo agendaRevisionTitulo = new ActivoAgendaRevisionTitulo();
		Activo activo = activoDao.getActivoById(idActivo);
		
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", subtipologiaCodigo);
		DDSubtipologiaAgenda subtipologiaAgenda = genericDao.get(DDSubtipologiaAgenda.class, filter);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		agendaRevisionTitulo.setSubtipologiaAgenda(subtipologiaAgenda);
		agendaRevisionTitulo.setObservaciones(observaciones);
		agendaRevisionTitulo.setUsuario(usuarioLogado);
		agendaRevisionTitulo.setFechaAlta(new Date());
		agendaRevisionTitulo.setActivo(activo);
		
		Auditoria auditoria = new Auditoria();
		auditoria.setUsuarioCrear(usuarioLogado.getUsername());
		auditoria.setFechaCrear(new Date());
		auditoria.setBorrado(false);
		
		agendaRevisionTitulo.setAuditoria(auditoria);

		genericDao.save(ActivoAgendaRevisionTitulo.class, agendaRevisionTitulo);
		
		ActivoObservacion activoObservacion = new ActivoObservacion();
		activoObservacion.setObservacion(observaciones);
		activoObservacion.setFecha(new Date());
		activoObservacion.setUsuario(usuarioLogado);
		activoObservacion.setActivo(activo);
		DDTipoObservacionActivo tipoObservacion = genericDao.get(DDTipoObservacionActivo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoObservacionActivo.CODIGO_REVISION_TITULO));
		activoObservacion.setTipoObservacion(tipoObservacion);
		activoObservacion.setAuditoria(auditoria);
		
		activoObservacion = genericDao.save(ActivoObservacion.class, activoObservacion);
		
		agendaRevisionTitulo.setActivoObservacion(activoObservacion);
		genericDao.update(ActivoAgendaRevisionTitulo.class, agendaRevisionTitulo);

	}
	
	@Override
	@Transactional(readOnly = false)
	public void deleteAgendaRevisionTitulo(Long idAgendaRevisionTitulo) throws Exception {
		
		ActivoAgendaRevisionTitulo agendaRevisionTitulo = getActivoAgendaRevisionTituloById(idAgendaRevisionTitulo);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		Auditoria auditoria = agendaRevisionTitulo.getAuditoria();
		
		auditoria.setUsuarioBorrar(usuarioLogado.getUsername());
		auditoria.setFechaBorrar(new Date());
		auditoria.setBorrado(true);
		
		agendaRevisionTitulo.setAuditoria(auditoria);

		genericDao.update(ActivoAgendaRevisionTitulo.class, agendaRevisionTitulo);		
		
		ActivoObservacion activoObservacion = agendaRevisionTitulo.getActivoObservacion();
		activoObservacion.setAuditoria(auditoria);
		
		genericDao.update(ActivoObservacion.class, activoObservacion);		
	}

	@Override
	@Transactional(readOnly = false)
	public void actualizarAgendaRevisionTitulo(DtoActivoAgendaRevisionTitulo dto) throws Exception {
		
		ActivoAgendaRevisionTitulo agendaRevisionTitulo = getActivoAgendaRevisionTituloById(dto.getIdActivoAgendaRevisionTitulo());
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		if( dto.getSubtipologiaCodigo() != null) {
			Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getSubtipologiaCodigo());
			DDSubtipologiaAgenda subtipologiaAgenda = genericDao.get(DDSubtipologiaAgenda.class, filter);
			agendaRevisionTitulo.setSubtipologiaAgenda(subtipologiaAgenda);

		}
		
		ActivoObservacion activoObservacion = agendaRevisionTitulo.getActivoObservacion();
		
		if(dto.getObservaciones() != null) {
			activoObservacion.setObservacion(dto.getObservaciones());
			agendaRevisionTitulo.setObservaciones(dto.getObservaciones());
		
			Auditoria auditoria = agendaRevisionTitulo.getAuditoria();
			
			auditoria.setUsuarioModificar(usuarioLogado.getUsername());
			auditoria.setFechaModificar(new Date());
			
			activoObservacion.setAuditoria(auditoria);
			agendaRevisionTitulo.setAuditoria(auditoria);
			
			genericDao.update(ActivoAgendaRevisionTitulo.class, agendaRevisionTitulo);
			genericDao.update(ActivoObservacion.class, activoObservacion);
		}
		
	}
	
	@Override
	public DtoAdmisionRevisionTitulo getTabDataRevisionTitulo(Long idActivo) throws AdmisionException, IllegalAccessException, InvocationTargetException {
		
		 
		DtoAdmisionRevisionTitulo dto = new DtoAdmisionRevisionTitulo();   
		if ( idActivo == null) { 
			throw new AdmisionException(AdmisionException.getActivoNoInformado());
		}
		Activo activo = activoDao.getActivoById(idActivo);
		if ( activo == null) {
			throw new AdmisionException(AdmisionException.getActivoNoExisteError(idActivo.toString()));
		}
		dto.setIdActivo(idActivo);
		ActivoAdmisionRevisionTitulo revisionTitulo = getAdmisionRevisionTitulo(dto);
		if ( revisionTitulo == null ) {
			return dto;
		} 
		
		
		beanUtilNotNull.copyProperty(dto, "revisado", getCode(revisionTitulo.getRevisado()));
		beanUtilNotNull.copyProperty(dto, "instLibArrendataria", getCode(revisionTitulo.getInstLibArrendataria()));
		beanUtilNotNull.copyProperty(dto, "ratificacion", getCode(revisionTitulo.getRatificacion()));
		beanUtilNotNull.copyProperty(dto, "situacionInicialInscripcion", getCode(revisionTitulo.getSituacionInicialInscripcion()));
		if(revisionTitulo.getSituacionInicialInscripcion() != null) {
			beanUtilNotNull.copyProperty(dto, "situacionInicialInscripcionDescripcion", revisionTitulo.getSituacionInicialInscripcion().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "posesoriaInicial", getCode(revisionTitulo.getPosesoriaInicial()));
		if(revisionTitulo.getPosesoriaInicial() != null) {
			beanUtilNotNull.copyProperty(dto, "posesoriaInicialDescripcion", revisionTitulo.getPosesoriaInicial().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "situacionInicialCargas", getCode(revisionTitulo.getSituacionInicialCargas()));
		if(revisionTitulo.getSituacionInicialCargas() != null) {
			beanUtilNotNull.copyProperty(dto, "situacionInicialCargasDescripcion", revisionTitulo.getSituacionInicialCargas().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "tipoTitularidad", getCode(revisionTitulo.getTipoTitularidad()));
		if(revisionTitulo.getTipoTitularidad() != null) {
			beanUtilNotNull.copyProperty(dto, "tipoTitularidadDescripcion", revisionTitulo.getTipoTitularidad().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "estadoAutorizaTransmision", getCode(revisionTitulo.getEstadoAutorizaTransmision()));
		if(revisionTitulo.getEstadoAutorizaTransmision() != null) {
			beanUtilNotNull.copyProperty(dto, "estadoAutorizaTransmisionDescripcion", revisionTitulo.getEstadoAutorizaTransmision().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "anotacionConcurso", getCode(revisionTitulo.getAnotacionConcurso()));
		if(revisionTitulo.getAnotacionConcurso() != null) {
			beanUtilNotNull.copyProperty(dto, "anotacionConcursoDescripcion", revisionTitulo.getAnotacionConcurso().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "estadoGestionCa", getCode(revisionTitulo.getEstadoGestionCa()));
		if(revisionTitulo.getEstadoGestionCa() != null) {
			beanUtilNotNull.copyProperty(dto, "estadoGestionCaDescripcion", revisionTitulo.getEstadoGestionCa().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "consFisica", getCode(revisionTitulo.getConsFisica()));
		beanUtilNotNull.copyProperty(dto, "consJuridica", getCode(revisionTitulo.getConsJuridica()));
		beanUtilNotNull.copyProperty(dto, "estadoCertificadoFinObra", getCode(revisionTitulo.getEstadoCertificadoFinObra()));
		if(revisionTitulo.getEstadoCertificadoFinObra() != null) {
			beanUtilNotNull.copyProperty(dto, "estadoCertificadoFinObraDescripcion", revisionTitulo.getEstadoCertificadoFinObra().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "estadoAfoActaFinObra", getCode(revisionTitulo.getEstadoAfoActaFinObra()));
		if(revisionTitulo.getEstadoAfoActaFinObra() != null) {
			beanUtilNotNull.copyProperty(dto, "estadoAfoActaFinObraDescripcion", revisionTitulo.getEstadoAfoActaFinObra().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "licenciaPrimeraOcupacion", getCode(revisionTitulo.getLicenciaPrimeraOcupacion()));
		if(revisionTitulo.getLicenciaPrimeraOcupacion() != null) {
			beanUtilNotNull.copyProperty(dto, "licenciaPrimeraOcupacionDescripcion", revisionTitulo.getLicenciaPrimeraOcupacion().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "boletines", getCode(revisionTitulo.getBoletines()));
		if(revisionTitulo.getBoletines() != null) {
			beanUtilNotNull.copyProperty(dto, "boletinesDescripcion", revisionTitulo.getBoletines().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "seguroDecenal", getCode(revisionTitulo.getSeguroDecenal()));
		if(revisionTitulo.getSeguroDecenal() != null) {
			beanUtilNotNull.copyProperty(dto, "seguroDecenalDescripcion", revisionTitulo.getSeguroDecenal().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "cedulaHabitabilidad", getCode(revisionTitulo.getCedulaHabitabilidad()));
		if(revisionTitulo.getCedulaHabitabilidad() != null) {
			beanUtilNotNull.copyProperty(dto, "cedulaHabitabilidadDescripcion", revisionTitulo.getCedulaHabitabilidad().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "tipoArrendamiento", getCode(revisionTitulo.getTipoArrendamiento()));
		if(revisionTitulo.getTipoArrendamiento() != null) {
			beanUtilNotNull.copyProperty(dto, "tipoArrendamientoDescripcion", revisionTitulo.getTipoArrendamiento().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "notificarArrendatarios", getCode(revisionTitulo.getNotificarArrendatarios()));
		beanUtilNotNull.copyProperty(dto, "tipoExpediente", getCode(revisionTitulo.getTipoExpediente()));
		if(revisionTitulo.getTipoExpediente() != null) {
			beanUtilNotNull.copyProperty(dto, "tipoExpedienteDescripcion", revisionTitulo.getTipoExpediente().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "estadoGestionEa", getCode(revisionTitulo.getEstadoGestionEa()));
		beanUtilNotNull.copyProperty(dto, "tipoIncidenciaRegistral", getCode(revisionTitulo.getTipoIncidenciaRegistral()));
		if(revisionTitulo.getTipoIncidenciaRegistral() != null) {
			beanUtilNotNull.copyProperty(dto, "tipoIncidenciaRegistralDescripcion", revisionTitulo.getTipoIncidenciaRegistral().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "estadoGestionCr", getCode(revisionTitulo.getEstadoGestionCr()));
		if(revisionTitulo.getEstadoGestionCr() != null) {
			beanUtilNotNull.copyProperty(dto, "estadoGestionCrDescripcion", revisionTitulo.getEstadoGestionCr().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "tipoOcupacionLegal", getCode(revisionTitulo.getTipoOcupacionLegal()));
		if(revisionTitulo.getTipoOcupacionLegal() != null) {
			beanUtilNotNull.copyProperty(dto, "tipoOcupacionLegalDescripcion", revisionTitulo.getTipoOcupacionLegal().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "estadoGestionIl", getCode(revisionTitulo.getEstadoGestionIl()));
		if(revisionTitulo.getEstadoGestionIl() != null) {
			beanUtilNotNull.copyProperty(dto, "estadoGestionIlDescripcion", revisionTitulo.getEstadoGestionIl().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "estadoGestionOt", getCode(revisionTitulo.getEstadoGestionOt()));
		if(revisionTitulo.getEstadoGestionOt() != null) {
			beanUtilNotNull.copyProperty(dto, "estadoGestionOtDescripcion", revisionTitulo.getEstadoGestionOt().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "fechaRevisionTitulo", revisionTitulo.getFechaRevisionTitulo());
		beanUtilNotNull.copyProperty(dto, "fechaContratoAlquiler", revisionTitulo.getFechaContratoAlquiler());
		beanUtilNotNull.copyProperty(dto, "porcentajePropiedad", revisionTitulo.getPorcentajePropiedad());
		beanUtilNotNull.copyProperty(dto, "observaciones", revisionTitulo.getObservaciones());
		beanUtilNotNull.copyProperty(dto, "porcentajeConsTasacionCf", revisionTitulo.getPorcentajeConsTasacionCf());
		beanUtilNotNull.copyProperty(dto, "porcentajeConsTasacionCj", revisionTitulo.getPorcentajeConsTasacionCj());
		beanUtilNotNull.copyProperty(dto, "legislacionAplicableAlquiler", revisionTitulo.getLegislacionAplicableAlquiler());
		beanUtilNotNull.copyProperty(dto, "duracionContratoAlquiler", revisionTitulo.getDuracionContratoAlquiler());
		beanUtilNotNull.copyProperty(dto, "tipoIncidenciaIloc", revisionTitulo.getTipoIncidenciaIloc());
		beanUtilNotNull.copyProperty(dto, "deterioroGrave", revisionTitulo.getDeterioroGrave());
		beanUtilNotNull.copyProperty(dto, "tipoIncidenciaOtros", revisionTitulo.getTipoIncidenciaOtros());
		beanUtilNotNull.copyProperty(dto, "tipoTituloCodigo", getCode(activo.getTipoTitulo()));
		if(activo.getTipoTitulo() != null) {
			beanUtilNotNull.copyProperty(dto, "tipoTituloDescripcion", activo.getTipoTitulo().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "subtipoTituloCodigo", getCode(activo.getSubtipoTitulo()));
		if(activo.getTipoTitulo() != null) {
			beanUtilNotNull.copyProperty(dto, "tipoTituloDescripcion", activo.getTipoTitulo().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "situacionConstructivaRegistral", getCode(revisionTitulo.getSituacionConstructivaRegistral()));
		if(revisionTitulo.getSituacionConstructivaRegistral() != null) {
			beanUtilNotNull.copyProperty(dto, "situacionConstructivaRegistralDescripcion", revisionTitulo.getSituacionConstructivaRegistral().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "proteccionOficial", getCode(revisionTitulo.getProteccionOficial()));
		if(revisionTitulo.getProteccionOficial() != null) {
			beanUtilNotNull.copyProperty(dto, "proteccionOficialDescripcion", revisionTitulo.getProteccionOficial().getDescripcion());
		}
		beanUtilNotNull.copyProperty(dto, "tipoIncidencia", getCode(revisionTitulo.getTipoIncidencia()));
		beanUtilNotNull.copyProperty(dto, "tipoTituloActivo", getCode(revisionTitulo.getTipoTituloActivo()));
		beanUtilNotNull.copyProperty(dto, "subtipoTituloActivo", getCode(revisionTitulo.getSubtipoTituloActivo()));
		if(revisionTitulo.getTipoTitActRef() != null) {
			beanUtilNotNull.copyProperty(dto, "tipoTituloActivoRef", revisionTitulo.getTipoTitActRef().getDescripcion());
		}
		if(revisionTitulo.getSubtipoTitActRef() != null) {
			beanUtilNotNull.copyProperty(dto, "subtipoTituloActivoRef", revisionTitulo.getSubtipoTitActRef().getDescripcion());	
		}		
		
		return dto;
	}
	
	@Override
	@Transactional(readOnly=false)
	public void saveTabDataRevisionTitulo(DtoAdmisionRevisionTitulo dto) 
			throws AdmisionException, IllegalAccessException, InvocationTargetException {
		if ( dto.getIdActivo() == null && dto.getId() == null) {
			throw new AdmisionException(AdmisionException.getActivoNoInformado());
		}
		ActivoAdmisionRevisionTitulo revisionTitulo = getAdmisionRevisionTitulo(dto);
		if ( revisionTitulo == null ) {
			throw new AdmisionException(AdmisionException.getActivoNoExisteError(dto.getIdActivo().toString()));
		}
		Activo activo = activoDao.getActivoById(dto.getId());
		if ( activo == null) {
			throw new AdmisionException(AdmisionException.getActivoNoExisteError(dto.getId().toString()));
		}
		beanUtilNotNull.copyProperty(revisionTitulo, "revisado", genericGet(DDSinSiNo.class, CODE, dto.getRevisado()));
		beanUtilNotNull.copyProperty(revisionTitulo, "instLibArrendataria", genericGet(DDSiNoNoAplica.class, CODE, dto.getInstLibArrendataria()));
		beanUtilNotNull.copyProperty(activo, 		 "tipoTitulo", genericGet(DDTipoTituloActivo.class, CODE, dto.getTipoTituloCodigo()));
		beanUtilNotNull.copyProperty(activo, 		 "subtipoTitulo", genericGet(DDTipoTituloActivo.class, CODE, dto.getSubtipoTituloCodigo()));
		beanUtilNotNull.copyProperty(revisionTitulo, "ratificacion", genericGet(DDSiNoNoAplica.class, CODE, dto.getRatificacion()));
		beanUtilNotNull.copyProperty(revisionTitulo, "situacionInicialInscripcion", genericGet(DDSituacionInicialInscripcion.class, CODE, dto.getSituacionInicialInscripcion()));
		beanUtilNotNull.copyProperty(revisionTitulo, "posesoriaInicial", genericGet(DDSituacionPosesoriaInicial.class, CODE, dto.getPosesoriaInicial()));
		beanUtilNotNull.copyProperty(revisionTitulo, "situacionInicialCargas", genericGet(DDSituacionInicialCargas.class, CODE, dto.getSituacionInicialCargas()));
		beanUtilNotNull.copyProperty(revisionTitulo, "tipoTitularidad", genericGet(DDTipoTitularidad.class, CODE, dto.getTipoTitularidad()));
		beanUtilNotNull.copyProperty(revisionTitulo, "estadoAutorizaTransmision", genericGet(DDAutorizacionTransmision.class, CODE, dto.getEstadoAutorizaTransmision()));
		beanUtilNotNull.copyProperty(revisionTitulo, "anotacionConcurso", genericGet(DDAnotacionConcurso.class, CODE, dto.getAnotacionConcurso()));
		beanUtilNotNull.copyProperty(revisionTitulo, "estadoGestionCa", genericGet(DDEstadoGestion.class, CODE, dto.getEstadoGestionCa()));
		beanUtilNotNull.copyProperty(revisionTitulo, "consFisica", genericGet(DDSinSiNo.class, CODE, dto.getConsFisica()));
		beanUtilNotNull.copyProperty(revisionTitulo, "consJuridica", genericGet(DDSinSiNo.class, CODE, dto.getConsJuridica()));
		beanUtilNotNull.copyProperty(revisionTitulo, "estadoCertificadoFinObra", genericGet(DDEstadoGestion.class, CODE, dto.getEstadoCertificadoFinObra()));
		beanUtilNotNull.copyProperty(revisionTitulo, "estadoAfoActaFinObra", genericGet(DDEstadoGestion.class, CODE, dto.getEstadoAfoActaFinObra()));
		beanUtilNotNull.copyProperty(revisionTitulo, "licenciaPrimeraOcupacion", genericGet(DDLicenciaPrimeraOcupacion.class, CODE, dto.getLicenciaPrimeraOcupacion()));
		beanUtilNotNull.copyProperty(revisionTitulo, "boletines", genericGet(DDBoletines.class, CODE, dto.getBoletines()));
		beanUtilNotNull.copyProperty(revisionTitulo, "seguroDecenal", genericGet(DDSeguroDecenal.class, CODE, dto.getSeguroDecenal()));
		beanUtilNotNull.copyProperty(revisionTitulo, "cedulaHabitabilidad", genericGet(DDCedulaHabitabilidad.class, CODE, dto.getCedulaHabitabilidad()));
		beanUtilNotNull.copyProperty(revisionTitulo, "tipoArrendamiento", genericGet(DDTipoArrendamiento.class, CODE, dto.getTipoArrendamiento()));
		beanUtilNotNull.copyProperty(revisionTitulo, "notificarArrendatarios", genericGet(DDSinSiNo.class, CODE, dto.getNotificarArrendatarios()));
		beanUtilNotNull.copyProperty(revisionTitulo, "tipoExpediente", genericGet(DDTipoExpedienteAdministrativo.class, CODE, dto.getTipoExpediente()));
		beanUtilNotNull.copyProperty(revisionTitulo, "estadoGestionEa", genericGet(DDEstadoGestion.class, CODE, dto.getEstadoGestionEa()));
		beanUtilNotNull.copyProperty(revisionTitulo, "tipoIncidenciaRegistral", genericGet(DDTipoIncidenciaRegistral.class, CODE, dto.getTipoIncidenciaRegistral()));
		beanUtilNotNull.copyProperty(revisionTitulo, "estadoGestionCr", genericGet(DDEstadoGestion.class, CODE, dto.getEstadoGestionCr()));
		beanUtilNotNull.copyProperty(revisionTitulo, "tipoOcupacionLegal", genericGet(DDTipoOcupacionLegal.class, CODE, dto.getTipoOcupacionLegal()));
		beanUtilNotNull.copyProperty(revisionTitulo, "estadoGestionIl", genericGet(DDEstadoGestion.class, CODE, dto.getEstadoGestionIl()));
		beanUtilNotNull.copyProperty(revisionTitulo, "estadoGestionOt", genericGet(DDEstadoGestion.class, CODE, dto.getEstadoGestionOt()));
		beanUtilNotNull.copyProperty(revisionTitulo, "fechaRevisionTitulo", dto.getFechaRevisionTitulo());
		beanUtilNotNull.copyProperty(revisionTitulo, "fechaContratoAlquiler", dto.getFechaContratoAlquiler());
		beanUtilNotNull.copyProperty(revisionTitulo, "porcentajePropiedad", dto.getPorcentajePropiedad());
		beanUtilNotNull.copyProperty(revisionTitulo, "observaciones", dto.getObservaciones());
		beanUtilNotNull.copyProperty(revisionTitulo, "porcentajeConsTasacionCf", dto.getPorcentajeConsTasacionCf());
		beanUtilNotNull.copyProperty(revisionTitulo, "porcentajeConsTasacionCj", dto.getPorcentajeConsTasacionCj());
		beanUtilNotNull.copyProperty(revisionTitulo, "legislacionAplicableAlquiler", dto.getLegislacionAplicableAlquiler());
		beanUtilNotNull.copyProperty(revisionTitulo, "duracionContratoAlquiler", dto.getDuracionContratoAlquiler());
		beanUtilNotNull.copyProperty(revisionTitulo, "tipoIncidenciaIloc", dto.getTipoIncidenciaIloc());
		beanUtilNotNull.copyProperty(revisionTitulo, "deterioroGrave", dto.getDeterioroGrave());
		beanUtilNotNull.copyProperty(revisionTitulo, "tipoIncidenciaOtros", dto.getTipoIncidenciaOtros());
		beanUtilNotNull.copyProperty(revisionTitulo, "situacionConstructivaRegistral", genericGet(DDSituacionConstructivaRegistral.class, CODE, dto.getSituacionConstructivaRegistral()));
		beanUtilNotNull.copyProperty(revisionTitulo, "proteccionOficial", genericGet(DDProteccionOficial.class, CODE, dto.getProteccionOficial()));
		beanUtilNotNull.copyProperty(revisionTitulo, "tipoIncidencia",genericGet(DDTipoIncidencia.class, CODE, dto.getTipoIncidencia()));
		
		if ( dto.isUpdate() ) {
			genericDao.update(ActivoAdmisionRevisionTitulo.class, revisionTitulo);
		}else {
			genericDao.save(ActivoAdmisionRevisionTitulo.class, revisionTitulo);
		}
		
		DDEstadoRegistralActivo ddEstadoReg = null;
	
		if(revisionTitulo.getTipoIncidenciaRegistral() != null) {
			ddEstadoReg = genericDao.get(DDEstadoRegistralActivo.class, genericDao.createFilter(FilterType.EQUALS ,"descripcion", revisionTitulo.getTipoIncidenciaRegistral().getDescripcion()));
		}else if(revisionTitulo.getSituacionConstructivaRegistral() != null) {
			ddEstadoReg = genericDao.get(DDEstadoRegistralActivo.class, genericDao.createFilter(FilterType.EQUALS ,"descripcion", revisionTitulo.getSituacionConstructivaRegistral().getDescripcion()));
		}
		
		if(ddEstadoReg != null) {
			activo.setEstadoRegistral(ddEstadoReg);	
		}
		
		activoDao.save(activo);
		
	}
	
	
	
	private ActivoAdmisionRevisionTitulo getAdmisionRevisionTitulo(DtoAdmisionRevisionTitulo dto) {

		Long id = dto.getIdActivo() != null ? dto.getIdActivo() : dto.getId();
		if ( id == null) return null;
		ActivoAdmisionRevisionTitulo revisionTitulo = genericGet(ActivoAdmisionRevisionTitulo.class, "activo.id", id);
		if (revisionTitulo == null) {
			Activo activo = genericGet(Activo.class, "id", id);
			if (activo == null) {
				revisionTitulo = null;
			} else {
				revisionTitulo = new ActivoAdmisionRevisionTitulo();
				revisionTitulo.setActivo(activo);
			}
		} else {
			dto.setUpdate(true);
		}
		return revisionTitulo;
	}


	private <T extends Serializable> T genericGet(Class<T> clazz, String property, Object value) {
		if ( value == null ) return null;
		return genericDao.get(clazz, 
				genericDao.createFilter(FilterType.EQUALS, property , value));
	}
	
	private String getCode(Dictionary dict) {
		if (dict != null )
			return dict.getCodigo();
		return null;
	}
}
