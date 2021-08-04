package es.pfsgroup.plugin.rem.restclient.caixabc;

import java.io.Serializable;

public class ReplicacionClientesResponse implements Serializable {
        private Boolean success;
        private String errorDesc;
        private String missingFields;

        public Boolean getSuccess() {
            return this.success;
        }

        public String getErrorDesc() {
            return this.errorDesc;
        }

        public String getMissingFields() {
            return this.missingFields;
        }

        public void setSuccess(Boolean success) {
            this.success = success;
        }

        public void setErrorDesc(String errorDesc) {
            this.errorDesc = errorDesc;
        }

        public void setMissingFields(String missingFields) {
            this.missingFields = missingFields;
        }
    }

