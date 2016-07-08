Ext.define('HreRem.view.activos.comercial.solicitudes.SolicitudFormController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.solicitudform',
    	
        
        onSaveClick: function(button) {
        	
        	var me = this,
        	solicitudDetalle = me.lookupReference("solicitudDetalle"),
        	form = me.lookupReference("formSolicitudDetalle"),
        	record;  
        	form.updateRecord();        	
        	record = form.getRecord();
        	
        	me.getView().fireEvent("guardarsolicitud", me.getView(), record);	

        },
        
        onCancelClick: function(button) {
        	
        	var me = this;
        	
        	Ext.Msg.show({
			    title:'Cancelar edición',
			    message: '¿Está seguro que desea cerrar la ventana?',
			    buttons: Ext.Msg.YESNO,
			    icon: Ext.Msg.QUESTION,
			    fn: function(btn) {
			        if (btn === 'yes') {			        	
			        	me.getView().up('window').destroy();
			        }
			    }
			});    	
        	
        } ,
        
        onChangeCheckboxPresentarOferta: function(chkBox, newValue) {
        	
        	var me = this,
        	fieldOferta = me.lookupReference("textfieldOferta");

        	if (newValue) {
        		fieldOferta.setDisabled(false)        		
        	} else {
        		fieldOferta.setDisabled(true);
        		fieldOferta.setValue("");
        	}
        }
});