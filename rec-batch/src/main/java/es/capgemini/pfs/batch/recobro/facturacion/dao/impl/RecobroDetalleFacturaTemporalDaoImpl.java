package es.capgemini.pfs.batch.recobro.facturacion.dao.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.ConnectionCallback;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.batch.recobro.facturacion.dao.RecobroDetalleFacturaTemporalDao;
import es.capgemini.pfs.batch.recobro.facturacion.model.RecobroDetalleFacturacionCorrectorTemporal;
import es.capgemini.pfs.batch.recobro.facturacion.model.RecobroDetalleFacturacionTemporal;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.expediente.model.Expediente;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDTipoRepartoSubcartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroTarifaCobro;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroItinerarioMetasVolantes;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model.RecobroPoliticaDeAcuerdos;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.EXTRecobroCobroPago;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacionSubcartera;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroModeloDeRanking;

/**
 * Implementaci�n del DAO de detalles de facturas temporales de recobro
 * @author Javier Ruiz
 *
 */
public class RecobroDetalleFacturaTemporalDaoImpl implements	RecobroDetalleFacturaTemporalDao {
	
	@Autowired
	private GenericABMDao genericDao;

	private DataSource dataSource;
	private String deleteAllQuery;
	private String coDeleteAllQuery;
	private String obtenerSubcarterasDetallesFactura;
	private String obteneDetallesFacturaPorSubcartera;
	private String insertarDetalleTemporalCorregido;
	private String transferirDetallesTemporalesCorregidos;
	private String insertarDetalleTemporalFactura;
	private String moveDetallesTemporalesSinCorrectoresQuery;
	private String procesaProcesoStoredProcedure;
	

	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	public void setDeleteAllQuery(String deleteAllQuery) {
		this.deleteAllQuery = deleteAllQuery;
	}
	
	public void setObtenerSubcarterasDetallesFactura(String obtenerSubcarterasDetallesFactura) {
		this.obtenerSubcarterasDetallesFactura = obtenerSubcarterasDetallesFactura;
	}

	public void setObteneDetallesFacturaPorSubcartera(String obteneDetallesFacturaPorSubcartera) {
		this.obteneDetallesFacturaPorSubcartera = obteneDetallesFacturaPorSubcartera;
	}

	public void setInsertarDetalleTemporalCorregido(String insertarDetalleTemporalCorregido) {
		this.insertarDetalleTemporalCorregido = insertarDetalleTemporalCorregido;
	}	
	
	public void setTransferirDetallesTemporalesCorregidos(String transferirDetallesTemporalesCorregidos) {
		this.transferirDetallesTemporalesCorregidos = transferirDetallesTemporalesCorregidos;
	}
	
	public void setInsertarDetalleTemporalFactura(String insertarDetalleTemporalFactura) {
		this.insertarDetalleTemporalFactura = insertarDetalleTemporalFactura;
	}

	public String getMoveDetallesTemporalesSinCorrectoresQuery() {
		return moveDetallesTemporalesSinCorrectoresQuery;
	}

	public void setMoveDetallesTemporalesSinCorrectoresQuery(String moveDetallesTemporalesSinCorrectoresQuery) {
		this.moveDetallesTemporalesSinCorrectoresQuery = moveDetallesTemporalesSinCorrectoresQuery;
	}

	public String getCoDeleteAllQuery() {
		return coDeleteAllQuery;
	}

	public void setCoDeleteAllQuery(String coDeleteAllQuery) {
		this.coDeleteAllQuery = coDeleteAllQuery;
	}
	
	public String getProcesaProcesoStoredProcedure() {
		return procesaProcesoStoredProcedure;
	}

