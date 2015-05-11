package es.pfsgroup.recovery.panelcontrol.letrados.vistas.expedienteTareaResumen.model;

import java.io.Serializable;
import java.lang.reflect.Method;
import java.util.Map;
import java.util.StringTokenizer;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;


@Entity
@Table(name = "V_PC_COT_EXP_TAR_RESUMEN", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class PCExpedienteTareaResumen implements Serializable{
	/**
	 * Vista materializada resumen de PCExpedienteTarea
	 */
	private static final long serialVersionUID = -3730871494367533328L;
	
	@Column(name="USU_USERNAME")
	@Id
	private String id;
	
	@Column(name="ZON_COD")
	private String codigo;
	
	@Column(name="LETRADO")
	private String letrado;
	
	@Column(name="EXPEDIENTE")
	private Long expediente;
	
	@Column(name="SALDO_EXPEDIENTE")
	private Float saldo;
	
	@Column(name="NUM_TV")
	private Long num_tv;
	
	@Column(name="NUM_PM")
	private Long num_pm;
	
	@Column(name="NUM_PS")
	private Long num_ps;
	
	@Column(name="NUM_PH")
	private Long num_ph;
	
	@Column(name="NUM_PMM")
	private Long num_pmm;
	
	@Column(name="NUM_PA")
	private Long num_pa;

	@Column(name="NUM_FH")
	private Long num_fh;
	
	@Column(name="NUM_FS")
	private Long num_fs;
	
	@Column(name="NUM_FM")
	private Long num_fm;
	
	@Column(name="NUM_FA")
	private Long num_fa;
	
	@Column(name="NUM_TF")
	private Long num_tf;
	
	@Column(name="NUM_VS")
	private Long num_vs;
	
	@Column(name="NUM_V1M")
	private Long num_v1m;
	
	@Column(name="NUM_V2M")
	private Long num_v2m;
	
	@Column(name="NUM_V3M")
	private Long num_v3m;
	
	@Column(name="NUM_V4M")
	private Long num_v4m;
	
	@Column(name="NUM_V5M")
	private Long num_v5m;
	
	@Column(name="NUM_V6M")
	private Long num_v6m;
	
	@Column(name="NUM_VM6M")
	private Long num_vm6m;
	
	@Column(name="NUM_P2M")
	private Long num_p2m;
	
	@Column(name="NUM_P3M")
	private Long num_p3m;
	
	@Column(name="NUM_P4M")
	private Long num_p4m;
	
	@Column(name="NUM_P5M")
	private Long num_p5m;
	
	@Column(name="NUM_PM6")
	private Long num_p6m;
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getLetrado() {
		return letrado;
	}

	public void setLetrado(String letrado) {
		this.letrado = letrado;
	}

	public Long getExpediente() {
		return expediente;
	}

	public void setExpediente(Long expediente) {
		this.expediente = expediente;
	}

	public Float getSaldo() {
		return saldo;
	}

	public void setSaldo(Float saldo) {
		this.saldo = saldo;
	}

	public Long getNum_tv() {
		return num_tv;
	}

	public void setNum_tv(Long numTv) {
		num_tv = numTv;
	}

	public Long getNum_pm() {
		return num_pm;
	}

	public void setNum_pm(Long numPm) {
		num_pm = numPm;
	}

	public Long getNum_ps() {
		return num_ps;
	}

	public void setNum_ps(Long numPs) {
		num_ps = numPs;
	}

	public Long getNum_ph() {
		return num_ph;
	}

	public void setNum_ph(Long numPh) {
		num_ph = numPh;
	}

	public Long getNum_pmm() {
		return num_pmm;
	}

	public void setNum_pmm(Long numPmm) {
		num_pmm = numPmm;
	}

	public Long getNum_pa() {
		return num_pa;
	}

	public void setNum_pa(Long numPa) {
		num_pa = numPa;
	}

	public Long getNum_fh() {
		return num_fh;
	}

	public void setNum_fh(Long numFh) {
		num_fh = numFh;
	}

	public Long getNum_fs() {
		return num_fs;
	}

	public void setNum_fs(Long numFs) {
		num_fs = numFs;
	}

	public Long getNum_fm() {
		return num_fm;
	}

	public void setNum_fm(Long numFm) {
		num_fm = numFm;
	}

	public Long getNum_fa() {
		return num_fa;
	}

	public void setNum_fa(Long numFa) {
		num_fa = numFa;
	}

	public Long getNum_tf() {
		return num_tf;
	}

	public void setNum_tf(Long numTf) {
		num_tf = numTf;
	}

	public Long getNum_v1m() {
		return num_v1m;
	}

	public void setNum_v1m(Long numV1m) {
		num_v1m = numV1m;
	}

	public Long getNum_v2m() {
		return num_v2m;
	}

	public void setNum_v2m(Long numV2m) {
		num_v2m = numV2m;
	}

	public Long getNum_v3m() {
		return num_v3m;
	}

	public void setNum_v3m(Long numV3m) {
		num_v3m = numV3m;
	}

	public Long getNum_v4m() {
		return num_v4m;
	}

	public void setNum_v4m(Long numV4m) {
		num_v4m = numV4m;
	}

	public Long getNum_v5m() {
		return num_v5m;
	}

	public void setNum_v5m(Long numV5m) {
		num_v5m = numV5m;
	}

	public Long getNum_v6m() {
		return num_v6m;
	}

	public void setNum_v6m(Long numV6m) {
		num_v6m = numV6m;
	}

	public Long getNum_vm6m() {
		return num_vm6m;
	}

	public void setNum_vm6m(Long numVm6m) {
		num_vm6m = numVm6m;
	}

	public Long getNum_p2m() {
		return num_p2m;
	}

	public void setNum_p2m(Long numP2m) {
		num_p2m = numP2m;
	}

	public Long getNum_p3m() {
		return num_p3m;
	}

	public void setNum_p3m(Long numP3m) {
		num_p3m = numP3m;
	}

	public Long getNum_p4m() {
		return num_p4m;
	}

	public void setNum_p4m(Long numP4m) {
		num_p4m = numP4m;
	}

	public Long getNum_p5m() {
		return num_p5m;
	}

	public void setNum_p5m(Long numP5m) {
		num_p5m = numP5m;
	}

	public Long getNum_p6m() {
		return num_p6m;
	}

	public void setNum_p6m(Long numP6m) {
		num_p6m = numP6m;
	}

	public void setNum_vs(Long num_vs) {
		this.num_vs = num_vs;
	}

	public Long getNum_vs() {
		return num_vs;
	}
	
	
	
}
