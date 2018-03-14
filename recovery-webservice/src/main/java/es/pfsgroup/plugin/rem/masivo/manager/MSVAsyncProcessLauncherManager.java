package es.pfsgroup.plugin.rem.masivo.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.rem.masivo.api.MSVAsyncProcessLauncherApi;
import es.pfsgroup.recovery.api.UsuarioApi;


@Service("msvAsyncProcessLauncherManager")
public class MSVAsyncProcessLauncherManager implements MSVAsyncProcessLauncherApi {

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Transactional(readOnly = false)
	public Boolean launchProcess(Long idProcess, Long idOperation) {
		
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		
		Thread hilo = new Thread(new MSVAsyncProcess(idProcess, idOperation, usuarioLogado.getUsername()));
		hilo.start();		
		
		return true;
	}

}
