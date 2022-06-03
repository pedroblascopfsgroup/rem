package es.pfsgroup.plugin.rem.accionesCaixa;

import net.sf.json.JSONObject;

import java.util.Iterator;

public class CaixaBcReplicationDataHolder {

    private Boolean replicateToBc;
    private Boolean esAccion;
    private String previousStateExpedienteBcCod;
    private String currentStateExpedienteBcCod;
    private Long idTarea;
    private Long numOferta;
    private Long numExpediente;


    public Boolean getReplicateToBc() {
        return replicateToBc;
    }

    public void setReplicateToBc(Boolean replicateToBc) {
        this.replicateToBc = replicateToBc;
    }

    public String getPreviousStateExpedienteBcCod() {
        return previousStateExpedienteBcCod;
    }

    public void setPreviousStateExpedienteBcCod(String previousStateExpedienteBcCod) {
        this.previousStateExpedienteBcCod = previousStateExpedienteBcCod;
    }

    public String getCurrentStateExpedienteBcCod() {
        return currentStateExpedienteBcCod;
    }

    public void setCurrentStateExpedienteBcCod(String currentStateExpedienteBcCod) {
        this.currentStateExpedienteBcCod = currentStateExpedienteBcCod;
    }

    public Long getIdTarea() {
        return idTarea;
    }

    public void setIdTarea(Long idTarea) {
        this.idTarea = idTarea;
    }

    public Long getNumOferta() {
        return numOferta;
    }

    public void setNumOferta(Long numOferta) {
        this.numOferta = numOferta;
    }

    public Long getNumExpediente() {
        return numExpediente;
    }

    public void setNumExpediente(Long numExpediente) {
        this.numExpediente = numExpediente;
    }
    public Boolean haschangedExpedienteBCState(){
        return currentStateExpedienteBcCod != null && !currentStateExpedienteBcCod.equals(previousStateExpedienteBcCod);
    }
    public void setNumOfrFromRequest(JSONObject jsonObject){
        if (jsonObject.containsKey("numOferta"))
        numOferta = Long.parseLong(jsonObject.get("numOferta").toString());
        else if (jsonObject.containsKey("dto") && jsonObject.getJSONArray("dto").getJSONObject(0).containsKey("numOferta")){
            numOferta = Long.parseLong(jsonObject.getJSONArray("dto").getJSONObject(0).get("numOferta").toString());
        }
    }

    public Boolean getEsAccion() {
        return esAccion;
    }

    public void setEsAccion(Boolean esAccion) {
        this.esAccion = esAccion;
    }


}
