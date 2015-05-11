package es.pfsgroup.recovery.ext.impl.multigestor;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import sun.text.UCompactIntArray;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.dao.EXTGestorEntidadDao;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorEntidad;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.api.AsuntoApi;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.ext.api.multigestor.EXTGestorInfo;
import es.pfsgroup.recovery.ext.api.multigestor.EXTMultigestorApi;

@Component
public class EXTMultigestorManager implements EXTMultigestorApi {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private EXTGestorEntidadDao gestorEntidadDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Override
	@BusinessOperation(EXTMultigestorApi.EXT_BO_MULTIGESTOR_DAME_GESTORES)
	public List<EXTGestorInfo> dameGestores(String ugCodigo, Long ugId) {

		List<EXTGestorInfo> listMultiEntidad =  getMultigestoresMultiEntidad(ugCodigo, ugId);
		
//		proxyFactory.proxy(extges)
		
		return listMultiEntidad;
	}

	private List<EXTGestorInfo> getMultigestoresMultiEntidad(String ugCodigo,
			Long ugId) {
		Filter fAuditoria = genericDao.createFilter(FilterType.EQUALS,
				"auditoria.borrado", false);

		List<EXTGestorInfo> listaGestores = new ArrayList<EXTGestorInfo>();

		if ((!Checks.esNulo(ugCodigo)) && (!Checks.esNulo(ugId))) {

			Filter fTipoUnidadGestion = genericDao.createFilter(
					FilterType.EQUALS, "tipoEntidad.codigo", ugCodigo);
			Filter fIdUnidadGestion = genericDao.createFilter(
					FilterType.EQUALS, "unidadGestionId", ugId);

			List<EXTGestorEntidad> lista = genericDao.getList(
					EXTGestorEntidad.class, fTipoUnidadGestion,
					fIdUnidadGestion, fAuditoria);

			for (EXTGestorEntidad ge : lista) {
				EXTGestorInfoImpl gi = new EXTGestorInfoImpl();
				gi.setTipoGestor(ge.getTipoGestor());
				gi.setUsuario(ge.getGestor());
				gi.setId(ge.getId());

				listaGestores.add(gi);
			}

			if (ugCodigo.equals(EXTMultigestorApi.COD_UG_ASUNTO)
					|| ugCodigo.equals(EXTMultigestorApi.COD_UG_PROCEDIMIENTO)) {
				appendGestoresTradicionalesDelAsuto(ugCodigo, ugId,
						listaGestores);
			}
		}

		return listaGestores;
	}

	@Override
	@BusinessOperation(EXTMultigestorApi.EXT_BO_MULTIGESTOR_ADD_GESTORES)
	@Transactional
	public void addGestores(String ugCodigo, Long ugId, String codTipoGestor,
			List<Long> idUsuarios) {

		EXTGestorEntidad ge = new EXTGestorEntidad();

		DDTipoEntidad tipoEntidad = genericDao.get(DDTipoEntidad.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", ugCodigo),
				genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado",
						false));
		ge.setTipoEntidad(tipoEntidad);
		ge.setUnidadGestionId(ugId);

