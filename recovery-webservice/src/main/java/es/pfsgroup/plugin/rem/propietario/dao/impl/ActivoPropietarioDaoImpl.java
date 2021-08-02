package es.pfsgroup.plugin.rem.propietario.dao.impl;

import java.util.Arrays;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.propietario.dao.ActivoPropietarioDao;

@Repository("ActivoPropietarioDao")
public class ActivoPropietarioDaoImpl extends AbstractEntityDao<ActivoPropietario,Long> implements ActivoPropietarioDao {

	@Override
	public List<ActivoPropietario> getPropietarioIdDescripcionCodigo() {
		// TODO Auto-generated method stub
		
	HQLBuilder hb = new HQLBuilder(" from ActivoPropietario act");
	HQLBuilder.addFiltroNotIsNull(hb, "act.nombre");
	HQLBuilder.addFiltroWhereInSiNotNull(hb, "act.cartera.codigo", Arrays.asList(DDCartera.CODIGO_CARTERA_BBVA, DDCartera.CODIGO_CARTERA_CERBERUS));
	
	List<ActivoPropietario> lista = HibernateQueryUtils.list(this, hb);

	return lista;
		
	}
	
	



}
