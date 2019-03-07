package es.pfsgroup.framework.paradise.gestorEntidad.manager;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.gestorEntidad.model.GestorEntidad;
import es.capgemini.pfs.gestorEntidad.model.GestorExpediente;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.gestorEntidad.api.GestorEntidadApi;
import es.pfsgroup.framework.paradise.gestorEntidad.dao.GestorEntidadDao;
import es.pfsgroup.framework.paradise.gestorEntidad.dao.GestorEntidadHistoricoDao;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorAsunto;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorAsuntoHistorico;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorExpedienteHistorico;
import es.pfsgroup.recovery.api.ExpedienteApi;

/**
 * Manager de la entidad incidencia expdediente.
 * 
 * @author Oscar
 * 
 */
@Component
public class GestorEntidadManager implements GestorEntidadApi {

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	GestorEntidadHistoricoDao gestorEntidadHistoricoDao;

	@Autowired
	GestorEntidadDao gestorEntidadDao;
	
	public List<GestorEntidadHistorico> getListGestoresActivosAdicionalesHistoricoData(GestorEntidadDto dto) {

		List<GestorEntidadHistorico> listado = gestorEntidadHistoricoDao.getListGestorActivoOrderedByEntidad(dto);

		return listado;
	}

	public List<GestorEntidadHistorico> getListGestoresAdicionalesHistoricoData(GestorEntidadDto dto) {

		List<GestorEntidadHistorico> listado = gestorEntidadHistoricoDao.getListOrderedByEntidad(dto);

		return listado;
	}

	@Transactional(readOnly = false)
	public void insertarGestorAdicionalEntidad(GestorEntidadDto dto) {

		if (GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE.equals(dto.getTipoEntidad())) {

			insertarGestorExpediente(dto);
		} else if (GestorEntidadDto.TIPO_ENTIDAD_ASUNTO.equals(dto.getTipoEntidad())) {

			insertarGestorAsunto(dto);
		}
	}

	private void insertarGestorExpediente(GestorEntidadDto dto) {

		// TODO refactorizar
		if (!Checks.esNulo(dto.getIdEntidad()) && !Checks.esNulo(dto.getIdUsuario()) && !Checks.esNulo(dto.getIdTipoDespacho())) {

			EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdTipoGestor()));
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", dto.getIdEntidad());
			Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.id", dto.getIdTipoGestor());
			GestorExpediente gee = genericDao.get(GestorExpediente.class, filtro, filtroTipoGestor);