		EXTDDTipoGestor tGestor = genericDao.get(EXTDDTipoGestor.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo",
						codTipoGestor), genericDao.createFilter(
						FilterType.EQUALS, "auditoria.borrado", false));
		ge.setTipoGestor(tGestor);

		for (Long usuarioId : idUsuarios) {

			Usuario usuario = genericDao
					.get(Usuario.class, genericDao.createFilter(
							FilterType.EQUALS, "id", usuarioId), genericDao
							.createFilter(FilterType.EQUALS,
									"auditoria.borrado", false));
			ge.setGestor(usuario);
			gestorEntidadDao.save(ge);
		}
	}

	@Override
	@BusinessOperation(EXTMultigestorApi.EXT_BO_MULTIGESTOR_ADD_GESTOR)
	@Transactional
	public void addGestor(String ugCodigo, Long ugId, String codTipoGestor,
			Long idUsuarios) {

		ArrayList<Long> idsUsuarios = new ArrayList<Long>();
		idsUsuarios.add(idUsuarios);
		addGestores(ugCodigo, ugId, codTipoGestor, idsUsuarios);

	}

	@Override
	@BusinessOperation(EXT_BO_MULTIGESTOR_REMOVE_GESTOR)
	@Transactional
	public void removeGestor(Long idAsunto, Long idGestor) {

		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "unidadGestionId", idAsunto);
		Long id = genericDao.get(EXTGestorEntidad.class, genericDao.createFilter(FilterType.EQUALS, "gestor.id", idGestor), f2).getId();
		gestorEntidadDao.deleteById(id);

	}

	private void appendGestoresTradicionalesDelAsuto(String ugCodigo,
			Long ugId, List<EXTGestorInfo> listaGestores) {

		if ((!Checks.esNulo(ugCodigo)) && (!Checks.esNulo(ugId))
				&& (!Checks.esNulo(listaGestores))) {
			Asunto asu = null;
			if (ugCodigo.equals(EXTMultigestorApi.COD_UG_ASUNTO)) {
				asu = proxyFactory.proxy(AsuntoApi.class).get(ugId);
			} else if (ugCodigo.equals(EXTMultigestorApi.COD_UG_PROCEDIMIENTO)) {
				Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class)
						.getProcedimiento(ugId);
				if (prc != null) {
					asu = prc.getAsunto();
				}
			}
			if (asu != null) {
				EXTGestorInfo gestor = getGestorAsunto(asu);
				EXTGestorInfo supervisor = getSupervisorAsunto(asu);
				if (gestor !=null) listaGestores.add(gestor);
				if (supervisor != null) listaGestores.add(supervisor);
			}
		}
	}

	private EXTGestorInfo getSupervisorAsunto(final Asunto asu) {
		if ((asu != null ) && (asu.getSupervisor() != null)){
			final EXTDDTipoGestor tipo = genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "codigo", EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR));
			
			if (tipo == null){
				throw new IllegalStateException("Tipo de gestor " + EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR + " no encontrado");
			}
			
			return new EXTGestorInfo() {
				
				@Override
				public Usuario getUsuario() {
					return asu.getSupervisor().getUsuario();
				}
				
				@Override
				public EXTDDTipoGestor getTipoGestor() {
					return tipo;
				}
				
				@Override
				public Long getId() {
					// TODO Auto-generated method stub
					return null;
				}
				@Override
				public String getIdCompuesto() {
					// TODO Auto-generated method stub
					return asu.getSupervisor().getUsuario().getId()+"_"+tipo.getId();
				}
			};
		}
		return null;
	}

	private EXTGestorInfo getGestorAsunto(final Asunto asu) {
		if ((asu != null ) && (asu.getGestor() != null)){
			final EXTDDTipoGestor tipo = genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "codigo", EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO));
			
			if (tipo == null){
				throw new IllegalStateException("Tipo de gestor " + EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO + " no encontrado");
			}
			
			return new EXTGestorInfo() {
				
				@Override
				public Usuario getUsuario() {
					return asu.getGestor().getUsuario();
				}
				
				@Override
				public EXTDDTipoGestor getTipoGestor() {
					return tipo;
				}
				
				@Override
				public Long getId() {
					// TODO Auto-generated method stub
					return null;
				}
				
				@Override
				public String getIdCompuesto() {
					// TODO Auto-generated method stub
					return asu.getGestor().getUsuario().getId()+"_"+tipo.getId();
				}
			};
		}
		return null;
	}
	
	
	private boolean existeGestoresTradicionalesDelAsuto(String ugCodigo,
			Long ugId, Long idUsuario, Long idTipoGestor) {

		boolean res = false;
		if ((!Checks.esNulo(ugCodigo)) && (!Checks.esNulo(ugId)) && (!Checks.esNulo(idUsuario)) && (!Checks.esNulo(idTipoGestor))) {
			Asunto asu = null;
			if (ugCodigo.equals(EXTMultigestorApi.COD_UG_ASUNTO)) {
				asu = proxyFactory.proxy(AsuntoApi.class).get(ugId);
			} else if (ugCodigo.equals(EXTMultigestorApi.COD_UG_PROCEDIMIENTO)) {
				Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class)
						.getProcedimiento(ugId);
				if (prc != null) {
					asu = prc.getAsunto();
				}
			}
			if (asu != null) {
				EXTDDTipoGestor tipo = genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "id", idTipoGestor));
				
				if(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO.equals(tipo.getCodigo()))
					if(asu.getGestor()!= null && asu.getGestor().getUsuario()!=null && asu.getGestor().getUsuario().getId().equals(idUsuario))
						res = true;
				if(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR.equals(tipo.getCodigo()))					
					if(asu.getSupervisor()!= null && asu.getSupervisor().getUsuario()!=null && asu.getSupervisor().getUsuario().getId().equals(idUsuario))
						res = true;
				
			}
		}
		
		return res;
	}
	@BusinessOperation(EXT_BO_MULTIGESTOR_EXISTE_GESTOR)
	@Override
	public boolean existeTipoGestor(String ugCodigo, Long ugId, Long tipoGestor, Long idUsuario){
		boolean res = false;
		
		
		Filter fAuditoria = genericDao.createFilter(FilterType.EQUALS,
				"auditoria.borrado", false);


		if ((!Checks.esNulo(ugCodigo)) && (!Checks.esNulo(ugId))  && (!Checks.esNulo(tipoGestor))  && (!Checks.esNulo(idUsuario)) ) {

			Filter fTipoUnidadGestion = genericDao.createFilter(
					FilterType.EQUALS, "tipoEntidad.codigo", ugCodigo);
			Filter fIdUnidadGestion = genericDao.createFilter(
					FilterType.EQUALS, "unidadGestionId", ugId);
			Filter fTipoGestor = genericDao.createFilter(
					FilterType.EQUALS, "tipoGestor.id", tipoGestor);
			Filter fUsuario = genericDao.createFilter(
					FilterType.EQUALS, "gestor.id", idUsuario);

			List<EXTGestorEntidad> lista = genericDao.getList(
					EXTGestorEntidad.class, fTipoUnidadGestion,
					fIdUnidadGestion,fTipoGestor,fUsuario, fAuditoria);

			if(lista != null && lista.size() > 0)
				res = true;

			if(!res){//seguimos comprobando los gestores tradicionales
				res = existeGestoresTradicionalesDelAsuto(ugCodigo, ugId, idUsuario, tipoGestor);
			}
				
		}
		
		return res;
	}

}
