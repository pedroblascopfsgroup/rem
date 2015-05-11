package es.pfsgroup.plugin.recovery.masivo.api.impl;

import java.util.Collection;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.api.AsuntoCoreApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVAsuntoApi;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVAsuntoDao;
import es.pfsgroup.plugin.recovery.masivo.model.MSVAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

@Service
@Transactional(readOnly = false)
public class MSVAsuntoManager implements MSVAsuntoApi {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private MSVAsuntoDao msvAsuntoDao;
	
	@Autowired(required=false)
	AsuntoCoreApi asuntoCoreApi;

	@Override
	@BusinessOperation(MSV_BO_COMPROBAR_ESTADO_ASUNTO)
	public boolean comprobarEstadoAsunto(String nombreAsunto) {

		Filter filtroExiste = genericDao.createFilter(FilterType.EQUALS,
				"nombre", nombreAsunto);
		Filter filtroNoBorrado = genericDao.createFilter(FilterType.EQUALS,
				"borrado", 0);
		Filter filtroEstadoAceptado = genericDao.createFilter(
				FilterType.EQUALS, "estadoAsunto",
				DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO);
		EXTAsunto asunto = (EXTAsunto) genericDao.get(EXTAsunto.class,
				filtroExiste, filtroNoBorrado, filtroEstadoAceptado);
		if (asunto == null) {
			return false;
		} else {
			return true;
		}
	}

	@Override
	@BusinessOperation(MSV_BO_CONSULTAR_ASUNTOS)
	public Collection<? extends MSVAsunto> getAsuntos(String query) {
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		Long idUsuarioLogado = usuarioLogado.getId();
		return msvAsuntoDao.getAsuntos(query, idUsuarioLogado);
	}

	@Override
	@BusinessOperation(MSV_ASUNTO_CANCELA_ASUNTO)
	public void cancelaAsunto(Asunto asunto, Date fechaCancelacion) {
		asuntoCoreApi.cancelaAsunto(asunto, fechaCancelacion);
	}
	
	@Override
	@BusinessOperation(MSV_ASUNTO_CANCELA_ASUNTO_CON_MOTIVO)
	public void cancelaAsuntoConMotivo(Asunto asunto, Date fechaCancelacion,String motivoCancelacion) {
		asuntoCoreApi.cancelaAsuntoConMotivo(asunto, fechaCancelacion, motivoCancelacion);
	}
	
	@Override
	@BusinessOperation(MSV_ASUNTO_PARALIZA_ASUNTO)
	public void paralizaAsunto(Asunto asunto, Date fechaParalizacion) {
		asuntoCoreApi.paralizaAsunto(asunto, fechaParalizacion);
	}

}
