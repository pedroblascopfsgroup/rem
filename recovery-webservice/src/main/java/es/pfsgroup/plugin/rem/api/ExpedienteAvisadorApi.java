package es.pfsgroup.plugin.rem.api;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;


public interface ExpedienteAvisadorApi {
	
		DtoAviso getAviso(ExpedienteComercial expediente, Usuario usuarioLogado);
	
    }


