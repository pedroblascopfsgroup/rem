package es.pfsgroup.plugin.rem.gestor.dao.impl;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.dao.SessionFactoryFacade;
import es.pfsgroup.plugin.rem.gestor.dao.GestorExpedienteComercialDao;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GestorExpedienteComercial;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;

@Repository("GestorExpedienteComercialDao")
public class GestorExpedienteComercialDaoImpl extends AbstractEntityDao<GestorExpedienteComercial, Long> implements GestorExpedienteComercialDao {
	
	@Autowired
	private MSVRawSQLDao rawDao;

	@SuppressWarnings("unchecked")
	@Override
	public Usuario getUsuarioGestorBycodigoTipoYExpedienteComercial(String codigoTipoGestor, ExpedienteComercial expediente) {
		
		HQLBuilder hb = new HQLBuilder("select distinct(gec.usuario) from GestorExpedienteComercial gec");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gec.auditoria.borrado", false);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb,  "gec.expedienteComercial.id", expediente.getId());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gec.tipoGestor.codigo", codigoTipoGestor);
		
		Query query = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
		HQLBuilder.parametrizaQuery(query, hb);
		List<Usuario> listado = query.list();
		
		if(!Checks.estaVacio(listado))
			return listado.get(0);
		else
			return null;
	}
	
	@Override
	public Long getUsuarioGestorFormalizacionBasico(Long idActivo){
		
		StringBuilder functionHQL = new StringBuilder("SELECT CALCULAR_USUARIO_GFORM(:ACT_ID) FROM DUAL");
		Query callFunctionSql = this.getSessionFactory().getCurrentSession().createSQLQuery(functionHQL.toString());
		callFunctionSql.setParameter("ACT_ID", idActivo);
		
		BigDecimal resultado = (BigDecimal) callFunctionSql.uniqueResult();
		if(!Checks.esNulo(resultado))
			return resultado.longValue();
		else return null;
	}	
	
	@Override
	public Long getUsuarioGestorFormalizacion(Long idActivo, Long idOferta){		
		
		String procedureHQL = "BEGIN SP_CALCULAR_USUARIO_GFORM(:P_ACT_ID, :P_OFR_ID);  END;";
		Query callProcedureSql = this.getSessionFactory().getCurrentSession().createSQLQuery(procedureHQL);
		callProcedureSql.setParameter("P_ACT_ID", idActivo);
		callProcedureSql.setParameter("P_OFR_ID", idOferta);
		callProcedureSql.executeUpdate();
		
		String sql =  "SELECT USUARIO FROM TMP_ASIGNACION_USU_GFORM WHERE ACT_ID = :idActivo";
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("idActivo", idActivo);
		
		rawDao.addParams(params);

		String resultado = rawDao.getExecuteSQL(sql);
		Long id_usuario_gform = Long.valueOf(resultado);
		if(!Checks.esNulo(id_usuario_gform)) {
			return id_usuario_gform;
		} else {
			return null;		
		}		
	}
	
	@Override
	public Long getUsuarioGestoriaFormalizacion(Long idActivo){
		
		StringBuilder functionHQL = new StringBuilder("SELECT CALCULAR_USUARIO_GIAFORM(:ACT_ID) FROM DUAL");
		Query callFunctionSql = this.getSessionFactory().getCurrentSession().createSQLQuery(functionHQL.toString());
		callFunctionSql.setParameter("ACT_ID", idActivo);
		
		BigDecimal resultado = (BigDecimal) callFunctionSql.uniqueResult();
		if(!Checks.esNulo(resultado))
			return resultado.longValue();
		else return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String getUsuarioGestor(Long idActivo, String codigoTipoGestor) {
		
		HQLBuilder hb = new HQLBuilder("select distinct(ges.username) from VGestoresActivo ges");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb,  "ges.activoId", idActivo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ges.tipoGestorCodigo", codigoTipoGestor);
		
		Query query = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
		HQLBuilder.parametrizaQuery(query, hb);
		
		List<String> listado = query.list();
		
		if(!Checks.estaVacio(listado))
			return listado.get(0);
		else
			return null;
	}
}
