package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api.VListadoPreProyectadoExpDao;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model.VListadoPreProyectadoExp;

@Repository("VListadoPreProyectadoExpDao")
public class VListadoPreProyectadoExpDaoImpl extends AbstractEntityDao<VListadoPreProyectadoExp, Long> implements VListadoPreProyectadoExpDao {

	@Override
	public List<VListadoPreProyectadoExp> getListadoPreProyectadoExp(
			ListadoPreProyectadoDTO dto) {
		// TODO Auto-generated method stub
		return null;
	}

}
