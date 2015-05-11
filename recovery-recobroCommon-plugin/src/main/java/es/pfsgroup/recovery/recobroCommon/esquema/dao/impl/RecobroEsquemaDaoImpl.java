package es.pfsgroup.recovery.recobroCommon.esquema.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.esquema.dao.api.RecobroEsquemaDao;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroEsquemaDto;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;

@Repository("RecobroEsquemaDao")
public class RecobroEsquemaDaoImpl extends AbstractEntityDao<RecobroEsquema, Long> implements RecobroEsquemaDao{

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Page buscarRecobroEsquema(RecobroEsquemaDto dto) {
		Assertions.assertNotNull(dto, "RecobroAgenciaDto: No puede ser NULL");
		
		HQLBuilder hb = new HQLBuilder("select distinct esquema from RecobroEsquema esquema");
		hb.appendWhere("esquema.auditoria.borrado = 0");

		HQLBuilder.addFiltroLikeSiNotNull(hb, "esquema.nombre", dto.getNombre() ,true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "esquema.estadoEsquema.codigo", dto.getEstado());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "esquema.auditoria.usuarioCrear", dto.getAutor(), true);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "esquema.descripcion", dto.getDescripcion(), true);
		
		//hb.orderBy("esquema.nombre", HQLBuilder.ORDER_ASC);
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public RecobroEsquema getUltimaVersionDelEsquema(Long idEsquema) {
		String hsql = " SELECT DISTINCT esquema " +
					  " FROM RecobroEsquema esquemaConsulta, RecobroEsquema esquema " +
					  " WHERE esquema.idGrupoVersion = esquemaConsulta.idGrupoVersion AND" +
					  " 	  esquema.auditoria.borrado = 0 AND " +		
					  "       esquemaConsulta.id = " + idEsquema +
					  " ORDER BY esquema.versionrelease + esquema.majorRelease + esquema.minorRelease DESC" +
					  "			 esquema.id DESC ";		
		List<RecobroEsquema> ret = getHibernateTemplate().find(hsql.toString());
		return ret.size() == 0 ? null : ret.get(0);
	}

	@Override
	public List<RecobroEsquema> getEsquemasBloqueados() {
		String hsql = " SELECT DISTINCT esquema " +
				  		" FROM RecobroEsquema esquema " +
				  		" WHERE (" +
				  			"esquema.estadoEsquema.codigo = '" + RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_PENDIENTELIBERAR + "'" +
				  			" OR esquema.estadoEsquema.codigo = '" + RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_LIBERADO + "'" +
//				  			" OR esquema.estadoEsquema.codigo = '" + RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_SIMULADO + "'" +
				  					")" +
				  		" AND esquema.auditoria.borrado = 0";		
		return getHibernateTemplate().find(hsql.toString());
	}

}
