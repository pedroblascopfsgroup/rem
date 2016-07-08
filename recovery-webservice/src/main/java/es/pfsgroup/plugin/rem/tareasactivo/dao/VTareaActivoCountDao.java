package es.pfsgroup.plugin.rem.tareasactivo.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.VTareaActivoCount;
import es.pfsgroup.recovery.ext.impl.multigestor.model.EXTGrupoUsuarios;

public interface VTareaActivoCountDao extends AbstractDao<VTareaActivoCount, Long>{

	List<VTareaActivoCount> getContador(Usuario usuario, EXTGrupoUsuarios grupoUsuario);
	
}