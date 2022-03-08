package es.pfsgroup.plugin.rem.activo;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoHistDao;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivoHistorico;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosAgrupacionIncAnuladas;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.recovery.api.UsuarioApi;

@Service("activoAgrupacionActivoManager")
public class ActivoAgrupacionActivoManager extends BusinessOperationOverrider<ActivoAgrupacionActivoApi>
		implements ActivoAgrupacionActivoApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

	protected static final Log logger = LogFactory.getLog(ActivoAgrupacionActivoManager.class);

	
	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

	@Autowired
	private ActivoAgrupacionActivoHistDao activoAgrupacionActivoHistDao;
	
	@Autowired
	private AgrupacionAdapter agrupacionAdapter;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Override
	public String managerName() {
		return "activoAgrupacionActivoManager";
	}

	
	@Override
	@BusinessOperation(overrides = "activoAgrupacionActivoManager.get")
	public ActivoAgrupacionActivo get(Long id) {
		return activoAgrupacionActivoDao.get(id);
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionActivoManager.getActivoAgrupacionActivoByIdActivoAndIdAgrupacion")
	public ActivoAgrupacionActivo getActivoAgrupacionActivoByIdActivoAndIdAgrupacion(long idActivo, long idAgrupacion) {
		return activoAgrupacionActivoDao.getActivoAgrupacionActivoByIdActivoAndIdAgrupacion(idActivo, idAgrupacion);
	}

	@Override
	@BusinessOperation(overrides = "activoAgrupacionActivoManager.getByIdActivoAndIdAgrupacion")
	public ActivoAgrupacionActivo getByIdActivoAndIdAgrupacion(long idActivo, long idAgrupacion) {
		return activoAgrupacionActivoDao.getByIdActivoAndIdAgrupacion(idActivo, idAgrupacion);
	}
	
	@Override
	@BusinessOperation(overrides = "activoAgrupacionActivoManager.save")
	public Long save(ActivoAgrupacionActivo activoAgrupacionActivo) {

		ActivoAgrupacionActivoHistorico agrupacionActivoHistorico;
		agrupacionActivoHistorico = activoAgrupacionActivoHistDao.getHistoricoAgrupacionByActivoAndAgrupacion(
				activoAgrupacionActivo.getActivo().getId(), activoAgrupacionActivo.getAgrupacion().getId());
		if (agrupacionActivoHistorico == null) {
			agrupacionActivoHistorico = new ActivoAgrupacionActivoHistorico();
			agrupacionActivoHistorico.setActivo(activoAgrupacionActivo.getActivo());
			agrupacionActivoHistorico.setAgrupacion(activoAgrupacionActivo.getAgrupacion());
			//agrupacionActivoHistorico.setPrincipal(activoAgrupacionActivo.getPrincipal());
			agrupacionActivoHistorico.setFechaDesde(new Date());
			activoAgrupacionActivoHistDao.save(agrupacionActivoHistorico);
			
		} else {
			//TODO: Si vamos a crear un activoAgrupHistorico desde cero y ya existe... que hacemos.
		}

		Long resultado = activoAgrupacionActivoDao.save(activoAgrupacionActivo);
		return resultado;
	}
	
	@Override
	@BusinessOperation(overrides = "activoAgrupacionActivoManager.delete")
	public void delete(ActivoAgrupacionActivo activoAgrupacionActivo) {

		ActivoAgrupacionActivoHistorico agrupacionActivoHistorico;
		agrupacionActivoHistorico = activoAgrupacionActivoHistDao.getHistoricoAgrupacionByActivoAndAgrupacion(
				activoAgrupacionActivo.getActivo().getId(), activoAgrupacionActivo.getAgrupacion().getId());
				
		Auditoria auditoria = new Auditoria();
		auditoria.setFechaModificar(new Date());
		Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		auditoria.setUsuarioModificar(usu.getUsername());		
		
		if (agrupacionActivoHistorico == null) {
			agrupacionActivoHistorico = new ActivoAgrupacionActivoHistorico();
			agrupacionActivoHistorico.setActivo(activoAgrupacionActivo.getActivo());
			agrupacionActivoHistorico.setAgrupacion(activoAgrupacionActivo.getAgrupacion());
			//agrupacionActivoHistorico.setPrincipal(activoAgrupacionActivo.getPrincipal());
			agrupacionActivoHistorico.setFechaDesde(new Date());
			agrupacionActivoHistorico.setFechaHasta(new Date());
			auditoria.setFechaCrear(new Date());
			auditoria.setUsuarioCrear(usu.getUsername());	
			agrupacionActivoHistorico.setAuditoria(auditoria);
			activoAgrupacionActivoHistDao.save(agrupacionActivoHistorico);
		} else {
			agrupacionActivoHistorico.setFechaHasta(new Date());
			auditoria.setFechaCrear(agrupacionActivoHistorico.getAuditoria().getFechaCrear());
			auditoria.setUsuarioCrear(agrupacionActivoHistorico.getAuditoria().getUsuarioCrear());
			agrupacionActivoHistorico.setAuditoria(auditoria);
			activoAgrupacionActivoHistDao.update(agrupacionActivoHistorico);
		}
		
		activoAgrupacionActivoDao.deleteById(activoAgrupacionActivo.getId());	
	}

	@Override
	public int numActivosPorActivoAgrupacion(long idAgrupacion) {
		return activoAgrupacionActivoDao.numActivosPorActivoAgrupacion(idAgrupacion);
	}
	
	@Override
    public ActivoAgrupacionActivo primerActivoPorActivoAgrupacion(long idAgrupacion) {
		return activoAgrupacionActivoDao.primerActivoPorActivoAgrupacion(idAgrupacion);
    }

	@Override
	public boolean isUniqueRestrictedActive(Activo activo) {
		return activoAgrupacionActivoDao.isUniqueRestrictedActive(activo);
	}
	
	@Override
	public boolean isUniqueNewBuildingActive(Activo activo){
		return activoAgrupacionActivoDao.isUniqueNewBuildingActive(activo);
	}
	
	@Override
	public boolean isUniqueAgrupacionActivo(Activo activo, ActivoAgrupacion agrupacionActivo){
		return activoAgrupacionActivoDao.isUniqueAgrupacionActivo(activo.getId(), agrupacionActivo.getTipoAgrupacion().getCodigo(), agrupacionActivo.getNumAgrupRem());
	}
	
	@Override
	public boolean estaAgrupacionActivoConFechaBaja(Activo activo){
		return activoAgrupacionActivoDao.estaAgrupacionActivoConFechaBaja(activo);
	}
	
	@Override
	public List<ActivoAgrupacionActivo> getListActivosAgrupacion(DtoAgrupacionFilter dtoAgrupActivo){		
		List<ActivoAgrupacionActivo> lista = null;
				
		try{
			
			lista = activoAgrupacionActivoDao.getListActivosAgrupacion(dtoAgrupActivo);
		
		} catch(Exception ex) {
			ex.printStackTrace();	
		}
		
		return lista;	
	}
	
	//Devuelve verdadero si en la agrupación existe alguna Oferta activa (estado != RECHAZADA)
	@Override
	public Boolean existenOfertasActivasEnAgrupacion(Long idAgrupacion) {
		List<VGridOfertasActivosAgrupacionIncAnuladas> lista = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
		
		for(VGridOfertasActivosAgrupacionIncAnuladas oferta : lista) {
			if(!DDEstadoOferta.CODIGO_RECHAZADA.equals(oferta.getCodigoEstadoOferta())
					&& !DDEstadoOferta.CODIGO_CONGELADA.equals(oferta.getCodigoEstadoOferta())
					&& !DDEstadoOferta.CODIGO_PENDIENTE.equals(oferta.getCodigoEstadoOferta())
					&& !DDEstadoOferta.CODIGO_CADUCADA.equals(oferta.getCodigoEstadoOferta()))
				return true;
		}
		
		return false;
	}
	
	@Override
	public ActivoAgrupacionActivo getActivoAgrupacionActivoPrincipalByIdAgrupacion(long idAgrupacion) {
		return activoAgrupacionActivoDao.getActivoAgrupacionActivoPrincipalByIdAgrupacion(idAgrupacion);
	}
	
	@Override
	public Activo getPisoPilotoByIdAgrupacion(long idAgrupacion) {
		return activoAgrupacionActivoDao.getPisoPilotoByIdAgrupacion(idAgrupacion);
	}

}