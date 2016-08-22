package es.pfsgroup.plugin.rem.tareasactivo.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.model.VTareaActivoCount;
import es.pfsgroup.plugin.rem.tareasactivo.dao.VTareaActivoCountDao;
import es.pfsgroup.recovery.ext.impl.multigestor.model.EXTGrupoUsuarios;

@Repository("VTareaActivoCountDao")
public class VTareaActivoCountDaoImpl extends AbstractEntityDao<VTareaActivoCount, Long> implements VTareaActivoCountDao{

	@Override
	public List<VTareaActivoCount> getContador(Usuario usuario, EXTGrupoUsuarios grupoUsuario) {
		
		ArrayList<Long> usuarioYGrupo = new ArrayList<Long>();
		usuarioYGrupo.add(usuario.getId());
		if(!Checks.esNulo(grupoUsuario))
			usuarioYGrupo.add(grupoUsuario.getGrupo().getId());
		
		HQLBuilder hb = new HQLBuilder(" from VTareaActivoCount");
		HQLBuilder.addFiltroWhereInSiNotNull(hb, "usuario", usuarioYGrupo);
		
		return HibernateQueryUtils.list(this, hb);
	}

}
