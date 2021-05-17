package es.pfsgroup.plugin.rem.configuracion.daoImpl;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.configuracion.dao.ConfiguracionDao;
import es.pfsgroup.plugin.rem.model.ConfiguracionReam;
import es.pfsgroup.plugin.rem.model.DtoMantenimientoFilter;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;


@SuppressWarnings("rawtypes")
@Repository("ConfiguracionDao")
public class ConfiguracionDaoImpl extends AbstractEntityDao implements ConfiguracionDao{
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	public static final String SI = "1";
	public static final int VALOR_SI = 1;
	public static final int VALOR_NO = 0;
	
	@Override
	public List<ConfiguracionReam> getListMantenimiento(DtoMantenimientoFilter dto){
		
		HQLBuilder hb = new HQLBuilder(" FROM ConfiguracionReam cfrm ");
		

		if(dto.getCodCartera() != null && !dto.getCodCartera().isEmpty()) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "cartera.codigo", dto.getCodCartera());
		}
		
		if (dto.getCodSubCartera() != null && !dto.getCodSubCartera().isEmpty()) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "subcartera.codigo", dto.getCodSubCartera());
		}
		if (dto.getCodPropietario() != null && !Checks.esNulo(dto.getCodPropietario())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "propietario.id", dto.getCodPropietario());
		}
		if (dto.getCarteraMacc() != null && !dto.getCarteraMacc().isEmpty()) {
			if (SI.equalsIgnoreCase(dto.getCarteraMacc())) {
				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "carteraMacc", VALOR_SI);
			}else {
				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "carteraMacc", VALOR_NO);
			}
			
		}		


		/*List<ConfiguracionReam> configuracionList = 
				(List<ConfiguracionReam>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();*/

		return HibernateQueryUtils.list(this, hb);
		
		//return configuracionList;
	}


}
