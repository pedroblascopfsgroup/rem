package es.pfsgroup.recovery.gestionClientes.dao;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;

import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;

@Repository
public class GestionClientesDaoImpl extends AbstractEntityDao<Persona, Long> implements GestionClientesDao {

	@Resource
	private Properties appProperties;

	@Override
	public List<Map> obtenerCantidadDeVencidosUsuario(Usuario usuarioLogado) {

		Set<String> codigoZonas = usuarioLogado.getCodigoZonas();
		Set<Long> perfiles = obtenIdPerfiles(usuarioLogado.getPerfiles());

		StringBuilder sql = new StringBuilder("WITH CODIGOS AS (");
		sql.append("SELECT 'REC' AS COD, '1' AS COD_STA FROM DUAL");
		sql.append(" UNION ALL SELECT 'SIS', '98' FROM DUAL");
		sql.append(" UNION ALL SELECT 'SIN', '99' FROM DUAL");
		sql.append(")");
		sql.append("SELECT C.COD AS ").append(COLUM_CODIGO);
		sql.append(", C.COD_STA AS ").append(COLUMN_STA_CODIGO);
		sql.append(", STA.DD_STA_DESCRIPCION AS ").append(COLUMN_STA_DESCRIPCION);
		sql.append(", COUNT(DISTINCT V.PER_ID) AS ").append(COLUMN_TOTAL_COUNT);
		sql.append(" FROM CODIGOS C");
		sql.append(" JOIN  V_CVE_CLIENTES_VENCIDOS_USU v ON C.COD = V.DD_TIT_CODIGO");
		sql.append(" JOIN ${master.schema}.DD_STA_SUBTIPO_TAREA_BASE STA ON C.COD_STA = STA.DD_STA_CODIGO");

		String whereClause = " WHERE ";
		// Inicio filtro por perfiles
		if (perfiles != null) {
			int count = 0;
			sql.append(whereClause);
			sql.append("V.PEF_ID_GESTOR IN (");
			for (Long p : perfiles) {
				count++;
				if (count > 1) {
					sql.append(", ");
				}
				sql.append(p.toString());
			}
			sql.append(")");
			whereClause = " AND ";
		}
		// Fin Filtro por perfiles

		// Inicio filtro por zonas
		if (codigoZonas != null) {
			sql.append(whereClause);
			sql.append("(");
			int count = 0;
			for (String z : codigoZonas) {
				count++;
				if (count > 1) {
					sql.append(" or ");
				}
				sql.append("V.ZON_COD like '").append(z).append("%'");
			}
			sql.append(")");
		}
		sql.append(" GROUP BY C.COD, C.COD_STA, STA.DD_STA_DESCRIPCION");
		// Fin filtro por zonas

		return getSession().createSQLQuery(replaceSchema(sql.toString()))
				.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}

	private String replaceSchema(String string) {
		String masterSchema = appProperties.getProperty("master.schema");
		if ((string != null) && (masterSchema != null)) {
			return string.replaceAll("\\$\\{master\\.schema\\}", masterSchema);
		} else {
			return null;
		}
	}

	private Set<Long> obtenIdPerfiles(List<Perfil> perfiles) {
		HashSet<Long> set = new HashSet<Long>();
		if (perfiles != null) {
			for (Perfil p : perfiles) {
				set.add(p.getId());
			}
		}
		return set;
	}

}
