package es.pfsgroup.plugin.rem.utils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;

@Component
public class MSVREMUtils {
	
	@Autowired
	private UsuarioApi usuarioApi;
	
	@Autowired
	private GenericAdapter adapter;
	
	public static final int MASIVE_PROCES_USER_STARTER_INDEX = 0;
	
	private static final int[] INDEX_HOLDER = {MASIVE_PROCES_USER_STARTER_INDEX};
	
	public Object[] getExtraArgs() {
		
		Object[] extraArgs = new Object[INDEX_HOLDER.length];
		
		extraArgs[MASIVE_PROCES_USER_STARTER_INDEX] = getUsuarioLogado();
		
		return extraArgs;
		
	}
	
	public Usuario getUsuarioLogado() {
		
		Usuario usuario = usuarioApi.getUsuarioLogado();
		
		if (Checks.esNulo(usuario)) {
			usuario = adapter.getUsuarioLogado();
		}
		
		return usuario;
		
	}

}