	public void setProcesaProcesoStoredProcedure(
			String procesaProcesoStoredProcedure) {
		this.procesaProcesoStoredProcedure = procesaProcesoStoredProcedure;
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public void deleteAll() {
		JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
		jdbcTemplate.execute(deleteAllQuery);
	}
	
	@Override
	public void procesaProcesoFacturacion() {
		JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
		jdbcTemplate.execute(procesaProcesoStoredProcedure);
		
	}
	
	/**
	 * {@inheritDoc}
	 */	
	@Override
	public void deleteAllCo() {
		JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
		jdbcTemplate.execute(coDeleteAllQuery);
		
	}	

	/**
	 * {@inheritDoc}
	 */	
	@SuppressWarnings("unchecked")
	@Override
	public List<RecobroSubCartera> obtenerSubcarterasExistentesEnDetallesFacturaTemporalesSinCorregir() throws Throwable {
		JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
		return jdbcTemplate.query(obtenerSubcarterasDetallesFactura, new RecobroSubCarteraRowMapper());		
	}

	/**
	 * {@inheritDoc}
	 */	
	@SuppressWarnings("unchecked")
	@Override
	public List<RecobroDetalleFacturacionTemporal> obtenerDetallesTemporalesFacturacionPorSubcartera(RecobroSubCartera recobroSubCartera) throws Throwable {
		JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
		return jdbcTemplate.query(obteneDetallesFacturaPorSubcartera,new Object[]{ recobroSubCartera.getId() }, new RecobroDetalleFacturaTemporalRowMapper());
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public void insertarDetalleTemporalCorregidoFacturacion(RecobroDetalleFacturacionCorrectorTemporal recobroDetalleFacturacionCorrectorTemporal) throws Throwable {
		JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
		jdbcTemplate.update(insertarDetalleTemporalCorregido, 
				new Object[] {
					recobroDetalleFacturacionCorrectorTemporal.getProcesoFacturacionSubcartera().getId(),
					recobroDetalleFacturacionCorrectorTemporal.getCobroPago().getId(),
					recobroDetalleFacturacionCorrectorTemporal.getContrato().getId(),
					recobroDetalleFacturacionCorrectorTemporal.getExpediente().getId(),
					recobroDetalleFacturacionCorrectorTemporal.getSubCartera().getId(),
					recobroDetalleFacturacionCorrectorTemporal.getAgencia().getId(),
					recobroDetalleFacturacionCorrectorTemporal.getFechaCobro(),
					recobroDetalleFacturacionCorrectorTemporal.getPorcentaje(),
					recobroDetalleFacturacionCorrectorTemporal.getImporteAPagar(),
					recobroDetalleFacturacionCorrectorTemporal.getTarifaCobro().getId(),
					recobroDetalleFacturacionCorrectorTemporal.getImporteConceptoFacturable(),
					recobroDetalleFacturacionCorrectorTemporal.getImporteRealFacturable()
				});
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public void insertarDetalleTemporalFactura(RecobroDetalleFacturacionTemporal recobroDetalleFacturacionTemporal) throws Throwable {
		JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
		jdbcTemplate.update(insertarDetalleTemporalFactura,
				new Object[] {
					recobroDetalleFacturacionTemporal.getProcesoFacturacionSubcartera().getId(),
					recobroDetalleFacturacionTemporal.getCobroPago().getId(),
					recobroDetalleFacturacionTemporal.getContrato().getId(),
					recobroDetalleFacturacionTemporal.getExpediente().getId(),
					recobroDetalleFacturacionTemporal.getSubCartera().getId(),
					recobroDetalleFacturacionTemporal.getAgencia().getId(),
					recobroDetalleFacturacionTemporal.getFechaCobro(),
					recobroDetalleFacturacionTemporal.getPorcentaje(),
					recobroDetalleFacturacionTemporal.getImporteAPagar(),
					recobroDetalleFacturacionTemporal.getTarifaCobro().getId(),
					recobroDetalleFacturacionTemporal.getImporteConceptoFacturable(),
					recobroDetalleFacturacionTemporal.getImporteRealFacturable()
				});
	}
	
	/**
	 * {@inheritDoc}
	 */	
	@Override
	public void transferirDetallesTemporalesCorregidosFacturacionAProduccion()	throws Throwable {
		JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
		jdbcTemplate.execute(transferirDetallesTemporalesCorregidos);
	}
	
	/**
	 * M�todo privado para mapear las subcarteras de recobro
	 * @author Guillem
	 *
	 */
	private class RecobroSubCarteraRowMapper implements RowMapper{
		public Object mapRow(ResultSet rs, int arg1) throws SQLException {			
			RecobroSubCartera recobroSubCartera = new RecobroSubCartera();
			try{
				recobroSubCartera.setId(rs.getLong("RCF_SCA_ID"));	
				recobroSubCartera.setCarteraEsquema(genericDao.get(RecobroCarteraEsquema.class, 
						genericDao.createFilter(FilterType.EQUALS, "id", rs.getLong("RCF_ESC_ID")), 
						genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				recobroSubCartera.setNombre(rs.getString("RCF_SCA_NOMBRE"));
				recobroSubCartera.setParticion(rs.getInt("RCF_SCA_PARTICION"));
				recobroSubCartera.setTipoRepartoSubcartera(genericDao.get(RecobroDDTipoRepartoSubcartera.class, 
						genericDao.createFilter(FilterType.EQUALS, "id", rs.getLong("RCF_DD_TPR_ID")), 
						genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				recobroSubCartera.setItinerarioMetasVolantes(genericDao.get(RecobroItinerarioMetasVolantes.class,
						genericDao.createFilter(FilterType.EQUALS, "id", rs.getLong("RCF_ITV_ID")),
						genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				recobroSubCartera.setModeloFacturacion(genericDao.get(RecobroModeloFacturacion.class,
						genericDao.createFilter(FilterType.EQUALS, "id", rs.getLong("RCF_MFA_ID")),
						genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				recobroSubCartera.setPoliticaAcuerdos(genericDao.get(RecobroPoliticaDeAcuerdos.class, 
						genericDao.createFilter(FilterType.EQUALS, "id", rs.getLong("RCF_POA_ID")),
						genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				recobroSubCartera.setModeloDeRanking(genericDao.get(RecobroModeloDeRanking.class, 
						genericDao.createFilter(FilterType.EQUALS, "id", rs.getLong("RCF_MOR_ID")),
						genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));

				Auditoria auditoria = new Auditoria();
				auditoria.setUsuarioCrear(rs.getString("USUARIOCREAR"));
				auditoria.setFechaCrear(rs.getDate("FECHACREAR"));
				auditoria.setUsuarioModificar(rs.getString("USUARIOMODIFICAR"));
				auditoria.setFechaModificar(rs.getDate("FECHAMODIFICAR"));
				auditoria.setUsuarioBorrar(rs.getString("USUARIOBORRAR"));
				auditoria.setFechaBorrar(rs.getDate("FECHABORRAR"));
				auditoria.setBorrado(rs.getBoolean("BORRADO"));
				recobroSubCartera.setAuditoria(auditoria);
				recobroSubCartera.setVersion(rs.getInt("VERSION"));
			}catch(SQLException ex){
				throw ex;
			}catch(Throwable e){
				throw new SQLException(e.getMessage());
			}
			return recobroSubCartera;
		}
	}
	
	/**
	 * M�todo privado para mapear el DetalleFacturaTemporal
	 * @author javier
	 *
	 */
	private class RecobroDetalleFacturaTemporalRowMapper implements RowMapper {
		public Object mapRow(ResultSet rs, int arg1) throws SQLException {
			RecobroDetalleFacturacionTemporal recobroDetalleFacturacionTemporal = new RecobroDetalleFacturacionTemporal();
			try {
				recobroDetalleFacturacionTemporal.setProcesoFacturacionSubcartera(genericDao.get(RecobroProcesoFacturacionSubcartera.class, 
						genericDao.createFilter(FilterType.EQUALS, "id", rs.getLong("PFS_ID")), 
						genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				recobroDetalleFacturacionTemporal.setCobroPago(genericDao.get(EXTRecobroCobroPago.class,
						genericDao.createFilter(FilterType.EQUALS, "id", rs.getLong("CPA_ID")),
						genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				recobroDetalleFacturacionTemporal.setContrato(genericDao.get(EXTContrato.class, 
						genericDao.createFilter(FilterType.EQUALS, "id", rs.getLong("CNT_ID")),
						genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				recobroDetalleFacturacionTemporal.setExpediente(genericDao.get(Expediente.class, 
						genericDao.createFilter(FilterType.EQUALS, "id", rs.getLong("EXP_ID")),
						genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				recobroDetalleFacturacionTemporal.setSubCartera(genericDao.get(RecobroSubCartera.class, 
						genericDao.createFilter(FilterType.EQUALS, "id", rs.getLong("RCF_SCA_ID")),
						genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				recobroDetalleFacturacionTemporal.setAgencia(genericDao.get(RecobroAgencia.class, 
						genericDao.createFilter(FilterType.EQUALS, "id", rs.getLong("RCF_AGE_ID")),
						genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				recobroDetalleFacturacionTemporal.setFechaCobro(rs.getDate("RDF_FECHA_COBRO"));
				recobroDetalleFacturacionTemporal.setPorcentaje(rs.getFloat("RDF_PORCENTAJE"));
				recobroDetalleFacturacionTemporal.setImporteAPagar(rs.getDouble("RDF_IMPORTE_A_PAGAR"));
				recobroDetalleFacturacionTemporal.setTarifaCobro(genericDao.get(RecobroTarifaCobro.class, 
						genericDao.createFilter(FilterType.EQUALS, "id", rs.getLong("RCF_TCC_ID")),
						genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)));
				recobroDetalleFacturacionTemporal.setImporteConceptoFacturable(rs.getDouble("RDF_IMP_CONCEP_FACTU"));
				recobroDetalleFacturacionTemporal.setImporteRealFacturable(rs.getDouble("RDF_IMP_REAL_FACTU"));
				
			} catch(SQLException ex){
				throw ex;
			} catch(Throwable e){
				throw new SQLException(e.getMessage());
			}
			return recobroDetalleFacturacionTemporal;
		}
	}

	/**
	 * {@inheritDoc}
	 */	
	@Override
	public void moveDetallesTemporalesSinCorrectores(Long subCarteraId) throws Throwable {
		JdbcOperations jdbcTemplate = new JdbcTemplate(dataSource);
		jdbcTemplate.update(moveDetallesTemporalesSinCorrectoresQuery, new Object[] {subCarteraId}); 
	}

	
	
}
