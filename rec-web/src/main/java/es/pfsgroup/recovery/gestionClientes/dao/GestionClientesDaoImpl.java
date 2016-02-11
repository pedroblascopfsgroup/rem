package es.pfsgroup.recovery.gestionClientes.dao;

import java.math.BigDecimal;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;

@Repository
public class GestionClientesDaoImpl extends AbstractEntityDao<Persona, Long> implements GestionClientesDao {

	@Override
	public Long obtenerCantidadDeVencidosUsuario(String codigoGestion, Usuario usuarioLogado) {
		
		Set<String> codigoZonas = usuarioLogado.getCodigoZonas();
		Set<Long> perfiles = obtenIdPerfiles(usuarioLogado.getPerfiles());
		
		
		StringBuilder sql = new StringBuilder("SELECT count(distinct v.per_id) as totalCount from V_CVE_CLIENTES_VENCIDOS_USU v");
		sql.append(" where V.DD_TIT_CODIGO = '").append(codigoGestion.replaceAll("[^\\w]", "")).append("'");
		
		//Inicio filtro por perfiles
		if (perfiles != null){
			int count = 0;
			sql.append(" and V.PEF_ID_GESTOR in (");
			for (Long p : perfiles){
				count ++;
				if (count > 1){
					sql.append(", ");
				}
				sql.append(p.toString());
			}
			sql.append(")");
		}
		// Fin Filtro por perfiles
		
		// Inicio filtro por zonas
		if (codigoZonas != null){
			sql.append(" and (");
			int count = 0;
			for (String z : codigoZonas){
				count ++;
				if (count > 1){
					sql.append(" or ");
				}
				sql.append("V.ZON_COD like '").append(z).append("%'");
			}
			sql.append(")");
		}
		// Fin filtro por zonas
		
		BigDecimal cantidad = ((BigDecimal) getSession().createSQLQuery(sql.toString())
				.uniqueResult());
		
		if (cantidad == null) {
			return 0L;
		}else{
			return cantidad.longValue();
		}
	}

	private Set<Long> obtenIdPerfiles(List<Perfil> perfiles) {
		HashSet<Long> set = new HashSet<Long>();
		if (perfiles != null){
			for (Perfil p : perfiles){
				set.add(p.getId());
			}
		}
		return set;
	}

}
