package es.pfsgroup.plugin.rem.activo;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.adapter.PromocionAdapter;
import es.pfsgroup.plugin.rem.api.ActivoPromocionApi;
import es.pfsgroup.plugin.rem.api.AdmisionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgendaRevisionTitulo;
import es.pfsgroup.plugin.rem.model.ActivoOcupacionIlegal;
import es.pfsgroup.plugin.rem.model.AdjuntosPromocion;
import es.pfsgroup.plugin.rem.model.AdjuntosProyecto;
import es.pfsgroup.plugin.rem.model.DtoActivoAgendaRevisionTitulo;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoPromocion;
import es.pfsgroup.plugin.rem.model.DtoOcupacionIlegal;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipologiaAgenda;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoPromocion;


@Service("admisionManager")
public class AdmisionManager extends BusinessOperationOverrider<AdmisionApi> implements AdmisionApi {
	
	protected static final Log logger = LogFactory.getLog(AdmisionManager.class);

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoDao activoDao;

	@Override
	public String managerName() {
		return "admisionManager";
	}	
	
	
	@Override
	@SuppressWarnings("unchecked")
	public ActivoAgendaRevisionTitulo getActivoAgendaRevisionTituloById(Long id) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", id);
		ActivoAgendaRevisionTitulo agendaRevisionTitulo = genericDao.get(ActivoAgendaRevisionTitulo.class, filter);
		
		return agendaRevisionTitulo;
	}
	@Override
	@SuppressWarnings("unchecked")
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
		
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", subtipologiaCodigo);
		DDSubtipologiaAgenda subtipologiaAgenda = genericDao.get(DDSubtipologiaAgenda.class, filter);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		agendaRevisionTitulo.setSubtipologiaAgenda(subtipologiaAgenda);
		agendaRevisionTitulo.setObservaciones(observaciones);
		agendaRevisionTitulo.setUsuario(usuarioLogado);
		agendaRevisionTitulo.setFechaAlta(new Date());
		agendaRevisionTitulo.setActivo(activoDao.getActivoById(idActivo));
		
		Auditoria auditoria = new Auditoria();
		auditoria.setUsuarioCrear(usuarioLogado.getUsername());
		auditoria.setFechaCrear(new Date());
		auditoria.setBorrado(false);
		
		agendaRevisionTitulo.setAuditoria(auditoria);
		
		genericDao.save(ActivoAgendaRevisionTitulo.class, agendaRevisionTitulo);
		
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
		if(dto.getObservaciones() != null) {
			agendaRevisionTitulo.setObservaciones(dto.getObservaciones());
		}
		Auditoria auditoria = agendaRevisionTitulo.getAuditoria();
		
		auditoria.setUsuarioModificar(usuarioLogado.getUsername());
		auditoria.setFechaModificar(new Date());
		
		agendaRevisionTitulo.setAuditoria(auditoria);
		
		genericDao.update(ActivoAgendaRevisionTitulo.class, agendaRevisionTitulo);
		
	}
	
}
