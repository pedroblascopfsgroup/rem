package es.pfsgroup.plugin.rem.gestor.dao.impl;

import java.math.BigDecimal;
import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.plugin.rem.gestor.dao.GestorExpedienteComercialDao;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GestorExpedienteComercial;

@Repository("GestorExpedienteComercialDao")
public class GestorExpedienteComercialDaoImpl extends AbstractEntityDao<GestorExpedienteComercial, Long> implements GestorExpedienteComercialDao {

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
	public Long getUsuarioGestorFormalizacion(Long idActivo){
		
		StringBuilder functionHQL = new StringBuilder("SELECT CALCULAR_USUARIO_GFORM(:ACT_ID) FROM DUAL");
		Query callFunctionSql = this.getSessionFactory().getCurrentSession().createSQLQuery(functionHQL.toString());
		callFunctionSql.setParameter("ACT_ID", idActivo);
		
		BigDecimal resultado = (BigDecimal) callFunctionSql.uniqueResult();
		if(!Checks.esNulo(resultado))
			return resultado.longValue();
		else return null;
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
