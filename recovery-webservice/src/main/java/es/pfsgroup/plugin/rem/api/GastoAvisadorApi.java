package es.pfsgroup.plugin.rem.api;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.GastoProveedor;


public interface GastoAvisadorApi {
	
		DtoAviso getAviso(GastoProveedor gasto, Usuario usuarioLogado);
	
    }


