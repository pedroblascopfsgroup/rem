package es.pfsgroup.recovery.geninformes.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.geninformes.dao.GENINFInfoAuxiliarInformeDao;
import es.pfsgroup.recovery.geninformes.model.GENINFInforme;

@Repository("GENINFInfoAuxiliarInformeDao")
public class GENINFInfoAuxiliarInformeDaoImpl extends AbstractEntityDao<GENINFInforme, Long> implements GENINFInfoAuxiliarInformeDao {

	@Override
	public String buscaJuzgadoAnterior(Long id) {
		String result="";
		String sql = "select juz.DD_JUZ_DESCRIPCION from "+
					"mej_irg_info_registro info join " +
					"(select max(irg.IRG_ID) id_reg , reg.trg_ein_id from mej_reg_registro reg " +
					"join mej_irg_info_registro irg on irg.REG_ID=reg.REG_ID and irg.IRG_CLAVE='juzOld' group by reg.TRG_EIN_ID) " +
					"aux on aux.id_reg=info.IRG_ID " +
					"join dd_juz_juzgados_plaza juz on to_char(juz.DD_JUZ_ID)=info.IRG_VALOR " +
					"join dd_pla_plazas pla on pla.DD_PLA_ID=juz.DD_PLA_ID " +
					"where aux.trg_ein_id="+ id ;
		Object resultado = getSession().createSQLQuery(sql).uniqueResult();
		if (!Checks.esNulo(resultado)){
			result=resultado.toString();
		}
		return result;
	}

	@Override
	public String buscaPlazaAnterior(Long id) {
		String result="";
		String sql = "select pla.DD_PLA_DESCRIPCION from "+
				"mej_irg_info_registro info join " +
				"(select max(irg.IRG_ID) id_reg , reg.trg_ein_id from mej_reg_registro reg " +
				"join mej_irg_info_registro irg on irg.REG_ID=reg.REG_ID and irg.IRG_CLAVE='juzOld' group by reg.TRG_EIN_ID) " +
				"aux on aux.id_reg=info.IRG_ID " +
				"join dd_juz_juzgados_plaza juz on to_char(juz.DD_JUZ_ID)=info.IRG_VALOR " +
				"join dd_pla_plazas pla on pla.DD_PLA_ID=juz.DD_PLA_ID " +
				"where aux.trg_ein_id="+ id ;
		Object resultado = getSession().createSQLQuery(sql).uniqueResult();
		if (!Checks.esNulo(resultado)){
			result=resultado.toString();
		}
		return result;
	}
	
}
