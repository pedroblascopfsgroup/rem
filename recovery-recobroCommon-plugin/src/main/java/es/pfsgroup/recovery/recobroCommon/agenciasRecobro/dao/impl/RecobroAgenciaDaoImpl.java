package es.pfsgroup.recovery.recobroCommon.agenciasRecobro.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.dao.api.RecobroAgenciaDao;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.dto.RecobroAgenciaDto;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;

/**
 * Clase de acceso a base de datos para la clase RecobroAgencia
 * @author diana
 *
 */
@Repository("RecobroAgenciaDao")
public class RecobroAgenciaDaoImpl extends AbstractEntityDao<RecobroAgencia, Long> implements RecobroAgenciaDao{

	/**
	 * {@inheritDoc} 
	 */
	@Override
	public Page buscaAgencias(RecobroAgenciaDto dto) {
		Assertions.assertNotNull(dto, "RecobroAgenciaDto: No puede ser NULL");
		
		HQLBuilder hb = new HQLBuilder("select distinct agencia from RecobroAgencia agencia");
				
		if (!Checks.esNulo(dto.getNombre())){
			HQLBuilder.addFiltroLikeSiNotNull(hb, "agencia.nombre", dto.getNombre() ,true);
		}
		if (!Checks.esNulo(dto.getDespacho())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "agencia.despacho.id", dto.getDespacho());
		}
		
		if (!Checks.esNulo(dto.getIdEsquema())){
			hb.appendWhere(" agencia.id in (" +
					"		 select suba.agencia.id " +
					"		 from RecobroEsquema esq, RecobroCarteraEsquema ce, RecobroSubCartera sub, RecobroSubcarteraAgencia suba " +
					"		 where esq.id = ce.esquema.id AND " +
					"			   esq.auditoria.borrado = 0 AND " +
					"		 	   ce.id = sub.carteraEsquema.id AND " +
					"			   ce.auditoria.borrado = 0 AND	" +
					"			   sub.id = suba.subCartera.id AND " +
					"			   sub.auditoria.borrado = 0 AND " +
					"			   suba.auditoria.borrado = 0 AND " +
					"			   esq.id = " + dto.getIdEsquema() + ")");					
		}
		
		hb.appendWhere("agencia.auditoria.borrado = false");
		//hb.orderBy("agencia.nombre", HQLBuilder.ORDER_ASC);
//		if ("contactoNombreApellido".equals(dto.getSort())){
//			String orden= HQLBuilder.ORDER_ASC;
//			if ("ASC".equals(dto.getDir())){
//				orden= HQLBuilder.ORDER_ASC;
//			} else{
//				orden = HQLBuilder.ORDER_DESC;
//			}
//			hb.orderBy("agencia.contactoNombre"+","+"agencia.contactoApe1"+","+"agencia.contatoApe2", orden);
//		}
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public List<RecobroAgencia> listaAgenciasByDespacho(Long idDespacho) {
		HQLBuilder hb = new HQLBuilder("select agencia from RecobroAgencia agencia");
		HQLBuilder.addFiltroIgualQue(hb, "despacho.id", idDespacho);
		hb.appendWhere("agencia.auditoria.borrado = false");
		
		return HibernateQueryUtils.list(this, hb);
	}

}
