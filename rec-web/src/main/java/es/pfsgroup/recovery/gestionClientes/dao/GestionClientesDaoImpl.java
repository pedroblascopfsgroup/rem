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
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.gestionClientes.GestionClientesBusquedaDTO;
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
	public Page obtenerListaGestionClientes(String codigoGestion, Usuario usuarioLogado, GestionClientesBusquedaDTO busquedaDTO) {
		
		StringBuilder sql = new StringBuilder("SELECT DISTINCT p.per_id                         										   AS \"id\", ");
		  sql.append("tpe.dd_tpe_descripcion                                                                   AS \"descripcion\", ");
		  sql.append("p.per_nombre                                                                             AS \"nombre\", ");
		  sql.append("p.per_apellido1                                                                          AS \"apellido1\", ");
		  sql.append("p.per_apellido2                                                                          AS \"apellido2\", ");
		  sql.append("p.per_apellido1 || ' ' || p.per_apellido2                                                AS \"apellidos\", ");
		  sql.append("p.per_cod_cliente_entidad                                                                AS \"codClienteEntidad\", ");
		  sql.append("p.per_doc_id                                                                             AS \"docId\", ");
		  sql.append("p.per_telefono_1                                                                         AS \"telefono1\", ");
		  sql.append("scl.dd_scl_descripcion                                                                   AS \"descripcionSegmento\", ");
		  sql.append("sce.dd_sce_descripcion                                                                   AS \"descripcionSegmentoEntidad\", ");
		  sql.append("p.per_num_contratos                                                                      AS \"numContratos\", ");
		  sql.append("p.per_deuda_irregular                                                                    AS \"deudaIrregular\", ");
		  sql.append("p.per_riesgo_dir_danyado                                                                 AS \"riesgoDirectoDanyado\", ");
		  sql.append("efc.dd_efc_descripcion                                                                   AS \"descripcionEstadoFinanciero\", ");
		  sql.append("p.per_riesgo_autorizado                                                                  AS \"riesgoAutorizado\", ");
		  sql.append("p.per_riesgo_dispuesto                                                                   AS \"riesgoDispuesto\", ");
		  sql.append("FIRST_VALUE(dir.DIR_DOMICILIO) OVER (PARTITION BY p.per_id ORDER BY dir.dir_id ASC)      AS \"domicilio\", ");
		  sql.append("FIRST_VALUE(loc.DD_LOC_DESCRIPCION) OVER (PARTITION BY p.per_id ORDER BY dir.dir_id ASC) AS \"localidad\", ");
		  sql.append("ppf.situacion                                                                            AS \"situacion\", ");
		  sql.append("ppf.riesgo_total                                                                         AS \"riesgoTotal\", ");
		  sql.append("ppf.dias_vencido                                                                         AS \"diasVencidos\", ");
		  sql.append("ppf.riesgo_total_directo                                                                 AS \"riesgoTotalDirecto\", ");
		  sql.append("p.PER_FECHA_DATO                                                                         AS \"fechaDato\", ");
		  sql.append("ppf.DISPUESTO_VENCIDO                                                                    AS \"dispuestoVencido\", ");
		  sql.append("ppf.DISPUESTO_NO_VENCIDO                                                                 AS \"dispuestoNoVencido\", ");
		  sql.append("ppf.RELACION_EXP                                                                         AS \"relacionExpediente\", ");
		  sql.append("CASE ");
		  sql.append("  WHEN cli.cli_id IS NULL ");
		  sql.append("  THEN ");
		  sql.append("    (SELECT OFI.OFI_CODIGO FROM OFI_OFICINAS OFI WHERE p.ofi_id = ofi.ofi_id ");
		  sql.append("    ) ");
		  sql.append("  ELSE ");
		  sql.append("    (SELECT OFI.OFI_CODIGO FROM OFI_OFICINAS OFI WHERE cli.ofi_id = ofi.ofi_id ");
		  sql.append("    ) ");
		  sql.append("END AS \"codigoOficina\", ");
		  sql.append("CASE ");
		  sql.append("  WHEN cli.cli_id IS NULL ");
		  sql.append("  THEN ");
		  sql.append("    (SELECT OFI.OFI_NOMBRE FROM OFI_OFICINAS OFI WHERE p.ofi_id = ofi.ofi_id ");
		  sql.append("    ) ");
		  sql.append("  ELSE ");
		  sql.append("    (SELECT OFI.OFI_NOMBRE FROM OFI_OFICINAS OFI WHERE cli.ofi_id = ofi.ofi_id ");
		  sql.append("    ) ");
		  sql.append("END                      AS \"nombreOficina\", ");
		  sql.append("arq.ARQ_NOMBRE           AS \"nombreArquetipo\", ");
		  sql.append("tit.DD_TIT_DESCRIPCION   AS \"tipoItinerario\", ");
		  sql.append("p.PER_EXP_UMBRAL_FECHA   AS \"fechaUmbral\", ");
		  sql.append("p.PER_EXP_UMBRAL_IMPORTE AS \"importeUmbral\", ");
		  sql.append("p.PER_RIESGO             AS \"riesgoDirecto\", ");
		  sql.append("cli.CLI_FECHA_CREACION   AS \"fechaCreacion\", ");
		  sql.append("tit.DD_TIT_CODIGO        AS \"codigoItinerario\", ");
		  sql.append("(SELECT est.EST_PLAZO ");
		  sql.append("FROM EST_ESTADOS est, ");
		  sql.append("  ${master.schema}.DD_EST_ESTADOS_ITINERARIOS eei ");
		  sql.append("WHERE iti.iti_id      = est.iti_id ");
		  sql.append("AND est.DD_EST_ID     = eei.DD_EST_ID ");
		  sql.append("AND eei.DD_EST_CODIGO = 'CAR' ");
		  sql.append(") AS \"plazoCarencia\", ");
		  sql.append("(SELECT est.EST_PLAZO ");
		  sql.append("FROM EST_ESTADOS est, ");
		  sql.append("  ${master.schema}.DD_EST_ESTADOS_ITINERARIOS eei ");
		  sql.append("WHERE iti.iti_id      = est.iti_id ");
		  sql.append("AND est.DD_EST_ID     = eei.DD_EST_ID ");
		  sql.append("AND eei.DD_EST_CODIGO = 'GV' ");
		  sql.append(") AS \"plazoVencidos\" ");
		  sql.append("FROM v_cve_clientes_vencidos_usu v ");
		  sql.append("INNER JOIN per_personas p ");
		  sql.append("ON v.per_id = p.per_id ");
		  sql.append("LEFT JOIN dd_tpe_tipo_persona tpe ");
		  sql.append("ON p.dd_tpe_id = tpe.dd_tpe_id ");
		  sql.append("LEFT JOIN dd_scl_segto_cli scl ");
		  sql.append("ON p.dd_scl_id = scl.dd_scl_id ");
		  sql.append("LEFT JOIN dd_sce_segto_cli_entidad sce ");
		  sql.append("ON p.dd_sce_id = sce.dd_sce_id ");
		  sql.append("LEFT JOIN dd_efc_estado_finan_cnt efc ");
		  sql.append("ON efc.dd_efc_id = p.dd_efc_id ");
		  sql.append("LEFT JOIN dir_per dpe ");
		  sql.append("ON p.per_id = dpe.per_id ");
		  sql.append("LEFT JOIN DIR_DIRECCIONES dir ");
		  sql.append("ON dpe.dir_id = dir.dir_id ");
		  sql.append("LEFT JOIN ${master.schema}.dd_loc_localidad loc ");
		  sql.append("ON dir.dd_loc_id = loc.dd_loc_id ");
		  sql.append("LEFT JOIN V_PER_PERSONAS_FORMULAS ppf ");
		  sql.append("ON p.per_id = ppf.per_id ");
		  sql.append("LEFT JOIN CLI_CLIENTES cli ");
		  sql.append("ON p.per_id     = cli.per_id ");
		  sql.append("AND cli.borrado = 0 ");
		  sql.append("LEFT JOIN ARQ_ARQUETIPOS arq ");
		  sql.append("ON cli.arq_id = arq.arq_id ");
		  sql.append("LEFT JOIN ITI_ITINERARIOS iti ");
		  sql.append("ON arq.iti_id = iti.iti_id ");
		  sql.append("LEFT JOIN ${master.schema}.DD_TIT_TIPO_ITINERARIOS tit ");
		  sql.append("ON iti.DD_TIT_ID      = tit.DD_TIT_ID ");
		
		getFiltroClientes(sql, codigoGestion, usuarioLogado, busquedaDTO);

		return HibernateQueryUtils.pageSql(this, sql.toString(), GestionVencidosDTO.class, busquedaDTO);
	}
	
	private String getFiltroClientes(StringBuilder sql, String codigoGestion, Usuario usuarioLogado, GestionClientesBusquedaDTO busquedaDTO) {
		
		Set<String> codigoZonas = usuarioLogado.getCodigoZonas();
		Set<Long> perfiles = obtenIdPerfiles(usuarioLogado.getPerfiles());
		
		sql.append(" WHERE v.dd_tit_codigo = '");
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
		
		// Filtro por NIF
		if(!Checks.esNulo(busquedaDTO.getNif())) {
			sql.append(" AND lower(p.per_doc_id) LIKE '%" + busquedaDTO.getNif().toLowerCase() + "%' ");
		}
		
		// Filtro por nombre
		if(!Checks.esNulo(busquedaDTO.getNombre())) {
			sql.append(" AND lower(p.per_nombre) LIKE '%" + busquedaDTO.getNombre().toLowerCase() + "%' ");
		}
		
		// Filtro por apellidos
		if(!Checks.esNulo(busquedaDTO.getApellidos())) {
			sql.append(" AND lower(p.per_apellido1 || ' ' || p.per_apellido2)  LIKE '%" + busquedaDTO.getApellidos().toLowerCase() + "%' ");
		}
		
		// Filtro por código de contrato
		if(!Checks.esNulo(busquedaDTO.getCodigoContrato())) {
			sql.append(" AND EXISTS (SELECT 1 FROM CPE_CONTRATOS_PERSONAS cpe, CNT_CONTRATOS cnt WHERE p.per_id = cpe.per_id AND cpe.cnt_id = cnt.cnt_id AND lower(cnt.cnt_contrato) LIKE '%" + busquedaDTO.getCodigoContrato().toLowerCase() + "%') ");
		}
		
		// Ordenación
		if(!Checks.esNulo(busquedaDTO.getSort())) {
			sql.insert(0, "SELECT * FROM (");
			sql.append(")");
			sql.append("ORDER BY \"" + busquedaDTO.getSort() + "\" " + busquedaDTO.getDir());
		}
		
		return sql.toString();
	}
}
