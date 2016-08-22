package es.pfsgroup.plugin.rem.api;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoAviso;


public interface AgrupacionAvisadorApi {
		
		DtoAviso getAviso(ActivoAgrupacion agrupacion, Usuario usuarioLogado);

    }


