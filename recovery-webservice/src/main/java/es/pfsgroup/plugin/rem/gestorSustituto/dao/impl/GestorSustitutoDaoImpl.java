package es.pfsgroup.plugin.rem.gestorSustituto.dao.impl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.gestorEntidad.dao.GestorEntidadDao;
import es.pfsgroup.plugin.rem.gestorSustituto.dao.GestorSustitutoDao;
import es.pfsgroup.plugin.rem.model.DtoGestoresSustitutosFilter;
import es.pfsgroup.plugin.rem.model.GestorSustituto;

@Repository("GestorSustitutoDao")
public class GestorSustitutoDaoImpl extends AbstractEntityDao<GestorSustituto, Long> implements GestorSustitutoDao {
	
	@Autowired
	GestorEntidadDao gestorEntidadDao;
	
	@Autowired
	private UsuarioManager usuarioManager;
	@Override
	public Page getPageGestoresSustitutos(DtoGestoresSustitutosFilter dto) {
		HQLBuilder hql = new HQLBuilder("select gs from VBusquedaGestoresSustitutos gs");		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "gs.usernameOrigen", dto.getUsernameOrigen());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "gs.usernameSustituto", dto.getUsernameSustituto());
   		return HibernateQueryUtils.page(this, hql, dto);
	}
	
	@SuppressWarnings("deprecation")
	@Override
	public String accionGestoresSustitutos(DtoGestoresSustitutosFilter dto) {
		SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
		String result = null;		
		Connection con = this.getHibernateTemplate().getSessionFactory().getCurrentSession().connection();		
		CallableStatement cs = null;
		try {
			cs = con.prepareCall("{CALL SP_GESTOR_SUSTITUTO_WEB(?, ?, ?, ?, ?, ?, ?)}");
		
			cs.setString(1, dto.getAccion());
			cs.setString(2, dto.getUsernameOrigen());
			cs.setString(3, dto.getUsernameSustituto());
			cs.setString(4, format.format(dto.getFechaInicio()));
			cs.setString(5, format.format(dto.getFechaFin()));
			cs.setString(6, usuarioManager.getUsuarioLogado().getUsername());
			cs.registerOutParameter(7, java.sql.Types.VARCHAR);
			cs.execute();
			
			result = cs.getString(7);
		} catch (SQLException e) {
			logger.error("Error en GestorSustitutoDaoImpl", e);
		} finally {
			try {
				if(cs != null) {
					cs.close();
				}				
				con.close();
					
			} catch (SQLException e) {
				logger.error("Error en GestorSustitutoDaoImpl", e);
			}
		}
		return result;
	}

}
