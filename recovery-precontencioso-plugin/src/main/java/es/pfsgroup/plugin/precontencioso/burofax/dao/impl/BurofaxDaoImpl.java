package es.pfsgroup.plugin.precontencioso.burofax.dao.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.contrato.model.ContratoPersonaManual;
import es.capgemini.pfs.contrato.model.DDTipoIntervencion;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.persona.dto.DtoPersonaManual;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.persona.model.PersonaManual;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.impl.GenericABMDaoImpl;
import es.pfsgroup.plugin.precontencioso.burofax.dao.BurofaxDao;
import es.pfsgroup.plugin.precontencioso.burofax.dto.ContratosPCODto;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;

@Repository
public class BurofaxDaoImpl extends AbstractEntityDao<BurofaxPCO, Long> implements BurofaxDao {
	
	@Autowired
	private GenericABMDao genericDao;
	
	@SuppressWarnings("unchecked")
	@Override
	public Collection<? extends Persona> getPersonasConDireccion(String query) {
		StringBuilder hql = new StringBuilder();
		StringBuilder andHql = new StringBuilder();
		
		hql.append(" from Persona prcPer");
		andHql.append(" and prcPer.direcciones IS NOT EMPTY");

		hql.append(" where upper(concat(prcPer.docId, ' ', prcPer.nom50)) like '%"
				+ query.toUpperCase() + "%' "
				+ andHql);
		
		hql.append(" order by prcPer.docId, prcPer.nom50");

		Query q = getSession().createQuery(hql.toString());
		q.setMaxResults(20);

		return q.list();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Collection<DtoPersonaManual> getPersonasConContrato(String query) {
		return this.getPersonasConContrato(query, false);
	}
	
	@SuppressWarnings("unchecked")
	@Override	
	public Collection<DtoPersonaManual> getPersonasConContrato(String query, boolean addManuales) {
		StringBuilder hql = new StringBuilder();
		StringBuilder andHql = new StringBuilder();
		
		List<DtoPersonaManual> dtopersMasn = new ArrayList<DtoPersonaManual>();
		
		hql.append("select prcPer, 'false' as Manual ");
		hql.append(" from Persona prcPer");
		andHql.append(" and prcPer.contratosPersona IS NOT EMPTY");

		hql.append(" where upper(concat(prcPer.docId, ' ', prcPer.nom50)) like '%"
				+ query.toUpperCase() + "%' "
				+ andHql);
		
		hql.append(" order by prcPer.docId, prcPer.nom50");
		Query q = getSession().createQuery(hql.toString());
		q.setMaxResults(20);
		
		List<Object> personas = q.list();
		
		for(Object item : personas){
			Object[] partes = (Object[])item;
			Persona p = (Persona)partes[0];
			dtopersMasn.add(new DtoPersonaManual(p));
		}
		
		if (addManuales) {
			
			StringBuilder hqlM = new StringBuilder();
			
			hqlM.append("select prcPerM, 'true' as Manual ");
			hqlM.append(" from PersonaManual prcPerM ");
			hqlM.append(" where upper(concat(prcPerM.docId, ' ', prcPerM.nombre, ' ', prcPerM.apellido1, ' ', prcPerM.apellido2 )) like '%"
					+ query.toUpperCase() + "%' "
					+ " and prcPerM.contratosPersonaManual IS NOT EMPTY and prcPerM.codClienteEntidad IS NULL and prcPerM.propietario IS NULL");
			hqlM.append(" order by prcPerM.docId, prcPerM.nombre ");
			
			Query qM = getSession().createQuery(hqlM.toString());
			qM.setMaxResults(20);
			
			List<Object> personasManual = qM.list();
			for(Object item : personasManual){
				Object[] partes = (Object[])item;
				PersonaManual pm = (PersonaManual)partes[0];
				dtopersMasn.add(new DtoPersonaManual(pm));
			}
		}

		return dtopersMasn;
	}
	
	/*
	@SuppressWarnings("unchecked")
	private List<DtoPersonaManual> castearDtoPersonaManual(List<Object> resultados) {
		List<DtoPersonaManual> casteado = new ArrayList<DtoPersonaManual>();
		
		for (Object item : resultados) {
			Object[] partes = (Object[])item;
			
			Persona persona = new Persona();
			persona = (Persona)partes[0];
			
			DtoPersonaManual dto = new DtoPersonaManual();
			dto.setPersona(persona);	
			dto.setManual(Boolean.parseBoolean((String)partes[1]));
			
			casteado.add(dto);
		}
		
		return casteado;
	}*/
	
	@SuppressWarnings("unchecked")
	@Override
	public Collection<? extends Persona> getPersonas(String query) {
		StringBuilder hql = new StringBuilder();
		StringBuilder andHql = new StringBuilder();
		
		hql.append(" from Persona prcPer");

		hql.append(" where upper(concat(prcPer.docId, ' ', prcPer.nom50)) like '%"
				+ query.toUpperCase() + "%' "
				+ andHql);
		
		hql.append(" order by prcPer.docId, prcPer.nom50");

		Query q = getSession().createQuery(hql.toString());
		q.setMaxResults(20);

		return q.list();
	}
	
	public Long obtenerSecuenciaFicheroDocBurofax() {
		String sql = "SELECT S_BUR_FICHERO_DOC.NEXTVAL FROM DUAL ";
		return ((BigDecimal) getSession().createSQLQuery(sql).uniqueResult()).longValue();
	}

	@Override
	public List<ContratosPCODto> getContratosProcPersona(Long idProcedimientoPCO, Long idPersona, Boolean manual) {
		/*StringBuilder hql = new StringBuilder();
		
		hql.append("select cnt, tin ");
		hql.append(" from ProcedimientoPCO pco ");
		hql.append("	inner join pco.procedimiento as prc ");
		hql.append("		inner join prc.expedienteContratos as cex ");
		hql.append("			inner join cex.contrato as cnt ");
		if (!manual) {
			hql.append(" left join ContratoPersona.contrato as cpe ");
		} else {
			hql.append(" left join ContratoPersonaManual.contrato as cpe ");
		}
		if (!Checks.esNulo(idPersona)) {
			hql.append(" on cpe.id = " + idPersona);
		}
		hql.append("		left join cpe.tipoIntevencion tin ");
		hql.append(" where pco.id = " + idProcedimientoPCO);

		Query q = getSession().createQuery(hql.toString());

		List<Object> contratosPersona = q.list();
		
		return castearContratosPCODto(resultados);*/
		
		boolean bManual = false;
		if (!Checks.esNulo(manual)) {
			bManual = manual.booleanValue();
		}
		
		String sql =" SELECT CNT.CNT_ID";
		if (!Checks.esNulo(idPersona)) {
			sql +=", TIN.DD_TIN_ID ";
		} else {
			sql +=", NULL AS DD_TIN_ID ";
		}
		
		if(!bManual && !Checks.esNulo(idPersona)){
			sql +=", CPE.NO_ES_MANUAL AS NO_ES_MANUAL ";
			sql +=", CPE.ES_MANUAL AS RELMAN ";
		}else{
			sql +=", NULL AS NO_ES_MANUAL ";
			if(!Checks.esNulo(idPersona)){
				sql +=", CPE.CNT_ID AS RELMAN";
			}else{
				sql +=", NULL AS RELMAN ";
			}
		}
		
		sql += " FROM CNT_CONTRATOS CNT " +
						" INNER JOIN CEX_CONTRATOS_EXPEDIENTE CEX ON CEX.CNT_ID = CNT.CNT_ID " +
							" INNER JOIN PRC_CEX PRCEX ON PRCEX.CEX_ID = CEX.CEX_ID " +
								" INNER JOIN PRC_PROCEDIMIENTOS PRC ON PRC.PRC_ID = PRCEX.PRC_ID " +
									" INNER JOIN PCO_PRC_PROCEDIMIENTOS PCO ON PCO.PRC_ID = PRC.PRC_ID AND PCO.PCO_PRC_ID = " + idProcedimientoPCO;
		if (!Checks.esNulo(idPersona)) {
			if (!bManual) {
				sql += " LEFT JOIN (SELECT CNT_ID, DD_TIN_ID, CPE_ID AS CPE_ID, 1 AS NO_ES_MANUAL, NULL AS ES_MANUAL FROM CPE_CONTRATOS_PERSONAS  WHERE PER_ID = "+idPersona+" AND BORRADO = 0 "
								+ "UNION SELECT CNT_ID, DD_TIN_ID, CPM_ID AS CPE_ID, NULL AS NO_ES_MANUAL, 1 AS ES_MANUAL FROM CPM_CONTRATOS_PERSONAS_MAN WHERE PEM_ID = ( SELECT PEM_ID FROM PER_PERSONAS PERS INNER JOIN PEM_PERSONAS_MANUALES PEMS ON PEMS.DD_PRO_ID = PERS.DD_PRO_ID AND PEMS.PER_COD_CLIENTE_ENTIDAD = PERS.PER_COD_CLIENTE_ENTIDAD WHERE PER_ID = "+idPersona+") AND BORRADO = 0 ) CPE "
					+ "ON CPE.CNT_ID = CNT.CNT_ID";
			} else {
				sql += " LEFT JOIN CPM_CONTRATOS_PERSONAS_MAN CPE ON CPE.CNT_ID = CNT.CNT_ID AND CPE.PEM_ID = " + idPersona +" AND CPE.BORRADO = 0";
			}
			sql += " LEFT JOIN DD_TIN_TIPO_INTERVENCION TIN ON TIN.DD_TIN_ID = CPE.DD_TIN_ID";
		}
		
		
		return castearContratosPCODto(getSession().createSQLQuery(sql).list());
		
	}
	
	@SuppressWarnings("unchecked")
	private List<ContratosPCODto> castearContratosPCODto(List<Object> resultados) {
		List<ContratosPCODto> casteado = new ArrayList<ContratosPCODto>();
		
		for (Object item : resultados) {
			Object[] partes = (Object[])item;
			
			ContratosPCODto dto = new ContratosPCODto();
			if (partes[0]!=null) {
				Long cntId = Long.parseLong(partes[0].toString());
				dto.setContrato(genericDao.get(Contrato.class, genericDao.createFilter(FilterType.EQUALS, "id",  cntId)));
			}
			
			if (partes[1]!=null) {
				Long ddTinId = Long.parseLong(partes[1].toString());
				dto.setTipoIntervencion(genericDao.get(DDTipoIntervencion.class, genericDao.createFilter(FilterType.EQUALS, "id", ddTinId)));
			}
			
			if(partes[2]!=null){
				dto.setTieneRelacionContratoPersona(true);
			}
			
			if(partes[3]!=null){
				dto.setTieneRelacionContratoPersonaManual(true);
			}
			
			casteado.add(dto);
		}
		
		return casteado;
	}	
	
}
