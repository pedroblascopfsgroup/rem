package es.pfsgroup.plugin.rem.gestor;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.gestorEntidad.model.GestorEntidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.gestorEntidad.dao.GestorEntidadDao;
import es.pfsgroup.framework.paradise.gestorEntidad.dao.GestorEntidadHistoricoDao;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.manager.GestorEntidadManager;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GestorExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GestorExpedienteComercialHistorico;

@Component
public class GestorExpedienteComercialManager implements GestorExpedienteComercialApi {
	
	@Autowired
	GenericABMDao genericDao;
	
	@Autowired
	private ExpedienteComercialApi expedienteApi;
	
	@Autowired
	GestorEntidadDao gestorEntidadDao;
	
	@Autowired
	GestorEntidadHistoricoDao gestorEntidadHistoricoDao;
	
	@Override
	@Transactional(readOnly = false)
	public Boolean insertarGestorAdicionalExpedienteComercial(GestorEntidadDto dto) {
		Boolean inserccionOK = true;
		if(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL.equals(dto.getTipoEntidad())){
		
			if (!Checks.esNulo(dto.getIdEntidad()) && !Checks.esNulo(dto.getIdUsuario())/* && !Checks.esNulo(dto.getIdTipoDespacho())*/) {

				EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdTipoGestor()));
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expedienteComercial.id", dto.getIdEntidad());
				Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.id", dto.getIdTipoGestor());
				GestorExpedienteComercial gec = genericDao.get(GestorExpedienteComercial.class, filtro, filtroTipoGestor);
				
				Usuario usu = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdUsuario()));
				ExpedienteComercial expediente = expedienteApi.findOne(dto.getIdEntidad());
				
				if (Checks.esNulo(gec)) {
					gec = new GestorExpedienteComercial();
					gec.setExpedienteComercial(expediente);
					gec.setTipoGestor(tipoGestor);
					gec.setAuditoria(Auditoria.getNewInstance());
					gec.setUsuario(usu);
					gestorEntidadDao.save(gec);
					this.guardarHistoricoGestorAdicionalEntidad(gec, expediente);
				}
				else {
					if (!dto.getIdUsuario().equals(gec.getUsuario().getId())) {
						this.actualizaFechaHastaHistoricoGestorAdicionalExpedienteComercial(gec);
						gec.setUsuario(usu);
						gec.setAuditoria(Auditoria.getNewInstance());
						this.guardarHistoricoGestorAdicionalEntidad(gec, expediente);
					}
					gestorEntidadDao.saveOrUpdate(gec);
					
					//Actualizamos usuarios de las tareas
					//actualizarTareas(dto.getIdEntidad());
				}
			}
		}
		
		return inserccionOK;
	}
	
	private void guardarHistoricoGestorAdicionalEntidad(GestorEntidad gee, Object obj) {
		GestorExpedienteComercialHistorico geh = new GestorExpedienteComercialHistorico();
		geh.setUsuario(gee.getUsuario());
		geh.setAuditoria(Auditoria.getNewInstance());
		geh.setExpedienteComercial((ExpedienteComercial) obj);
		geh.setTipoGestor(gee.getTipoGestor());
		geh.setFechaDesde(new Date());
		gestorEntidadHistoricoDao.save(geh);
	}
	
	private void actualizaFechaHastaHistoricoGestorAdicionalExpedienteComercial(GestorExpedienteComercial gec) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expedienteComercial.id", gec.getExpedienteComercial().getId() );
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.id", gec.getTipoGestor().getId());
		List<GestorEntidadHistorico> geh = genericDao.getList(GestorEntidadHistorico.class, filtroTipoGestor, filtro);

		Date hoy = new Date();
		for (GestorEntidadHistorico g : geh) {
			if (Checks.esNulo(g.getFechaHasta())) {
				g.setFechaHasta(hoy);
				gestorEntidadHistoricoDao.saveOrUpdate(g);
			}
		}
	}
	
	public List<GestorEntidadHistorico> getListGestoresAdicionalesHistoricoData(GestorEntidadDto dto) {
		List<GestorEntidadHistorico> listado = gestorEntidadHistoricoDao.getListOrderedByEntidad(dto);

		return listado;
	}
	
	@Override
	public String[] getCodigosTipoGestorExpedienteComercial() {
		
		return new String[]{CODIGO_GESTOR_COMERCIAL_RETAIL, CODIGO_GESTOR_COMERCIAL_BACKOFFICE, CODIGO_GESTOR_COMERCIAL_SINGULAR,
				CODIGO_GESTOR_FORMALIZACION, CODIGO_GESTORIA_FORMALIZACION, CODIGO_SUPERVISOR_COMERCIAL_RETAIL, CODIGO_SUPERVISOR_COMERCIAL_SINGULAR,
				CODIGO_SUPERVISOR_FORMALIZACION};
	}

}
