package es.pfsgroup.plugin.rem.gastosExpediente.dao.impl;


import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.gastosExpediente.dao.GastosExpedienteDao;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDAccionGastos;
import es.pfsgroup.plugin.rem.rest.dto.ComisionDto;

@Repository("GastosExpedienteDao")
public class GastosExpedienteDaoImpl extends AbstractEntityDao<GastosExpediente, Long> implements GastosExpedienteDao{
	
	
	
	@Override
	public List<GastosExpediente> getListaGastosExpediente(ComisionDto comisionDto) {
		
		HQLBuilder hql = new HQLBuilder("from GastosExpediente ge");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "ge.expediente.oferta.numOferta", comisionDto.getIdOfertaRem());
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "ge.expediente.oferta.idWebCom", comisionDto.getIdOfertaWebcom());		
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "ge.proveedor.id", comisionDto.getIdProveedorRem());
		
		if(!Checks.esNulo(comisionDto.getEsPrescripcion()) && comisionDto.getEsPrescripcion()){			
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "ge.accionGastos.codigo", DDAccionGastos.CODIGO_PRESCRIPCION);
			
		}else if((!Checks.esNulo(comisionDto.getEsColaboracion()) && comisionDto.getEsColaboracion()) ||
				 (!Checks.esNulo(comisionDto.getEsFdv()) && comisionDto.getEsFdv())){	
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "ge.accionGastos.codigo", DDAccionGastos.CODIGO_COLABORACION);
			
		}else if((!Checks.esNulo(comisionDto.getEsDoblePrescripcion()) && comisionDto.getEsDoblePrescripcion()) ||
				 (!Checks.esNulo(comisionDto.getEsResponsable()) && comisionDto.getEsResponsable())){	
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "ge.accionGastos.codigo", DDAccionGastos.CODIGO_DOBLE_PRESCRIPCION);
			
		}

		return HibernateQueryUtils.list(this, hql);
	}

}
