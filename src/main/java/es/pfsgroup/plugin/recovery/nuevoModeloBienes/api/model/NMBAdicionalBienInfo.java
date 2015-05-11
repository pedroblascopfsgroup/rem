package es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model;

import java.util.Date;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.DDTipoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoInmueble;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoProdBancario;

/**
 * Datos a considerar de los datos adicionales
 * @author Carlos
 *
 */
public interface NMBAdicionalBienInfo {
	
	Long getId();
	
	NMBBienInfo getBien();
	
	String getMatricula();

	String getBastidor();

	String getNomEmpresa();

	String getCifEmpresa();

	String getCodIAE();

	String getDesIAE();

	DDTipoProdBancario getTipoProdBancario();

	DDTipoInmueble getTipoInmueble();

	Float getValoracion();

	String getEntidad();

	String getNumCuenta();

	String getModelo();

	String getMarca();

	Date getFechaMatricula();
	
	/**
	 * Auditoria
	 */
	Auditoria getAuditoria();
}
