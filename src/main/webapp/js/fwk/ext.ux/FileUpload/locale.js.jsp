<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
if(Ext.ux.FileUploader){
    Ext.apply(Ext.ux.FileUploader.prototype, {
        jsonErrorText: '<s:message code="devon.fileupload.badJSON" text="**No se puede decodificar objeto JSON" />',
        unknownErrorText: '<s:message code="devon.fileupload.errorDesconocido" text="**Error desconocido" />'
    });
}

if(Ext.ux.UploadPanel){
    Ext.apply(Ext.ux.UploadPanel.prototype, {
        addText:'<s:message code="devon.fileupload.agregar" text="**Agregar" />',
        clickRemoveText:'<s:message code="devon.fileupload.eliminar" text="**Clic para eliminar" />',
        clickStopText:'<s:message code="devon.fileupload.detener" text="**Clic para detener" />',
        emptyText:'<s:message code="devon.fileupload.nohay" text="**No hay archivos" />',
        errorText:'<s:message code="devon.fileupload.error" text="**Error" />',
        fileQueuedText:'<s:message code="devon.fileupload.cola" text="**El archivo <b>{0}</b> esta en cola para ser subido" />',
        fileDoneText:'<s:message code="devon.fileupload.ok" text="**El archivo <b>{0}</b> ha subido exitosamente" />',
        fileFailedText:'<s:message code="devon.fileupload.ko" text="**El archivo <b>{0}</b> tuvo errores al subir" />',
        fileStoppedText:'<s:message code="devon.fileupload.detenido" text="**El archivo <b>{0}</b> fue detenido por el usuario" />',
        fileUploadingText:'<s:message code="devon.fileupload.subiendo" text="**Subiendo Archivo <b>{0}</b>" />',
        removeAllText:'<s:message code="devon.fileupload.eliminarTodo" text="**Eliminar todo" />',
        removeText:'<s:message code="devon.fileupload.eliminarText" text="**Eliminar" />',
        stopAllText:'<s:message code="devon.fileupload.detenerText" text="**Detener todo" />',
        uploadText:'<s:message code="devon.fileupload.subir" text="**Subir" />'
    });
}


// eof
