package es.capgemini.pfs.parametrizacion.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Modelo de la tabla de parametrizacion PEN_PARAM_ENTIDAD.
 * @author aesteban
 *
 */
@Entity
@Table(name = "PEN_PARAM_ENTIDAD", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class Parametrizacion implements Serializable, Auditable {

    /**
     * serial.
     */
    private static final long serialVersionUID = -6637787816506547324L;

    public static final String PORCENTAJE_TOLERANCIA_ACTIVO_LINEAS = "porcentajeToleranciaActivoLineas";
    public static final String PORCENTAJE_TOLERANCIA_ACTIVO_POSICION_VENCIDA = "porcentajeToleranciaActivoPosicionVencida";
    public static final String PORCENTAJE_TOLERANCIA_ACTIVO_POSICION_VIVA = "porcentajeToleranciaActivoPosicionViva";
    public static final String PORCENTAJE_TOLERANCIA_PASIVO_LINEAS = "porcentajeToleranciaPasivoLineas";
    public static final String PORCENTAJE_TOLERANCIA_PASIVO_POSICION_VENCIDA = "porcentajeToleranciaPasivoPosicionVencida";
    public static final String PORCENTAJE_TOLERANCIA_PASIVO_POSICION_VIVA = "porcentajeToleranciaPasivoPosicionViva";
    public static final String PORCENTAJE_DISMINUCION_MOVIMIENTOS = "porcentajeDisminucionMovimientos";
    public static final String LIMITE_CONTRATOS_ADICIONALES = "expediente.obtenerContratosAdicionales.limite";
    public static final String LIMITE_PERSONAS_ADICIONALES = "expediente.obtenerPersonasAdicionales.limite";
    public static final String RANGO_INTERVALOS = "scoring.rangoIntervalo";
    public static final String LIMITE_FICHERO_PERSONA = "fichero.persona.limite";
    public static final String LIMITE_FICHERO_CONTRATO = "fichero.contrato.limite";
    public static final String LIMITE_FICHERO_EXPEDIENTE = "fichero.expediente.limite";
    public static final String LIMITE_FICHERO_ASUNTO = "fichero.asunto.limite";
    public static final String LIMITE_EXPORT_EXCEL = "limiteExportExcel";
    public static final String LIMITE_EXPORT_EXCEL_BUSCADOR_ASUNTOS = "limiteExportExcelBuscadorAsuntos";
    public static final String LIMITE_EXPORT_EXCEL_BUSCADOR_SUBASTAS = "limiteExportExcelBuscadorSubastas";
    public static final String LIMITE_EXPORT_EXCEL_BIENES_SUBASTA_CDD = "limiteExportExcelBienesSubastaCDD";
    public static final String ANOTACIONES_EMAIL_FROM = "AnotacionesEmailFrom";
    public static final Object ANOTACIONES_MAIL_SMTP_USER = "AnotacionesMailSmtpUser";
    public static final Object ANOTACIONES_PWD_CORREO = "AnotacionesPwdCorreo";
    public static final String VISIBLE_BOTON_SOLICITAR_LIQUIDACION = "visibleBtnSolicitarLiquidacion";
    public static final String ADJUNTOS_DESCARGA_ZIP_EXTENSIONES = "adjuntosDescargaZipExtensiones";
    public static final String ADJUNTOS_DESCARGA_ZIP_NIVEL_COMPRESION = "adjuntosDescargaZipNivelCompresion";
    public static final String LIMITE_FICHERO_PERSONA_GESTOR_DOCUMENTAL = "fichero.persona.limite.gestorDoc";
    public static final String LIMITE_FICHERO_CONTRATO_GESTOR_DOCUMENTAL = "fichero.contrato.limite.gestorDoc";
    public static final String LIMITE_FICHERO_EXPEDIENTE_GESTOR_DOCUMENTAL = "fichero.expediente.limite.gestorDoc";
    public static final String LIMITE_FICHERO_ASUNTO_GESTOR_DOCUMENTAL = "fichero.asunto.limite.gestorDoc";
    public static final String LIMITE_EXPORT_EXCEL_BUSCADOR_BIENES = "limiteExportExcelBuscadorBienes";
    public static final String LIMITE_EXPORT_EXCEL_BUSCADOR_CLIENTES = "limiteExportExcelBuscadorClientes";
    public static final String LIMITE_EXPORT_EXCEL_BUSCADOR_CONTRATOS = "limiteExportExcelBuscadorContratos";
    public static final String LIMITE_EXPORT_EXCEL_BUSCADOR_PROCEDIMIENTOS = "limiteExportExcelBuscadorProcedimientos";
    public static final String LIMITE_EXPORT_EXCEL_BUSCADOR_EXPEDIENTES = "limiteExportExcelBuscadorExpedientes";
    public static final String LIMITE_EXPORT_EXCEL_BUSCADOR_TAREAS = "limiteExportExcelBuscadorTareas";

    @Id
    @Column(name = "PEN_ID")
    private Long id;

    @Column(name = "PEN_PARAM")
    private String nombre;

    @Column(name = "PEN_VALOR")
    private String valor;

    @Column(name = "PEN_DESCRIPCION")
    private String descripcion;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the nombre
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * @param nombre the nombre to set
     */
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    /**
     * @return the valor
     */
    public String getValor() {
        return valor;
    }

    /**
     * @param valor the valor to set
     */
    public void setValor(String valor) {
        this.valor = valor;
    }

    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }
}