			Usuario usu = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdUsuario()));
			Expediente exp = proxyFactory.proxy(ExpedienteApi.class).getExpediente(dto.getIdEntidad());

			if (Checks.esNulo(gee)) {
				gee = new GestorExpediente();
				gee.setExpediente(exp);
				gee.setTipoGestor(tipoGestor);
				gee.setAuditoria(Auditoria.getNewInstance());
				gee.setUsuario(usu);
				gestorEntidadDao.save(gee);
				this.guardarHistoricoGestorAdicionalEntidad(gee, exp);
			} else {
				if (dto.getIdUsuario() != gee.getUsuario().getId()) {
					this.actualizaFechaHastaHistoricoGestorAdicionalExpediente(gee);
					gee.setUsuario(usu);
					gee.setAuditoria(Auditoria.getNewInstance());
					this.guardarHistoricoGestorAdicionalEntidad(gee, exp);
				}
				gestorEntidadDao.saveOrUpdate(gee);
			}
		}

	}

	private void actualizaFechaHastaHistoricoGestorAdicionalExpediente(
			GestorExpediente gee) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expediente.id", gee.getExpediente().getId() );
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.id", gee.getTipoGestor().getId());
		List<GestorEntidadHistorico> geh = genericDao.getList(GestorEntidadHistorico.class, filtroTipoGestor, filtro);

		Date hoy = new Date();
		for (GestorEntidadHistorico g : geh) {
			if (Checks.esNulo(g.getFechaHasta())) {
				g.setFechaHasta(hoy);
				gestorEntidadHistoricoDao.saveOrUpdate(g);
			}
		}
		
	}

	private void insertarGestorAsunto(GestorEntidadDto dto) {

		// TODO refactorizar
		if (!Checks.esNulo(dto.getIdEntidad()) && !Checks.esNulo(dto.getIdUsuario()) && !Checks.esNulo(dto.getIdTipoDespacho())) {

			EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdTipoGestor()));
			Filter filtroAsunto = genericDao.createFilter(FilterType.EQUALS, "asunto.id", dto.getIdEntidad());
			Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.id", dto.getIdTipoGestor());

			Usuario usu = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdUsuario()));

			GestorAsunto gaa = genericDao.get(GestorAsunto.class, filtroAsunto, filtroTipoGestor);
			Asunto asu = proxyFactory.proxy(AsuntoApi.class).get(dto.getIdEntidad());

			if (Checks.esNulo(gaa)) {
				gaa = new GestorAsunto();
				gaa.setAsunto(asu);
				gaa.setTipoGestor(tipoGestor);
				gaa.setUsuario(usu);
				gaa.setAuditoria(Auditoria.getNewInstance());
				gestorEntidadDao.save(gaa);
				this.guardarHistoricoGestorAdicionalEntidad(gaa, asu);
			} else {
				gaa.setUsuario(usu);
				if (dto.getIdUsuario() != gaa.getUsuario().getId()) {
					this.actualizaFechaHastaHistoricoGestorAdicional(gaa);
					this.guardarHistoricoGestorAdicionalEntidad(gaa, asu);
				}
				gestorEntidadDao.saveOrUpdate(gaa);
			}
		}
	}

	// Guardamos el hist�rico de cambios de los gestores.
	private void guardarHistoricoGestorAdicionalEntidad(GestorEntidad gee, Object obj) {
		// TODO refactorizar
		if (gee instanceof GestorExpediente) {
			GestorExpedienteHistorico gaah = new GestorExpedienteHistorico();
			gaah.setUsuario(gee.getUsuario());
			gaah.setAuditoria(Auditoria.getNewInstance());
			gaah.setExpediente((Expediente) obj);
			gaah.setTipoGestor(gee.getTipoGestor());
			gaah.setFechaDesde(new Date());
			gestorEntidadHistoricoDao.save(gaah);
		}

		if (gee instanceof GestorAsunto) {
			GestorAsuntoHistorico gaah = new GestorAsuntoHistorico();
			gaah.setUsuario(gee.getUsuario());
			gaah.setAuditoria(Auditoria.getNewInstance());
			gaah.setAsunto((Asunto) obj);
			gaah.setTipoGestor(gee.getTipoGestor());
			gaah.setFechaDesde(new Date());
			gestorEntidadHistoricoDao.save(gaah);
		}
	}

	private void actualizaFechaHastaHistoricoGestorAdicional(GestorEntidad gee) {

		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.id", gee.getTipoGestor().getId());
		List<GestorEntidadHistorico> geh = genericDao.getList(GestorEntidadHistorico.class, filtroTipoGestor);

		Date hoy = new Date();
		for (GestorEntidadHistorico g : geh) {
			if (Checks.esNulo(g.getFechaHasta())) {
				g.setFechaHasta(hoy);
				gestorEntidadHistoricoDao.saveOrUpdate(g);
			}
		}
	}

	@Transactional(readOnly = false)
	public void borrarGestorAdicionalEntidad(GestorEntidadDto dto) {

		Filter filtroAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
 
		GestorEntidad gestorEntidad = genericDao.get(GestorEntidad.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", dto.getIdUsuario()),
				//genericDao.createFilter(FilterType.EQUALS, "tipoGestor.descripcion", dto.getIdTipoGestor().toString()),
				filtroAuditoria);

		if (gestorEntidad != null) {
			actualizaFechaHastaHistoricoGestorAdicional(gestorEntidad);
			gestorEntidadDao.delete(gestorEntidad);
		}


	}

	public List<EXTDDTipoGestor> getListTipoGestorEditables(Long idTipoGestor) {
		
		List<EXTDDTipoGestor> listado = gestorEntidadDao.getListTipoGestorEditables(idTipoGestor);
		
		return listado;
	}

	public List<Usuario> getListUsuariosGestoresExpedientePorTipo(Long idTipoGestor) {
		return gestorEntidadDao.getListUsuariosGestoresExpedientePorTipo(idTipoGestor);
	}

	@Override
	public String getCodigoGestorPorUsuario(Long idUsuario) {
		return gestorEntidadDao.getCodigoGestorPorUsuario(idUsuario);
	}
	
	public List<Usuario> getListUsuariosGestoresPorTipoCodigo(String codigoTipoGestor) {
		return gestorEntidadDao.getListUsuariosGestoresPorTipoCodigo(codigoTipoGestor);
	}
	

}
