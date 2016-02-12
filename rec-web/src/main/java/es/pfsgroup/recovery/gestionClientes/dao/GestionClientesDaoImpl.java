package es.pfsgroup.recovery.gestionClientes.dao;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;

import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.gestionClientes.GestionVencidosDTO;

@Repository
public class GestionClientesDaoImpl extends AbstractEntityDao<Persona, Long> implements GestionClientesDao {

	@Resource
	private Properties appProperties;

	@SuppressWarnings({ "unchecked", "rawtypes" })
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

	@Override
	public Page obtenerListaVencidos(String codigoGestion, Usuario usuarioLogado) {
		
		StringBuilder sql = new StringBuilder("SELECT p.per_id AS \"id\", tpe.dd_tpe_descripcion AS \"descripcion\", p.per_nombre AS \"nombre\", "
				+ "p.per_apellido1 AS \"apellido1\", p.per_apellido2 AS \"apellido2\", p.per_cod_cliente_entidad AS \"codClienteEntidad\", p.per_doc_id AS \"docId\", "
				+ "p.per_telefono_1 AS \"telefono1\", scl.dd_scl_descripcion AS \"descripcionSegmento\", sce.dd_sce_descripcion AS \"descripcionSegmentoEntidad\", "
				+ "p.per_num_contratos AS \"numContratos\", p.per_deuda_irregular AS \"deudaIrregular\", p.per_riesgo_dir_danyado AS \"riesgoDirectoDanyado\", "
				+ "efc.dd_efc_descripcion AS \"descripcionEstadoFinanciero\", p.per_riesgo_autorizado AS \"riesgoAutorizado\", p.per_riesgo_dispuesto AS \"riesgoDispuesto\""
				+ " FROM v_cve_clientes_vencidos_usu v INNER JOIN per_personas p ON v.per_id = p.per_id LEFT JOIN dd_tpe_tipo_persona tpe ON p.dd_tpe_id = tpe.dd_tpe_id"
				+ " LEFT JOIN dd_scl_segto_cli scl ON p.dd_scl_id = scl.dd_scl_id LEFT JOIN dd_sce_segto_cli_entidad sce ON p.dd_sce_id = sce.dd_sce_id "
				+ " LEFT JOIN dd_efc_estado_finan_cnt efc ON efc.dd_efc_id = p.dd_efc_id");
		sql.append(getFiltroVencidos(codigoGestion, usuarioLogado));

		return HibernateQueryUtils.pageSql(this, sql.toString(), GestionVencidosDTO.class);
	}
	
	private String getFiltroVencidos(String codigoGestion, Usuario usuarioLogado) {
		
		Set<String> codigoZonas = usuarioLogado.getCodigoZonas();
		Set<Long> perfiles = obtenIdPerfiles(usuarioLogado.getPerfiles());
		
		StringBuilder sql = new StringBuilder(" WHERE v.dd_tit_codigo = '");
		sql.append(codigoGestion.replaceAll("[^\\w]", "")).append("'");
		
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
		
		return sql.toString();
	}

	@Override
	public Long obtenerCantidadDeVencidosUsuario(String codigoGestion,
			Usuario usuarioLogado) {
		// TODO Auto-generated method stub
		return null;
	}

}
